import subprocess
import re

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# 1. Parse HShopScript.sql
with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)(?=\s*(?:INSERT|GO|/\*\*|$))", re.DOTALL | re.IGNORECASE)
matches = pattern.findall(sql_text)

sql_products = {}
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
        ma_hh = int(tokens[0])
        ten_hh = tokens[1].strip("N'").strip("'")
        ma_loai = int(tokens[3])
        hinh = tokens[6].strip("N'").strip("'")
        sql_products[ma_hh] = {
            "ten_hh": ten_hh,
            "ma_loai": ma_loai,
            "hinh": hinh
        }

# 2. Query Local DB using sqlcmd
# Request UTF-8 output from sqlcmd by using -f 65001 or we can just read as ANSI/mbcs and print
# Let's request codepage 65001 (UTF-8) from sqlcmd using command line: -u or similar
# Actually, sqlcmd -o writes whatever SQL Server returns.
# Let's run sqlcmd with -u to write unicode output! That will preserve Vietnamese characters.
cmd = 'sqlcmd -S localhost -U sa -P 123456 -d Hshop2023 -Q "SELECT MaHH, TenHH, MaLoai, Hinh FROM HangHoa" -W -s "," -u'
res = subprocess.run(cmd, shell=True, capture_output=True)

# sqlcmd -u outputs UTF-16 LE by default!
try:
    stdout_text = res.stdout.decode('utf-16')
except Exception:
    stdout_text = res.stdout.decode('utf-8', errors='ignore')

lines = stdout_text.splitlines()

db_products = {}
for line in lines[2:]:
    if not line.strip() or line.startswith("(") or line.startswith("-"):
        continue
    parts = line.split(",")
    if len(parts) >= 4:
        try:
            ma_hh = int(parts[0])
            ten_hh = parts[1]
            ma_loai = int(parts[2])
            hinh = parts[3]
            db_products[ma_hh] = {
                "ten_hh": ten_hh,
                "ma_loai": ma_loai,
                "hinh": hinh
            }
        except ValueError:
            continue

# 3. Compare them
out_lines = []
out_lines.append(f"Total SQL products parsed: {len(sql_products)}")
out_lines.append(f"Total DB products parsed: {len(db_products)}")

all_ids = sorted(list(set(sql_products.keys()) | set(db_products.keys())))
out_lines.append(f"Total unique IDs: {len(all_ids)}")

diff_count = 0
for ma in all_ids:
    in_sql = ma in sql_products
    in_db = ma in db_products
    if not in_sql:
        out_lines.append(f"MaHH {ma} only in Local DB: {db_products[ma]}")
        diff_count += 1
    elif not in_db:
        out_lines.append(f"MaHH {ma} only in SQL script: {sql_products[ma]}")
        diff_count += 1
    else:
        sql_item = sql_products[ma]
        db_item = db_products[ma]
        
        # Let's clean up any string weirdness
        sql_name = sql_item["ten_hh"].strip()
        db_name = db_item["ten_hh"].strip()
        
        if sql_name != db_name or sql_item["ma_loai"] != db_item["ma_loai"] or sql_item["hinh"] != db_item["hinh"]:
            out_lines.append(f"MaHH {ma}:")
            if sql_name != db_name:
                out_lines.append(f"  Name: SQL='{sql_name}' vs DB='{db_name}'")
            if sql_item["ma_loai"] != db_item["ma_loai"]:
                out_lines.append(f"  Category: SQL={sql_item['ma_loai']} vs DB={db_item['ma_loai']}")
            if sql_item["hinh"] != db_item["hinh"]:
                out_lines.append(f"  Image: SQL='{sql_item['hinh']}' vs DB='{db_item['hinh']}'")
            diff_count += 1

out_lines.append(f"\nTotal different products: {diff_count}")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\comparison_report.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print("Successfully wrote comparison report to comparison_report.txt")
