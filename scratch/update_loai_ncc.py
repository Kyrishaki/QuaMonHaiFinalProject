sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# Read in UTF-8
with open(sql_path, "r", encoding="utf-8") as f:
    sql_text = f.read()

# 1. Categories (Loai) replacement definitions
old_loai_block = """INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1000, N'Đồng hồ', N'dong-ho', N'Soft drinks, coffees, teas, beers, and ales', N'Best.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1001, N'Laptop', N'lap-top', N'Sweet and savory sauces, relishes, spreads, and seasonings', N'Certificate.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1002, N'Máy ảnh', N'may-anh', N'Desserts, candies, and sweet breads', N'')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1003, N'Điện thoại', N'dien-thoai', N'Cheeses', N'Bell.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1004, N'Nước hoa', N'nuoc-hoa', N'Breads, crackers, pasta, and cereal', N'Favourites.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1005, N'Trang sức', N'trang-suc', N'Prepared meats', N'Dice.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1006, N'Giày', N'giay', N'Dried fruit and bean curd', N'')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1007, N'Vali', N'vali', N'Seaweed and fish', N'Microsoft.png')"""

new_loai_block = """INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1000, N'Đồng hồ', N'dong-ho', N'Các loại đồng hồ thời trang, đồng hồ thông minh và đồng hồ cao cấp chính hãng.', N'Best.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1001, N'Laptop', N'lap-top', N'Máy tính xách tay cấu hình cao, laptop văn phòng, laptop gaming thiết kế hiện đại.', N'Certificate.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1002, N'Máy ảnh', N'may-anh', N'Máy ảnh chuyên nghiệp, máy ảnh kỹ thuật số, ống kính và phụ kiện chụp ảnh.', N'')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1003, N'Điện thoại', N'dien-thoai', N'Điện thoại di động thông minh, máy tính bảng và các thiết bị liên lạc hiện đại.', N'Bell.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1004, N'Nước hoa', N'nuoc-hoa', N'Nước hoa cao cấp, nước hoa quyến rũ dành cho nam và nữ chính hãng.', N'Favourites.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1005, N'Trang sức', N'trang-suc', N'Trang sức cao cấp, nhẫn, vòng cổ, khuyên tai đính đá quý sang trọng.', N'Dice.png')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1006, N'Giày', N'giay', N'Giày bốt thời trang, giày thể thao, giày da nam nữ chất lượng cao.', N'')
INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1007, N'Vali', N'vali', N'Vali du lịch chống xước, balo, túi xách thời trang cao cấp.', N'Microsoft.png')"""

# 2. Suppliers (NhaCungCap) replacement definitions
old_ncc_block = """INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'AP', N'Apple', N'apple.gif', N'Petter Pike', N'pike@yahoo.com', N'0987345876', N'765 Hello, Califonia, United States', N'Moble Device')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'MO', N'Motorola', N'motorola.gif', N'John David', N'john@gmail.com', N'0918456987', N'22 Rose, Messachuset, United States', N'Communication Company')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'NK', N'Nokia', N'Nokia.gif', N'Okawa', N'okawa@gmail.com', N'0913745789', N'123 Revenue, Tokyo, Japan', N'Famous company')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SM', N'Seamen', N'semen.gif', N'David Brown', N'brown@gmail.com', N'0987456876', N'23 New World, Texas, United Kindom', N'Digital device company')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SS', N'Samsung', N'samsung.gif', N LeeSongChai , N lee@yahoo.com , N 0913745789 , N 456 Romario, Seaul, Korea , N'The best company')"""
# Note: SS in old_ncc_block in file actually might have simple single quotes or N'LeeSongChai' depending on exactly what was viewed. Let's do a more robust substring or split search.

# Let's search using simpler regex or string find & replace for each Loai line:
if old_loai_block in sql_text:
    sql_text = sql_text.replace(old_loai_block, new_loai_block)
    print("Replaced Loai block successfully using direct match.")
else:
    # Try replacing line by line
    lines_to_replace = old_loai_block.split("\n")
    new_lines = new_loai_block.split("\n")
    replaced_count = 0
    for old_l, new_l in zip(lines_to_replace, new_lines):
        if old_l in sql_text:
            sql_text = sql_text.replace(old_l, new_l)
            replaced_count += 1
    print(f"Replaced {replaced_count} Loai lines.")

# Let's replace the NhaCungCap lines one by one to avoid quotes mismatch
ncc_replacements = [
    ("N'AP'", "N'Moble Device'", "N'Thiết bị di động, sản phẩm công nghệ cao cấp của Apple.'"),
    ("N'MO'", "N'Communication Company'", "N'Công ty viễn thông và thiết bị di động Motorola.'"),
    ("N'NK'", "N'Famous company'", "N'Thương hiệu thiết bị di động và viễn thông Nokia.'"),
    ("N'SM'", "N'Digital device company'", "N'Công ty thiết bị kỹ thuật số và công nghệ.'"),
    ("N'SS'", "N'The best company'", "N'Sản phẩm điện tử, công nghệ cao cấp của Samsung.'")
]

replaced_ncc = 0
for ncc_id, old_mota, new_mota in ncc_replacements:
    # We find the line containing ncc_id and old_mota
    lines = sql_text.split("\n")
    for idx, line in enumerate(lines):
        if ncc_id in line and old_mota in line:
            lines[idx] = line.replace(old_mota, new_mota)
            replaced_ncc += 1
            break
    sql_text = "\n".join(lines)

print(f"Replaced {replaced_ncc} NhaCungCap descriptions.")

# Write back in UTF-8
with open(sql_path, "w", encoding="utf-8") as f:
    f.write(sql_text)

print("Successfully saved updated HShopScript.sql!")
