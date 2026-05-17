# -*- coding: utf-8 -*-
import re

file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

# Step 1: Find all KhachHang usernames (MaKH) that have the password 'iloveyou'
iloveyou_makhs = set()
kh_removed_count = 0
kh_inserted_count = 0

for line in lines:
    if "INSERT [dbo].[KhachHang]" in line:
        kh_inserted_count += 1
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            # Find values (either N'...', '...', digits, or NULL)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                makh = vals[0].replace("N'", "").replace("'", "")
                pwd = vals[1].replace("N'", "").replace("'", "")
                if pwd == "iloveyou":
                    iloveyou_makhs.add(makh)

print(f"Found {len(iloveyou_makhs)} KhachHang records with password 'iloveyou' (out of {kh_inserted_count} total).")

# Step 2: Find all HoaDon IDs (MaHD) that reference these MaKHs
iloveyou_mahds = set()
hd_inserted_count = 0

for line in lines:
    if "INSERT [dbo].[HoaDon]" in line:
        hd_inserted_count += 1
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                mahd = vals[0]
                makh = vals[1].replace("N'", "").replace("'", "")
                if makh in iloveyou_makhs:
                    iloveyou_mahds.add(mahd)

print(f"Found {len(iloveyou_mahds)} HoaDon records referencing these KhachHangs (out of {hd_inserted_count} total).")

# Step 3: Filter the lines
new_lines = []
removed_kh_lines = 0
removed_hd_lines = 0
removed_cthd_lines = 0
cthd_inserted_count = 0

for line in lines:
    # 1. Filter KhachHang
    if "INSERT [dbo].[KhachHang]" in line:
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                makh = vals[0].replace("N'", "").replace("'", "")
                pwd = vals[1].replace("N'", "").replace("'", "")
                if pwd == "iloveyou":
                    removed_kh_lines += 1
                    continue # Skip this line
    
    # 2. Filter HoaDon
    elif "INSERT [dbo].[HoaDon]" in line:
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                mahd = vals[0]
                makh = vals[1].replace("N'", "").replace("'", "")
                if makh in iloveyou_makhs:
                    removed_hd_lines += 1
                    continue # Skip this line

    # 3. Filter ChiTietHD
    elif "INSERT [dbo].[ChiTietHD]" in line:
        cthd_inserted_count += 1
        match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        if match:
            vals_str = match.group(1)
            vals = re.findall(r"N?'[^']*'|\d+|NULL", vals_str)
            if len(vals) >= 2:
                mahd = vals[1] # The second column is MaHD
                if mahd in iloveyou_mahds:
                    removed_cthd_lines += 1
                    continue # Skip this line

    new_lines.append(line)

print(f"Removed {removed_kh_lines} KhachHang lines.")
print(f"Removed {removed_hd_lines} HoaDon lines.")
print(f"Removed {removed_cthd_lines} ChiTietHD lines (out of {cthd_inserted_count} total).")

# Save cleaned content back to file
cleaned_content = '\n'.join(new_lines)
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(cleaned_content)

print("HShopScript.sql successfully updated and cleaned!")
