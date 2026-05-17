# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    lines = f.readlines()

count = 0
for line in lines:
    if "INSERT [dbo].[ChiTietHD]" in line:
        print(line)
        count += 1
        if count >= 10:
            break
