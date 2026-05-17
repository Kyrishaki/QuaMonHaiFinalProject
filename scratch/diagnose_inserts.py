import os
import re

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# Read UTF-16 LE file
with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

# Let's find all INSERT [dbo].[HangHoa] statements
pattern = re.compile(r"(INSERT\s+\[dbo\]\.\[HangHoa\].*?)(?=INSERT\s+\[dbo\]|GO|/\*\*\*\*\*\*)", re.DOTALL | re.IGNORECASE)
matches = pattern.findall(sql_text)

print(f"Total inserts found: {len(matches)}")
for idx, match in enumerate(matches):
    ins = match.strip()
    values_match = re.search(r"VALUES\s*\((.*)\)", ins, re.DOTALL | re.IGNORECASE)
    if not values_match:
        print(f"Index {idx} failed values_match: {ins[:100]}...")
        continue
    
    vals_str = values_match.group(1).strip()
    tokens = []
    current = []
    in_str = False
    i = 0
    while i < len(vals_str):
        char = vals_str[i]
        if char == "'":
            if i + 1 < len(vals_str) and vals_str[i+1] == "'":
                current.append("'")
                current.append("'")
                i += 2
                continue
            in_str = not in_str
            current.append(char)
        elif char == "," and not in_str:
            tokens.append("".join(current).strip())
            current = []
        else:
            current.append(char)
        i += 1
    if current:
        tokens.append("".join(current).strip())
    
    if len(tokens) < 7:
        print(f"Index {idx} has fewer than 7 tokens: {tokens}")
