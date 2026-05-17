# -*- coding: utf-8 -*-
import json

# Load descriptions and categories
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\parsed_products.json", 'r', encoding='utf-8') as f:
    products = json.load(f)

# Import description generator function
from update_all_descriptions import get_vietnamese_description

sql_statements = [
    "-- ========================================================",
    "-- BẢN CẬP NHẬT MÔ TẢ SẢN PHẨM TIẾNG VIỆT CHUẨN SEO",
    "-- Dự án: QuaMonHai - HShop2023",
    "-- Chạy file này trên Somee hoặc Local SSMS để sửa lỗi mô tả",
    "-- ========================================================",
    "USE [Hshop2023];",
    "GO",
    ""
]

for p in products:
    ma_hh = p["MaHH"]
    ten_hh = p["TenHH"]
    ma_loai = p["MaLoai"]
    
    desc = get_vietnamese_description(ten_hh, ma_loai)
    # Escape single quotes
    desc_escaped = desc.replace("'", "''")
    
    sql = f"UPDATE [dbo].[HangHoa] SET [MoTa] = N'{desc_escaped}' WHERE [MaHH] = {ma_hh};"
    sql_statements.append(sql)

sql_statements.append("")
sql_statements.append("PRINT N'Cập nhật thành công 81 mô tả sản phẩm tiếng Việt!';")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\UpdateDescriptions.sql", 'w', encoding='utf-8') as f_out:
    f_out.write("\n".join(sql_statements))

print("Created UpdateDescriptions.sql successfully!")
