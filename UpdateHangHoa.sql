USE [Hshop2023]
GO

-- 1. THÊM CỘT SOLUONG VÀO BẢNG HANGHOA NẾU CHƯA CÓ
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

-- 3. CẬP NHẬT THÔNG TIN HÀNG HÓA VÀ SỐ LƯỢNG CHUẨN THEO ẢNH
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Swatch Gold Chronograph', [TenAlias] = N'swatch-gold-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1001;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Tissot T-Touch Silver', [TenAlias] = N'tissot-t-touch-silver', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1002;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Premium Minimalist', [TenAlias] = N'hp-premium-minimalist-laptop', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 25 WHERE [MaHH] = 1003;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Core i5 Standard', [TenAlias] = N'asus-core-i5-standard', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 95 WHERE [MaHH] = 1004;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Inspiron Kayak Edition', [TenAlias] = N'dell-inspiron-kayak-edition', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1005;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Vivobook Slim', [TenAlias] = N'asus-vivobook-slim', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 105 WHERE [MaHH] = 1006;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt tuyết Black Winter Snow', [TenAlias] = N'giay-bot-tuyet-black-winter-snow', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1007;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Pavilion Silver Slim', [TenAlias] = N'hp-pavilion-silver-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 115 WHERE [MaHH] = 1008;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn vàng đính đá Opal & Diamonds', [TenAlias] = N'nhan-vang-dinh-da-opal-diamonds', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1009;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo Osprey Green Rolling', [TenAlias] = N'vali-balo-osprey-green-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1010;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Bold Classic', [TenAlias] = N'blackberry-bold-classic', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 65 WHERE [MaHH] = 1011;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại LG Cookie KP500 Stylus', [TenAlias] = N'lg-cookie-kp500-stylus', [MaLoai] = 1003, [MaNCC] = N'SE', [SoLuong] = 135 WHERE [MaHH] = 1012;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Black Rolling', [TenAlias] = N'vali-samsonite-classic-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1013;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Beige Winter Boots', [TenAlias] = N'giay-bot-sorel-beige-winter-boots', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1014;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Toshiba Dynabook Professional', [TenAlias] = N'toshiba-dynabook-professional', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 85 WHERE [MaHH] = 1015;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D7000 DSLR Professional', [TenAlias] = N'nikon-d7000-dslr-professional', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1016;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc Celtic Knot Ring', [TenAlias] = N'nhan-bac-celtic-knot-ring', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1017;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Blue Rolling', [TenAlias] = N'vali-samsonite-classic-blue-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1018;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Blue', [TenAlias] = N'canon-powershot-sd1300-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1019;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Silver Pocket', [TenAlias] = N'nikon-coolpix-silver-pocket', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1020;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Lime Green', [TenAlias] = N'nikon-coolpix-lime-green', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1021;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Guess for Women EDP Pink', [TenAlias] = N'guess-for-women-edp-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1022;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Dolce & Gabbana Light Blue', [TenAlias] = N'dolce-gabbana-light-blue', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1023;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Promaster', [TenAlias] = N'citizen-eco-drive-promaster', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1024;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Royal Blue', [TenAlias] = N'nikon-coolpix-royal-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1025;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix Bridge Camera', [TenAlias] = N'fujifilm-finepix-bridge-camera', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1026;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot S95 Premium', [TenAlias] = N'canon-powershot-s95-premium', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1027;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Waterproof Active', [TenAlias] = N'giay-bot-sorel-waterproof-active', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1028;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá White Opal Stone', [TenAlias] = N'nhan-bac-dinh-da-white-opal-stone', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1029;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Grey Rolling', [TenAlias] = N'vali-balo-high-sierra-grey-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1030;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Curve AT&T', [TenAlias] = N'blackberry-curve-att', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1031;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Silver', [TenAlias] = N'nokia-e71-qwerty-silver', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1032;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Metallic Grey', [TenAlias] = N'nokia-e71-qwerty-metallic-grey', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1033;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Michael Kors Rose Gold', [TenAlias] = N'michael-kors-rose-gold', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1034;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Aquaracer Special', [TenAlias] = N'dong-ho-tag-heuer-aquaracer-special', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1035;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Black Duffel', [TenAlias] = N'vali-balo-high-sierra-black-duffel', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1036;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Burgundy Rolling', [TenAlias] = N'vali-samsonite-burgundy-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1037;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Luminox Navy SEAL Sports', [TenAlias] = N'dong-ho-luminox-navy-seal-sports', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1038;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Chronograph', [TenAlias] = N'dong-ho-tag-heuer-carrera-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1039;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Essential Black Rolling', [TenAlias] = N'vali-samsonite-essential-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1040;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Purple Rolling', [TenAlias] = N'vali-samsonite-purple-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1041;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Eau de Parfum', [TenAlias] = N'paris-hilton-eau-de-parfum', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1042;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Chandler', [TenAlias] = N'citizen-eco-drive-chandler', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1043;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Latitude Business Slim', [TenAlias] = N'dell-latitude-business-slim', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1044;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Red Premium Rolling', [TenAlias] = N'vali-samsonite-red-premium-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1045;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather', [TenAlias] = N'vali-london-fog-pegasus-brown-leather', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1046;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Panasonic LUMIX Red Compact', [TenAlias] = N'panasonic-lumix-red-compact', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1047;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix J40 Black', [TenAlias] = N'fujifilm-finepix-j40-black', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1048;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SX130 IS', [TenAlias] = N'canon-powershot-sx130-is', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1049;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D3100 DSLR Starter', [TenAlias] = N'nikon-d3100-dslr-starter', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1050;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt UGG Classic Pink Button', [TenAlias] = N'giay-bot-ugg-classic-pink-button', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1051;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Heiress Perfume', [TenAlias] = N'paris-hilton-heiress-perfume', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1052;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Solitaire Diamond', [TenAlias] = N'nhan-bac-dinh-da-solitaire-diamond', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1053;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Moonstone Gem', [TenAlias] = N'nhan-bac-dinh-da-moonstone-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1054;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Orange Amber', [TenAlias] = N'nhan-bac-dinh-da-orange-amber', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1055;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Calvin Klein Eternity for Men', [TenAlias] = N'calvin-klein-eternity-for-men', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1056;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Nautica Blue Eau de Toilette', [TenAlias] = N'nautica-blue-eau-de-toilette', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1057;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather II', [TenAlias] = N'vali-london-fog-pegasus-brown-leather-ii', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1058;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia 5310 XpressMusic', [TenAlias] = N'nokia-5310-xpressmusic', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1059;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia C7 Touch Sleek', [TenAlias] = N'nokia-c7-touch-sleek', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 115 WHERE [MaHH] = 1060;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Prestige Business', [TenAlias] = N'msi-prestige-business-laptop', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 55 WHERE [MaHH] = 1061;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Autumn Red', [TenAlias] = N'nikon-coolpix-autumn-red', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1062;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Essential Grey Slim', [TenAlias] = N'hp-essential-grey-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 65 WHERE [MaHH] = 1063;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Britney Spears Fantasy Pink', [TenAlias] = N'britney-spears-fantasy-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1064;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Dodgers Edition Gaming', [TenAlias] = N'msi-dodgers-edition-gaming', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 75 WHERE [MaHH] = 1065;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS ROG Premium Gaming', [TenAlias] = N'asus-rog-premium-gaming', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 15 WHERE [MaHH] = 1066;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Silver Steel', [TenAlias] = N'dong-ho-tag-heuer-carrera-silver-steel', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1067;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Silver', [TenAlias] = N'canon-powershot-sd1300-silver', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1068;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Torch Slider', [TenAlias] = N'blackberry-torch-slider', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 95 WHERE [MaHH] = 1069;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Tough Solar', [TenAlias] = N'casio-pro-trek-tough-solar', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1070;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia N8 Touch Smartphone', [TenAlias] = N'nokia-n8-touch-smartphone', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1071;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia Nseries Luxury Flip', [TenAlias] = N'nokia-nseries-luxury-flip', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1072;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Light Blue Hard-Shell', [TenAlias] = N'vali-samsonite-light-blue-hard-shell', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1073;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Black Fur Trimmed Winter', [TenAlias] = N'giay-bot-black-fur-trimmed-winter', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1074;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Black', [TenAlias] = N'casio-g-shock-black', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 125 WHERE [MaHH] = 1075;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Square Steel Chronograph Retro', [TenAlias] = N'dong-ho-square-steel-chronograph-retro', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1076;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Compaq Vintage Edition', [TenAlias] = N'hp-compaq-vintage-edition', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 135 WHERE [MaHH] = 1077;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Analog-Digital', [TenAlias] = N'casio-g-shock-analog-digital', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 25 WHERE [MaHH] = 1081;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn Claddagh Blue Heart Gem', [TenAlias] = N'nhan-claddagh-blue-heart-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1083;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Pathfinder', [TenAlias] = N'casio-pro-trek-pathfinder', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 105 WHERE [MaHH] = 1084;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Zenbook Premium Ultra', [TenAlias] = N'asus-zenbook-premium-ultra', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 45 WHERE [MaHH] = 1085;

GO
