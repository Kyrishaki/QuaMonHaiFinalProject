import re

sql_path = "HShopScript.sql"
output_path = "UpdateHangHoa.sql"

# Read original SQL file
with open(sql_path, "r", encoding="utf-8-sig") as f:
    sql_content = f.read()

# Define the new column check and new suppliers check
header_checks = """-- 1. THÊM CỘT SOLUONG VÀO BẢNG HANGHOA NẾU CHƯA CÓ
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[HangHoa]') AND name = N'SoLuong')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD [SoLuong] INT NOT NULL DEFAULT 100;
END
GO

-- 2. THÊM NHÀ CUNG CẤP MỚI NẾU CHƯA TỒN TẠI
IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'DE')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'DE', N'Dell Inc.', N'dell-logo.jpg', N'Michael Dell', N'contact@dell.com', N'0987111222', N'One Dell Way, Round Rock, Texas, US', N'Dell Premium Laptops and Computers')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'HP')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'HP', N'HP Inc.', N'hp-logo.jpg', N'Enrique Lores', N'contact@hp.com', N'0987333444', N'Palo Alto, California, US', N'HP Invent Laptops and Digital Devices')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'AC')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'AC', N'Acer Inc.', N'Acer_logo-300x300.gif', N'Jason Chen', N'contact@acer.com', N'0987555666', N'New Taipei City, Taiwan', N'Acer Explore Beyond Limits Laptops')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'SE')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'SE', N'Sony Ericsson', N'sonny-ericsson.jpg', N'Sony CEO', N'contact@sony.com', N'0987777888', N'Tokyo, Japan', N'Sony Mobile and Electronics Devices')
END
GO
"""

update_statements = []

all_sql_lines = sql_content.splitlines()

for line in all_sql_lines:
    if "INSERT [dbo].[HangHoa]" in line or "INSERT INTO [dbo].[HangHoa]" in line:
        val_match = re.search(r"VALUES\s*\((.*)\)\s*$", line.strip(), re.IGNORECASE)
        if not val_match:
            val_match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        
        if val_match:
            vals_str = val_match.group(1).strip()
            # Tokenize values correctly
            tokens = []
            current = []
            in_str = False
            paren_depth = 0
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
                elif char == "(" and not in_str:
                    paren_depth += 1
                    current.append(char)
                elif char == ")" and not in_str:
                    paren_depth -= 1
                    current.append(char)
                elif char == "," and not in_str and paren_depth == 0:
                    tokens.append("".join(current).strip())
                    current = []
                else:
                    current.append(char)
                i += 1
            if current:
                tokens.append("".join(current).strip())
            
            if len(tokens) >= 12:
                ma_hh = tokens[0]
                ten_hh = tokens[1]
                ten_alias = tokens[2]
                ma_loai = tokens[3]
                ma_ncc = tokens[11].split()[0] # clean up trailing paren if any
                
                # Generate a realistic stock quantity deterministically based on product ID
                ma_hh_int = int(ma_hh)
                stock_qty = ((ma_hh_int * 7) % 13) * 10 + 15  # Yields values: 15, 25, 35, 45, 55, 65, ..., 135
                
                update_sql = f"UPDATE [dbo].[HangHoa] SET [TenHH] = {ten_hh}, [TenAlias] = {ten_alias}, [MaLoai] = {ma_loai}, [MaNCC] = {ma_ncc}, [SoLuong] = {stock_qty} WHERE [MaHH] = {ma_hh};"
                update_statements.append(update_sql)

# Reconstruct the update SQL file with UTF-8 BOM
with open(output_path, "w", encoding="utf-8-sig") as f:
    f.write("USE [Hshop2023]\nGO\n\n")
    f.write(header_checks)
    f.write("\n-- 3. CẬP NHẬT THÔNG TIN HÀNG HÓA VÀ SỐ LƯỢNG CHUẨN THEO ẢNH\n")
    f.write("\n".join(update_statements))
    f.write("\n\nGO\n")

print(f"Successfully generated {output_path} with SoLuong support containing {len(update_statements)} UPDATE statements!")
