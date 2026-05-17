import re

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

# Let's find insert for 1001
pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\(\s*1001\s*,.*?\)(?=\s*(?:INSERT|GO|/\*\*|$))", re.DOTALL | re.IGNORECASE)
matches = pattern.findall(sql_text)

print(f"Matches found: {len(matches)}")
for m in matches:
    print(m.strip())
