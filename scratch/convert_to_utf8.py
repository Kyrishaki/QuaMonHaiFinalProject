sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# Read in UTF-16 LE
with open(sql_path, "r", encoding="utf-16-le") as f:
    content = f.read()

# Write in UTF-8
with open(sql_path, "w", encoding="utf-8") as f:
    f.write(content)

print("Successfully converted HShopScript.sql to UTF-8 encoding!")
