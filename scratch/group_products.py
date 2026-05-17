import re
from collections import defaultdict

sql_path = "HShopScript.sql"

with open(sql_path, "r", encoding="utf-8") as f:
    content = f.read()

# Match HangHoa inserts
pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)", re.IGNORECASE)
matches = pattern.findall(content)

categories = {
    "1000": "Đồng hồ",
    "1001": "Laptop",
    "1002": "Máy ảnh",
    "1003": "Điện thoại",
    "1004": "Nước hoa",
    "1005": "Trang sức",
    "1006": "Giày",
    "1007": "Vali"
}

by_category = defaultdict(list)

for i, match in enumerate(matches):
    vals_str = match.strip()
    tokens = []
    current = []
    in_str = False
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
        elif char == "," and not in_str:
            tokens.append("".join(current).strip())
            current = []
        else:
            current.append(char)
        idx += 1
    if current:
        tokens.append("".join(current).strip())
    
    if len(tokens) >= 8:
        ma_hh = tokens[0]
        ten_hh = tokens[1].strip("N'").strip("'")
        ma_loai = tokens[3]
        hinh = tokens[6].strip("N'").strip("'")
        # We can extract MaNCC from the end of tokens
        # Since it is after NgaySX (CAST), we can check tokens[11] or token containing the supplier
        # Let's find the last token
        ma_ncc = tokens[-1].strip("N'").strip("'").strip(")")
        by_category[ma_loai].append((ma_hh, ten_hh, hinh, ma_ncc))

out_lines = []
for cat_id in sorted(by_category.keys()):
    cat_name = categories.get(cat_id, f"Unknown ({cat_id})")
    out_lines.append(f"=== Category {cat_id}: {cat_name} (Total: {len(by_category[cat_id])}) ===")
    for ma_hh, ten_hh, hinh, ma_ncc in by_category[cat_id]:
        out_lines.append(f"  ID={ma_hh} | Image=\"{hinh}\" | Supplier={ma_ncc} | Name=\"{ten_hh}\"")
    out_lines.append("")

with open("scratch/products_grouped.txt", "w", encoding="utf-8") as out_f:
    out_f.write("\n".join(out_lines))

print("Successfully wrote grouped products to scratch/products_grouped.txt")
