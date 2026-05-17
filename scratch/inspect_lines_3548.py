sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

print(f"Total lines in HShopScript.sql: {len(lines)}")
out_lines = []
for i in range(3529, min(3580, len(lines))):
    out_lines.append(f"{i+1}: {lines[i].strip()}")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\inspected_lines_3548.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print("Successfully wrote lines to inspected_lines_3548.txt")
