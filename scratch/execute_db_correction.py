import re
import os

sql_path = "HShopScript.sql"

# Read original SQL file
with open(sql_path, "r", encoding="utf-8") as f:
    sql_content = f.read()

# Define the new suppliers to be inserted
new_suppliers = """INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'DE', N'Dell Inc.', N'dell-logo.jpg', N'Michael Dell', N'contact@dell.com', N'0987111222', N'One Dell Way, Round Rock, Texas, US', N'Dell Premium Laptops and Computers')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'HP', N'HP Inc.', N'hp-logo.jpg', N'Enrique Lores', N'contact@hp.com', N'0987333444', N'Palo Alto, California, US', N'HP Invent Laptops and Digital Devices')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'AC', N'Acer Inc.', N'Acer_logo-300x300.gif', N'Jason Chen', N'contact@acer.com', N'0987555666', N'New Taipei City, Taiwan', N'Acer Explore Beyond Limits Laptops')
INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SE', N'Sony Ericsson', N'sonny-ericsson.jpg', N'Sony CEO', N'contact@sony.com', N'0987777888', N'Tokyo, Japan', N'Sony Mobile and Electronics Devices')
"""

# Insert the new suppliers right after the existing ones
if "INSERT [dbo].[NhaCungCap]" in sql_content:
    # Find all current supplier inserts
    lines = sql_content.splitlines()
    last_supplier_idx = -1
    for idx, line in enumerate(lines):
        if "INSERT [dbo].[NhaCungCap]" in line or "INSERT INTO [dbo].[NhaCungCap]" in line:
            last_supplier_idx = idx
    
    if last_supplier_idx != -1:
        print(f"Found last NhaCungCap insert at line {last_supplier_idx}")
        # Insert our new suppliers right after
        lines.insert(last_supplier_idx + 1, new_suppliers.strip())
        sql_content = "\n".join(lines)
        print("Successfully added new suppliers to the SQL script content.")
else:
    print("WARNING: Could not find INSERT [dbo].[NhaCungCap] in script.")

