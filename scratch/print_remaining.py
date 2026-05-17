# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    if "INSERT [dbo].[KhachHang]" in line:
        print(f"Line {idx+1}: {line}")
    if "INSERT [dbo].[HoaDon]" in line:
        print(f"Line {idx+1}: {line}")
    if "INSERT [dbo].[ChiTietHD]" in line:
        print(f"Line {idx+1}: {line}")
