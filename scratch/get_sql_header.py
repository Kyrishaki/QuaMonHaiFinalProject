sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-16-le") as f:
    lines = [f.readline() for _ in range(100)]

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\sql_header_utf8.txt", "w", encoding="utf-8") as f:
    f.writelines(lines)

print("Successfully wrote SQL header to sql_header_utf8.txt")