# Mappings for the 81 products: MaHH -> (TenHH, TenAlias, MaLoai, MaNCC)
product_mappings = {
    # Category 1000: Đồng hồ
    "1001": ("Đồng hồ Swatch Gold Chronograph", "swatch-gold-chronograph", "1000", "SM"),
    "1002": ("Đồng hồ Tissot T-Touch Silver", "tissot-t-touch-silver", "1000", "SM"),
    "1024": ("Đồng hồ Citizen Eco-Drive Promaster", "citizen-eco-drive-promaster", "1000", "SM"),
    "1034": ("Đồng hồ Michael Kors Rose Gold", "michael-kors-rose-gold", "1000", "SM"),
    "1043": ("Đồng hồ Citizen Eco-Drive Chandler", "citizen-eco-drive-chandler", "1000", "SM"),
    "1070": ("Đồng hồ Casio Pro Trek Tough Solar", "casio-pro-trek-tough-solar", "1000", "MO"),
    "1075": ("Đồng hồ Casio G-Shock Black", "casio-g-shock-black", "1000", "MO"),
    "1081": ("Đồng hồ Casio G-Shock Analog-Digital", "casio-g-shock-analog-digital", "1000", "MO"),
    "1084": ("Đồng hồ Casio Pro Trek Pathfinder", "casio-pro-trek-pathfinder", "1000", "MO"),
    
    # Category 1001: Laptop
    "1003": ("Laptop HP Premium Minimalist", "hp-premium-minimalist-laptop", "1001", "HP"),
    "1004": ("Laptop ASUS Core i5 Standard", "asus-core-i5-standard", "1001", "AC"),
    "1005": ("Laptop Dell Inspiron Kayak Edition", "dell-inspiron-kayak-edition", "1001", "DE"),
    "1006": ("Laptop ASUS Vivobook Slim", "asus-vivobook-slim", "1001", "AC"),
    "1008": ("Laptop HP Pavilion Silver Slim", "hp-pavilion-silver-slim", "1001", "HP"),
    "1015": ("Laptop Toshiba Dynabook Professional", "toshiba-dynabook-professional", "1001", "SE"),
    "1061": ("Laptop MSI Prestige Business", "msi-prestige-business-laptop", "1001", "SE"),
    "1063": ("Laptop HP Essential Grey Slim", "hp-essential-grey-slim", "1001", "HP"),
    "1077": ("Laptop HP Compaq Vintage Edition", "hp-compaq-vintage-edition", "1001", "HP"),
    "1085": ("Laptop ASUS Zenbook Premium Ultra", "asus-zenbook-premium-ultra", "1001", "AC"),
    
    # Category 1002: Máy ảnh
    "1016": ("Máy ảnh Nikon D7000 DSLR Professional", "nikon-d7000-dslr-professional", "1002", "SM"),
    "1019": ("Máy ảnh Canon PowerShot SD1300 Blue", "canon-powershot-sd1300-blue", "1002", "SM"),
    "1020": ("Máy ảnh Nikon COOLPIX Silver Pocket", "nikon-coolpix-silver-pocket", "1002", "SM"),
    "1021": ("Máy ảnh Nikon COOLPIX Lime Green", "nikon-coolpix-lime-green", "1002", "SM"),
    "1025": ("Máy ảnh Nikon COOLPIX Royal Blue", "nikon-coolpix-royal-blue", "1002", "SM"),
    "1047": ("Máy ảnh Panasonic LUMIX Red Compact", "panasonic-lumix-red-compact", "1002", "SM"),
    "1048": ("Máy ảnh Fujifilm FinePix J40 Black", "fujifilm-finepix-j40-black", "1002", "SM"),
    "1049": ("Máy ảnh Canon PowerShot SX130 IS", "canon-powershot-sx130-is", "1002", "SM"),
    "1050": ("Máy ảnh Nikon D3100 DSLR Starter", "nikon-d3100-dslr-starter", "1002", "SM"),
    "1062": ("Máy ảnh Nikon COOLPIX Autumn Red", "nikon-coolpix-autumn-red", "1002", "SM"),
    "1068": ("Máy ảnh Canon PowerShot SD1300 Silver", "canon-powershot-sd1300-silver", "1002", "SM"),
    "1026": ("Máy ảnh Fujifilm FinePix Bridge Camera", "fujifilm-finepix-bridge-camera", "1002", "SM"), # Mismatched from 1005
    "1027": ("Máy ảnh Canon PowerShot S95 Premium", "canon-powershot-s95-premium", "1002", "SM"), # Mismatched from 1005
    
    # Category 1003: Điện thoại
    "1011": ("Điện thoại BlackBerry Bold Classic", "blackberry-bold-classic", "1003", "MO"),
    "1012": ("Điện thoại LG Cookie KP500 Stylus", "lg-cookie-kp500-stylus", "1003", "SE"),
    "1031": ("Điện thoại BlackBerry Curve AT&T", "blackberry-curve-att", "1003", "MO"),
    "1032": ("Điện thoại Nokia E71 QWERTY Silver", "nokia-e71-qwerty-silver", "1003", "NK"),
    "1033": ("Điện thoại Nokia E71 QWERTY Metallic Grey", "nokia-e71-qwerty-metallic-grey", "1003", "NK"),
    "1059": ("Điện thoại Nokia 5310 XpressMusic", "nokia-5310-xpressmusic", "1003", "NK"),
    "1071": ("Điện thoại Nokia N8 Touch Smartphone", "nokia-n8-touch-smartphone", "1003", "NK"),
    "1072": ("Điện thoại Nokia Nseries Luxury Flip", "nokia-nseries-luxury-flip", "1003", "NK"),
    "1060": ("Điện thoại Nokia C7 Touch Sleek", "nokia-c7-touch-sleek", "1003", "NK"), # Mismatched from 1002
    "1069": ("Điện thoại BlackBerry Torch Slider", "blackberry-torch-slider", "1003", "MO"), # Mismatched from 1004
    
    # Category 1004: Nước hoa
    "1022": ("Nước hoa Guess for Women EDP Pink", "guess-for-women-edp-pink", "1004", "SM"),
    "1023": ("Nước hoa Dolce & Gabbana Light Blue", "dolce-gabbana-light-blue", "1004", "SM"),
    "1056": ("Nước hoa Calvin Klein Eternity for Men", "calvin-klein-eternity-for-men", "1004", "SM"),
    "1057": ("Nước hoa Nautica Blue Eau de Toilette", "nautica-blue-eau-de-toilette", "1004", "SM"),
    "1064": ("Nước hoa Britney Spears Fantasy Pink", "britney-spears-fantasy-pink", "1004", "SM"),
    "1042": ("Nước hoa Paris Hilton Eau de Parfum", "paris-hilton-eau-de-parfum", "1004", "SM"), # Mismatched from 1003
    "1052": ("Nước hoa Paris Hilton Heiress Perfume", "paris-hilton-heiress-perfume", "1004", "SM"), # Mismatched from 1003
    
    # Category 1005: Trang sức
    "1009": ("Nhẫn vàng đính đá Opal & Diamonds", "nhan-vang-dinh-da-opal-diamonds", "1005", "SM"),
    "1017": ("Nhẫn bạc Celtic Knot Ring", "nhan-bac-celtic-knot-ring", "1005", "SM"),
    "1029": ("Nhẫn bạc đính đá White Opal Stone", "nhan-bac-dinh-da-white-opal-stone", "1005", "SM"),
    "1053": ("Nhẫn bạc đính đá Solitaire Diamond", "nhan-bac-dinh-da-solitaire-diamond", "1005", "SM"),
    "1054": ("Nhẫn bạc đính đá Moonstone Gem", "nhan-bac-dinh-da-moonstone-gem", "1005", "SM"),
    "1055": ("Nhẫn bạc đính đá Orange Amber", "nhan-bac-dinh-da-orange-amber", "1005", "SM"),
    "1083": ("Nhẫn Claddagh Blue Heart Gem", "nhan-claddagh-blue-heart-gem", "1005", "SM"),
    
    # Category 1006: Giày
    "1007": ("Giày bốt tuyết Black Winter Snow", "giay-bot-tuyet-black-winter-snow", "1006", "SM"),
    "1014": ("Giày bốt Sorel Beige Winter Boots", "giay-bot-sorel-beige-winter-boots", "1006", "SM"),
    "1028": ("Giày bốt Sorel Waterproof Active", "giay-bot-sorel-waterproof-active", "1006", "SM"),
    "1051": ("Giày bốt UGG Classic Pink Button", "giay-bot-ugg-classic-pink-button", "1006", "SM"),
    "1074": ("Giày bốt Black Fur Trimmed Winter", "giay-bot-black-fur-trimmed-winter", "1006", "SM"),
    
    # Category 1007: Vali
    "1010": ("Vali balo Osprey Green Rolling", "vali-balo-osprey-green-rolling", "1007", "SM"),
    "1013": ("Vali Samsonite Classic Black Rolling", "vali-samsonite-classic-black-rolling", "1007", "SM"),
    "1018": ("Vali Samsonite Classic Blue Rolling", "vali-samsonite-classic-blue-rolling", "1007", "SM"),
    "1030": ("Vali balo High Sierra Grey Rolling", "vali-balo-high-sierra-grey-rolling", "1007", "SM"),
    "1036": ("Vali balo High Sierra Black Duffel", "vali-balo-high-sierra-black-duffel", "1007", "SM"),
    "1037": ("Vali Samsonite Burgundy Rolling", "vali-samsonite-burgundy-rolling", "1007", "SM"),
    "1041": ("Vali Samsonite Purple Rolling", "vali-samsonite-purple-rolling", "1007", "SM"),
    "1045": ("Vali Samsonite Red Premium Rolling", "vali-samsonite-red-premium-rolling", "1007", "SM"),
    "1046": ("Vali London Fog Pegasus Brown Leather", "vali-london-fog-pegasus-brown-leather", "1007", "SM"),
    "1058": ("Vali London Fog Pegasus Brown Leather II", "vali-london-fog-pegasus-brown-leather-ii", "1007", "SM"),
    "1073": ("Vali Samsonite Light Blue Hard-Shell", "vali-samsonite-light-blue-hard-shell", "1007", "SM"),
    "1040": ("Vali Samsonite Essential Black Rolling", "vali-samsonite-essential-black-rolling", "1007", "SM"), # Mismatched from 1002
    
    # Extra misclassified items:
    "1035": ("Đồng hồ TAG Heuer Aquaracer Special", "dong-ho-tag-heuer-aquaracer-special", "1000", "SM"), # Mismatched from 1003
    "1038": ("Đồng hồ Luminox Navy SEAL Sports", "dong-ho-luminox-navy-seal-sports", "1000", "SM"), # Mismatched from 1004
    "1039": ("Đồng hồ TAG Heuer Carrera Chronograph", "dong-ho-tag-heuer-carrera-chronograph", "1000", "SM"), # Mismatched from 1002
    "1044": ("Laptop Dell Latitude Business Slim", "dell-latitude-business-slim", "1001", "DE"), # Mismatched from 1004
    "1065": ("Laptop MSI Dodgers Edition Gaming", "msi-dodgers-edition-gaming", "1001", "SE"), # Mismatched from 1003
    "1066": ("Laptop ASUS ROG Premium Gaming", "asus-rog-premium-gaming", "1001", "AC"), # Mismatched from 1003
    "1067": ("Đồng hồ TAG Heuer Carrera Silver Steel", "dong-ho-tag-heuer-carrera-silver-steel", "1000", "SM"), # Mismatched from 1002
    "1076": ("Đồng hồ Square Steel Chronograph Retro", "dong-ho-square-steel-chronograph-retro", "1000", "SM"), # Mismatched from 1004
}

