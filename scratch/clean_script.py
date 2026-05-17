# -*- coding: utf-8 -*-
import re

# Read the file (check UTF-16 first, then UTF-8)
file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

try:
    with open(file_path, 'r', encoding='utf-16') as f:
        content = f.read()
    print("Opened with UTF-16 successfully")
    encoding = 'utf-16'
except UnicodeError:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    print("Opened with UTF-8 successfully")
    encoding = 'utf-8'

# Let's find all KhachHang rows with password 'iloveyou'
kh_pattern = re.compile(r"INSERT\s+\[dbo\]\.\[KhachHang\].*?VALUES\s*\((.*?)\)", re.IGNORECASE)
lines = content.split('\n')

iloveyou_makhs = set()
for idx, line in enumerate(lines):
    if "INSERT [dbo].[KhachHang]" in line:
        # Match VALUES
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            # Split values carefully, accounting for N'...'
            # A simple regex split on commas not inside quotes:
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                makh = vals[0].replace("N'", "").replace("'", "")
                pwd = vals[1].replace("N'", "").replace("'", "")
                if pwd == "iloveyou":
                    iloveyou_makhs.add(makh)

print(f"Found {len(iloveyou_makhs)} KhachHang records with password 'iloveyou'")
print("Examples:", list(iloveyou_makhs)[:10])

# Let's check which HoaDon rows reference these MaKHs
hd_referencing = []
hd_ids = set()
for idx, line in enumerate(lines):
    if "INSERT [dbo].[HoaDon]" in line:
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                mahd = vals[0]
                makh = vals[1].replace("N'", "").replace("'", "")
                if makh in iloveyou_makhs:
                    hd_referencing.append((idx, line, mahd, makh))
                    hd_ids.add(mahd)

print(f"Found {len(hd_referencing)} HoaDon rows referencing 'iloveyou' KhachHangs")
print(f"Referencing HoaDon IDs: {hd_ids}")

# Let's check which ChiTietHD rows reference these HoaDons
cthd_referencing = []
for idx, line in enumerate(lines):
    if "INSERT [dbo].[ChiTietHD]" in line:
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 1:
                mahd = vals[0]
                if mahd in hd_ids:
                    cthd_referencing.append((idx, line, mahd))

print(f"Found {len(cthd_referencing)} ChiTietHD rows referencing these HoaDons")
