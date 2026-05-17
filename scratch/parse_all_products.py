# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    content = f.read()

import re
import csv
import io
import json

lines = content.split('\n')
products = []
for idx, line in enumerate(lines):
    if "INSERT [dbo].[HangHoa]" in line:
        parts = line.split("VALUES (")
        if len(parts) > 1:
            vals_str = parts[1].rstrip(')').strip()
            reader = csv.reader(io.StringIO(vals_str), delimiter=',', quotechar="'", skipinitialspace=True)
            try:
                row = next(reader)
                mahh = int(row[0].strip())
                tenhh = row[1].replace("N'", "'").strip("'").strip()
                maloai = int(row[3].strip())
                products.append({
                    "MaHH": mahh,
                    "TenHH": tenhh,
                    "MaLoai": maloai
                })
            except Exception as e:
                pass

print(f"Parsed {len(products)} products.")
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\parsed_products.json", 'w', encoding='utf-8') as f_out:
    json.dump(products, f_out, ensure_ascii=False, indent=4)
print("Products saved to parsed_products.json")