# The remaining products that are not misclassified but need beautiful name styling
# Let's populate the remaining IDs
all_sql_lines = sql_content.splitlines()
modified_count = 0

for idx, line in enumerate(all_sql_lines):
    if "INSERT [dbo].[HangHoa]" in line or "INSERT INTO [dbo].[HangHoa]" in line:
        # Extract the values string
        val_match = re.search(r"VALUES\s*\((.*)\)\s*$", line.strip(), re.IGNORECASE)
        if not val_match:
            val_match = re.search(r"VALUES\s*\((.*)\)", line, re.IGNORECASE)
        
        if val_match:
            vals_str = val_match.group(1).strip()
            # Tokenize properly
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
                hinh = tokens[6].strip("N'").strip("'")
                
                # Check if this product has a visual mapping
                if ma_hh in product_mappings:
                    new_name, new_alias, new_loai, new_ncc = product_mappings[ma_hh]
                    
                    # Update tokens
                    tokens[1] = f"N'{new_name}'"
                    tokens[2] = f"N'{new_alias}'"
                    tokens[3] = new_loai
                    tokens[11] = f"N'{new_ncc}'"
                    
                    # Reconstruct the line
                    new_vals_str = ", ".join(tokens)
                    new_line = line.replace(val_match.group(1), new_vals_str)
                    all_sql_lines[idx] = new_line
                    modified_count += 1
                else:
                    # Fallback for any product that we might have missed or has another ID
                    # We will format it beautifully based on its current category!
                    orig_name = tokens[1].strip("N'").strip("'")
                    orig_alias = tokens[2].strip("N'").strip("'")
                    orig_loai = tokens[3]
                    orig_ncc = tokens[11].strip("N'").strip("'").strip(")")
                    
                    # Generate a beautiful name if it still has generic names
                    if "Đồng hồ cao cấp" in orig_name or "mẫu" in orig_name or "siêu mỏng" in orig_name or "chuyên nghiệp" in orig_name or "thông minh" in orig_name or "quyến rũ" in orig_name or "đá quý" in orig_name or "bốt thời trang" in orig_name or "chống xước" in orig_name:
                        # Pick a generic but beautiful real-world name based on category
                        cat_names = {
                            "1000": ("Đồng hồ Casio Classic Quartz", "casio-classic-quartz", "MO"),
                            "1001": ("Laptop HP Pavilion Notebook", "hp-pavilion-notebook", "HP"),
                            "1002": ("Máy ảnh Canon PowerShot Digital", "canon-powershot-digital", "SM"),
                            "1003": ("Điện thoại Nokia C2 Classic", "nokia-c2-classic", "NK"),
                            "1004": ("Nước hoa Chanel Bleu de Parfum", "chanel-bleu-de-parfum", "SM"),
                            "1005": ("Nhẫn bạc Premium Crystal Ring", "nhan-bac-premium-crystal-ring", "SM"),
                            "1006": ("Giày bốt Sorel Waterproof Active", "giay-bot-sorel-waterproof-active", "SM"),
                            "1007": ("Vali Samsonite Premium Suitcase", "vali-samsonite-premium-suitcase", "SM"),
                        }
                        if orig_loai in cat_names:
                            new_name, new_alias, new_ncc = cat_names[orig_loai]
                            tokens[1] = f"N'{new_name}'"
                            tokens[2] = f"N'{new_alias}'"
                            tokens[11] = f"N'{new_ncc}'"
                            
                            new_vals_str = ", ".join(tokens)
                            new_line = line.replace(val_match.group(1), new_vals_str)
                            all_sql_lines[idx] = new_line
                            modified_count += 1
                            print(f"Fallback formatting for MaHH={ma_hh} ({orig_name}) -> {new_name}")

print(f"Total HangHoa lines modified/verified: {modified_count}")

# Write back the corrected SQL content using utf-8-sig to write with a UTF-8 BOM
with open(sql_path, "w", encoding="utf-8-sig") as f:
    f.write("\n".join(all_sql_lines))

print("Successfully wrote corrected database seed script to HShopScript.sql!")
