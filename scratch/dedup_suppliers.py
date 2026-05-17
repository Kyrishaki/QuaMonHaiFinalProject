import re

sql_path = "HShopScript.sql"

with open(sql_path, "r", encoding="utf-8-sig") as f:
    lines = f.readlines()

new_lines = []
seen_suppliers = set()
dup_count = 0

for line in lines:
    if "INSERT [dbo].[NhaCungCap]" in line or "INSERT INTO [dbo].[NhaCungCap]" in line:
        # Extract supplier code, e.g., VALUES (N'AP', ...
        match = re.search(r"VALUES\s*\(\s*N'([^']*)'", line, re.IGNORECASE)
        if match:
            code = match.group(1)
            if code in seen_suppliers:
                print(f"Skipping duplicate supplier insert: {code}")
                dup_count += 1
                continue
            seen_suppliers.add(code)
    new_lines.append(line)

with open(sql_path, "w", encoding="utf-8-sig") as f:
    f.writelines(new_lines)

print(f"Deduplication completed. Removed {dup_count} duplicate rows.")
