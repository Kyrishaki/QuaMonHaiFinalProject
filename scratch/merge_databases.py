# -*- coding: utf-8 -*-
import re

file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"
update_file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\UpdateHangHoa.sql"
output_file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript_Combined.sql"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

with open(update_file_path, 'r', encoding='utf-8') as f:
    update_content = f.read()

# Let's split content into logical parts.
# The script is separated by 'GO' statements.
raw_batches = content.split('\nGO\n')
if len(raw_batches) == 1:
    raw_batches = content.split('\ngo\n')
if len(raw_batches) == 1:
    raw_batches = content.split('\nGo\n')

print(f"Total raw batches: {len(raw_batches)}")

new_batches = []

# Database creation header replacement
# The first batch usually has USE [master] and CREATE DATABASE
header_batch = """USE [master]
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Hshop2023')
BEGIN
    CREATE DATABASE Hshop2023;
END;"""
new_batches.append(header_batch)
new_batches.append("USE [Hshop2023]")

# Let's inspect other batches
import collections
inserts_by_table = collections.defaultdict(list)
identity_toggles = collections.defaultdict(list)

# We want to keep track of the order of tables to insert
table_insert_order = []

for batch in raw_batches:
    batch = batch.strip()
    if not batch:
        continue
    
    # Skip the original database drop/create master stuff
    if "DROP DATABASE Hshop2023" in batch or "CREATE DATABASE Hshop2023" in batch or "USE [master]" in batch or "USE [Hshop2023]" in batch:
        continue
    
    # 1. Check if it's a CREATE TABLE batch
    if "CREATE TABLE" in batch:
        table_name_match = re.search(r"CREATE TABLE\s+\[dbo\]\.\[([^\]]+)\]", batch, re.IGNORECASE)
        if table_name_match:
            table_name = table_name_match.group(1)
            # Wrap CREATE TABLE in IF NOT EXISTS
            safe_create = f"""IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[{table_name}]') AND type in (N'U'))
BEGIN
{batch}
END"""
            new_batches.append(safe_create)
            continue
            
    # 2. Check if it's a CREATE VIEW batch
    if "CREATE VIEW" in batch:
        view_name_match = re.search(r"CREATE VIEW\s+\[dbo\]\.\[([^\]]+)\]", batch, re.IGNORECASE)
        if view_name_match:
            view_name = view_name_match.group(1)
            # Wrap CREATE VIEW in IF NOT EXISTS using sp_executesql to avoid query batch compilation errors
            escaped_batch = batch.replace("'", "''")
            safe_view = f"""IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[{view_name}]'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'{escaped_batch}'
END"""
            new_batches.append(safe_view)
            continue

    # 3. Check if it's an ALTER TABLE batch (constraints)
    if "ALTER TABLE" in batch:
        # e.g., ALTER TABLE [dbo].[BanBe] ADD CONSTRAINT [DF_Promotions_Sent] DEFAULT (getdate()) FOR [NgayGui]
        # or ALTER TABLE [dbo].[BanBe] WITH CHECK ADD CONSTRAINT [FK_BanBe_KhachHang] ...
        constraint_match = re.search(r"ADD\s+CONSTRAINT\s+\[([^\]]+)\]", batch, re.IGNORECASE)
        if constraint_match:
            constraint_name = constraint_match.group(1)
            safe_alter = f"""IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = '{constraint_name}')
BEGIN
    {batch}
END"""
            new_batches.append(safe_alter)
            continue

    # 4. Check if it's an INSERT statement or IDENTITY_INSERT toggle
    if "INSERT [dbo]." in batch or "SET IDENTITY_INSERT" in batch:
        # We will parse individual lines of this batch
        lines = batch.split('\n')
        current_table = None
        for line in lines:
            line_str = line.strip()
            if not line_str:
                continue
            
            # Match insert
            insert_match = re.search(r"INSERT\s+\[dbo\]\.\[([^\]]+)\]", line_str, re.IGNORECASE)
            if insert_match:
                current_table = insert_match.group(1)
                if current_table not in table_insert_order:
                    table_insert_order.append(current_table)
                inserts_by_table[current_table].append(line_str)
            
            # Match identity insert toggle
            elif "SET IDENTITY_INSERT" in line_str:
                id_match = re.search(r"SET IDENTITY_INSERT\s+\[dbo\]\.\[([^\]]+)\]\s+(ON|OFF)", line_str, re.IGNORECASE)
                if id_match:
                    t_name = id_match.group(1)
                    state = id_match.group(2).upper()
                    identity_toggles[t_name].append((state, line_str))
        continue
        
    # Any other batch (like ANSI settings, standard system triggers, etc.)
    new_batches.append(batch)

# Now let's reconstruct the INSERT batches for each table
for table_name in table_insert_order:
    table_inserts = inserts_by_table[table_name]
    if not table_inserts:
        continue
    
    # We want to check if the table is empty before inserting
    insert_lines = []
    
    # Add ON toggle if it was present
    toggles = identity_toggles[table_name]
    on_toggle = [t[1] for t in toggles if t[0] == "ON"]
    off_toggle = [t[1] for t in toggles if t[0] == "OFF"]
    
    if on_toggle:
        insert_lines.append(on_toggle[0])
    
    insert_lines.extend(table_inserts)
    
    if off_toggle:
        insert_lines.append(off_toggle[0])
        
    # Wrap all these in IF NOT EXISTS (SELECT 1 FROM [dbo].[TableName])
    joined_inserts = '\n    '.join(insert_lines)
    safe_insert_batch = f"""IF NOT EXISTS (SELECT 1 FROM [dbo].[{table_name}])
BEGIN
    {joined_inserts}
END"""
    new_batches.append(safe_insert_batch)

# Now let's append the Update SQL at the end of the script!
# We will clean the Update SQL from USE and master/GO lines, and put them inside the final script.
update_batches = update_content.split('\nGO\n')
if len(update_batches) == 1:
    update_batches = update_content.split('\ngo\n')

new_batches.append("/* =================================================== */")
new_batches.append("/*             DATABASE MIGRATIONS & UPDATES            */")
new_batches.append("/* =================================================== */")

for u_batch in update_batches:
    u_batch = u_batch.strip()
    if not u_batch:
        continue
    if "USE [Hshop2023]" in u_batch or "USE Hshop2023" in u_batch:
        continue
    new_batches.append(u_batch)

# Save the combined content
combined_sql = '\n\nGO\n\n'.join(new_batches)
with open(output_file_path, 'w', encoding='utf-8') as f:
    f.write(combined_sql)

print(f"Combined database script successfully created at {output_file_path}!")
