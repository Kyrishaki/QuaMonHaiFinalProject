sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"
inserts_path = r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\extracted_inserts.txt"

# 1. Read the new inserts
with open(inserts_path, "r", encoding="utf-16") as f:
    new_inserts = f.readlines()

# Ensure each insert line has a newline
new_inserts = [line.rstrip() + "\n" for line in new_inserts]
print(f"Loaded {len(new_inserts)} new insert statements.")

# 2. Read HShopScript.sql
with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_lines = f.readlines()

print(f"Original SQL script lines count: {len(sql_lines)}")

# 3. Find boundaries
start_idx = -1
end_idx = -1

for i, line in enumerate(sql_lines):
    if "SET IDENTITY_INSERT [dbo].[HangHoa] ON" in line:
        start_idx = i
    elif "SET IDENTITY_INSERT [dbo].[HangHoa] OFF" in line:
        end_idx = i

if start_idx == -1 or end_idx == -1:
    raise Exception("Could not find start or end index for HangHoa inserts setup.")

print(f"Start index: {start_idx} (Line {start_idx+1})")
print(f"End index: {end_idx} (Line {end_idx+1})")

# 4. Construct new SQL lines
# Slice: up to start_idx (inclusive), then new_inserts, then from end_idx (inclusive) onwards
new_sql_lines = sql_lines[:start_idx + 1] + new_inserts + sql_lines[end_idx:]

print(f"New SQL script lines count: {len(new_sql_lines)}")

# 5. Write back to HShopScript.sql
with open(sql_path, "w", encoding="utf-16-le") as f:
    f.writelines(new_sql_lines)

print("Successfully updated HShopScript.sql with correct Vietnamese product inserts!")
