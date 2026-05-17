import re

sql_path = "HShopScript.sql"

with open(sql_path, "r", encoding="utf-8") as f:
    content = f.read()

pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)", re.IGNORECASE)
matches = pattern.findall(content)
print(f"Total products in HShopScript.sql: {len(matches)}")

from collections import Counter

# Parse values list by looking for the content after 'VALUES (' up to the last ')'
for i, match in enumerate(matches):
    vals_str = match.strip()
    # Find the outer parentheses content
    # Since match is just the content inside the first pattern match, let's look at the full SQL lines!
    pass

# A much better way: read the file line by line and find lines containing 'INSERT [dbo].[HangHoa]'
out_lines = []
ncc_list = []
import re
with open(sql_path, "r", encoding="utf-8") as f:
    for line_num, line in enumerate(f, 1):
        if "INSERT [dbo].[HangHoa]" in line or "INSERT INTO [dbo].[HangHoa]" in line:
            # Find the VALUES part
            val_match = re.search(r"VALUES\s*\((.*)\)\s*$", line.strip(), re.IGNORECASE)
            if not val_match:
                val_match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
            if val_match:
                vals_str = val_match.group(1).strip()
                # Parse tokens, paying attention to quotes and parentheses
                tokens = []
                current = []
                in_str = False
                paren_depth = 0
                idx = 0
                while idx < len(vals_str):
                    char = vals_str[idx]
                    if char == "'":
                        if idx + 1 < len(vals_str) and vals_str[idx+1] == "'":
                            current.append("'")
                            current.append("'")
                            idx += 2
                            continue
                        in_str = not in_str
                        current.append(char)
                    elif char == "(" and not in_str:
                        paren_depth += 1
                        current.append(char)
                    elif char == ")" and not in_str:
                        paren_depth -= 1
                        current.append(char)
                    elif char == "," and not in_str and paren_depth == 0:
                        tokens.append("".join(current).strip())
                        current = []
                    else:
                        current.append(char)
                    idx += 1
                if current:
                    tokens.append("".join(current).strip())
                
                if len(tokens) >= 12:
                    ma_hh = tokens[0]
                    ten_hh = tokens[1].strip("N'").strip("'")
                    ma_loai = tokens[3]
                    hinh = tokens[6].strip("N'").strip("'")
                    ma_ncc = tokens[11].strip("N'").strip("'")
                    ncc_list.append(ma_ncc)
                    out_lines.append(f'{ma_hh}: Name="{ten_hh}", Category={ma_loai}, Image="{hinh}", Supplier="{ma_ncc}"')
                else:
                    out_lines.append(f"Line {line_num} has only {len(tokens)} tokens: {tokens}")

with open("scratch/all_parsed_products.txt", "w", encoding="utf-8") as out_f:
    out_f.write("\n".join(out_lines))

print("Supplier counts in HangHoa table:")
print(Counter(ncc_list))




