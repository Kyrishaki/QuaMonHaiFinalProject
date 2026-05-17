sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-16-le") as f:
    lines = f.readlines()

out_lines = []
out_lines.append(f"Total lines in HShopScript.sql: {len(lines)}")
out_lines.append("Lines 2520 to 2620:")
for i in range(2519, min(2620, len(lines))):
    out_lines.append(f"{i+1}: {lines[i].strip()}")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\sql_lines_output.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print("Successfully wrote SQL lines to sql_lines_output.txt")
