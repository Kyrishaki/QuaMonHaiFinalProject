# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\remaining_inserts.txt", 'w', encoding='utf-8') as f_out:
    for idx, line in enumerate(lines):
        if "INSERT [dbo].[KhachHang]" in line:
            f_out.write(f"Line {idx+1}: {line}\n")
        if "INSERT [dbo].[HoaDon]" in line:
            f_out.write(f"Line {idx+1}: {line}\n")
        if "INSERT [dbo].[ChiTietHD]" in line:
            f_out.write(f"Line {idx+1}: {line}\n")

print("Verification logged successfully!")
