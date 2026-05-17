# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    content = f.read()

import re
matches = re.findall(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)", content, re.IGNORECASE)
print(f"Found {len(matches)} HangHoa inserts.")
for m in matches[:10]:
    vals = re.findall(r"N?'[^']*'|\d+|NULL", m)
    mahh = vals[0]
    tenhh = vals[1].replace("N'", "").replace("'", "")
    mota = vals[10].replace("N'", "").replace("'", "")
    print(f"ID: {mahh} - Name: {tenhh} - Description starts with: {mota[:50]}...")
