import os
import re
import sys

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# Read UTF-16 LE file
with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

# Let's find all INSERT [dbo].[HangHoa] statements
pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)(?=\s*(?:INSERT|GO|/\*\*|$))", re.DOTALL | re.IGNORECASE)
matches = pattern.findall(sql_text)

out_lines = []
out_lines.append(f"Total inserts found: {len(matches)}")

for idx, match in enumerate(matches):
    vals_str = match.strip()
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
    
    if len(tokens) >= 7:
        ma_hh = tokens[0]
        ten_hh = tokens[1]
        hinh = tokens[6]
        out_lines.append(f"{idx+1}: MaHH={ma_hh}, TenHH={ten_hh}, Hinh={hinh}")
    else:
        out_lines.append(f"{idx+1}: Error parsing fields: {tokens}")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\parsed_inserts.txt", "w", encoding="utf-8") as out_f:
    out_f.write("\n".join(out_lines))

print("Successfully wrote parsed inserts to parsed_inserts.txt")
