import os
import re

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"
img_dir = r"h:\App\GitHub\QuaMonHaiFinalProject\wwwroot\img\Hinh\HangHoa"

# Read UTF-16 LE file
with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

# List all files in the image directory
img_files = set(os.listdir(img_dir))
print(f"Total image files in folder: {len(img_files)}")

# Find all occurrences of INSERT [dbo].[HangHoa] up to the next INSERT or GO or whatever
# We can find all: INSERT [dbo].[HangHoa] ... VALUES ( ... )
# Let's use a regex to find all INSERT [dbo].[HangHoa] statements
# Since the description (MoTa) might contain parentheses, let's be careful.
# Usually, each insert starts with `INSERT [dbo].[HangHoa] ` and ends before the next `INSERT ` or `GO` or `/******`
pattern = re.compile(r"(INSERT\s+\[dbo\]\.\[HangHoa\].*?)(?=INSERT\s+\[dbo\]|GO|/\*\*\*\*\*\*)", re.DOTALL | re.IGNORECASE)
inserts = pattern.findall(sql_text)

print(f"Regex found {len(inserts)} HangHoa inserts.")

parsed_items = []
for idx, ins in enumerate(inserts):
    # Parse MaHH, TenHH, Hinh
    # Let's extract values inside VALUES (...)
    # Since there are newlines and long strings, let's extract the VALUES part using a robust pattern
    # Values part starts with: VALUES (
    values_match = re.search(r"VALUES\s*\((.*)\)\s*$", ins.strip(), re.DOTALL | re.IGNORECASE)
    if not values_match:
        # Try without strict ending $
        values_match = re.search(r"VALUES\s*\((.*)\)", ins, re.DOTALL | re.IGNORECASE)
    
    if values_match:
        vals_str = values_match.group(1).strip()
        # Parse SQL values list
        tokens = []
        current = []
        in_str = False
        i = 0
        while i < len(vals_str):
            char = vals_str[i]
            if char == "'":
                # handle escaped single quotes (e.g. '')
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
            ten_hh = tokens[1].strip("N'").strip("'")
            hinh = tokens[6].strip("N'").strip("'")
            parsed_items.append({
                "ma_hh": ma_hh,
                "ten_hh": ten_hh,
                "hinh": hinh,
                "original_insert": ins
            })
        else:
            print(f"Insert {idx} had too few tokens: {len(tokens)}")
    else:
        print(f"Insert {idx} failed to find VALUES")

print(f"Successfully parsed {len(parsed_items)} items.")

# Check missing images
missing = []
for item in parsed_items:
    hinh = item["hinh"]
    if hinh not in img_files:
        missing.append(item)

print(f"Missing images in folder: {len(missing)}")
for m in missing:
    print(f"MaHH={m['ma_hh']}, TenHH={m['ten_hh']}, Hinh={m['hinh']}")

print("\nUnused image files in folder:")
used_filenames = {item["hinh"] for item in parsed_items}
unused = [f for f in img_files if f not in used_filenames]
print(unused)
