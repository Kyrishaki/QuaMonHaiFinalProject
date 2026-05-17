# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    lines = f.readlines()

for idx, line in enumerate(lines):
    if "INSERT [dbo].[HangHoa]" in line:
        print(f"Line {idx+1}: {line[:120]}...")
        # Break after printing a few
        # count it
