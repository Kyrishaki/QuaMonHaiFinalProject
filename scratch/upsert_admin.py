# -*- coding: utf-8 -*-
import json
import re
import hashlib

appsettings_path = r"h:\App\GitHub\QuaMonHaiFinalProject\appsettings.json"

try:
    with open(appsettings_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
    conn_str = config["ConnectionStrings"]["Hshop2023ConnectionString"]
    print("Found connection string:", conn_str)
except Exception as e:
    print("Could not read appsettings.json:", e)
    conn_str = None

if conn_str:
    # Compute password hash
    password = "admin123"
    random_key = "abcde"
    # ToMd5Hash(password, random_key) = md5(password + random_key)
    hasher = hashlib.md5()
    hasher.update((password + random_key).encode('utf-8'))
    hashed_password = hasher.hexdigest()
    print("Hashed password:", hashed_password)
    
    # We will delete the existing admin user if any, and insert a clean one
    sql_check = "SELECT COUNT(*) FROM KhachHang WHERE MaKh = 'admin'"
    sql_delete = "DELETE FROM KhachHang WHERE MaKh = 'admin'"
    sql_insert = f"""
    INSERT INTO KhachHang (MaKh, MatKhau, HoTen, GioiTinh, NgaySinh, DiaChi, DienThoai, Email, Hinh, HieuLuc, VaiTro, RandomKey)
    VALUES (
        'admin', 
        '{hashed_password}', 
        N'Quản trị viên', 
        1, 
        '2000-01-01', 
        N'Biên Hòa, Đồng Nai', 
        '0936363636', 
        'admin@quamonhai.com', 
        'default-avatar.jpg', 
        1, 
        1, 
        '{random_key}'
    )
    """

    import subprocess
    try:
        import pyodbc
        print("pyodbc available.")
        drivers = [x for x in pyodbc.drivers()]
        driver = None
        for d in ["ODBC Driver 18 for SQL Server", "ODBC Driver 17 for SQL Server", "SQL Server"]:
            if d in drivers:
                driver = d
                break
        
        if driver:
            p_conn_str = f"Driver={{{driver}}};" + conn_str
            print("Connecting with pyodbc...")
            conn = pyodbc.connect(p_conn_str, timeout=5)
            cursor = conn.cursor()
            
            cursor.execute(sql_delete)
            cursor.execute(sql_insert)
            conn.commit()
            print("Successfully inserted/updated the admin account with password 'admin123'!")
            conn.close()
        else:
            print("No SQL Server ODBC drivers found.")
    except Exception as e:
        print("pyodbc failed, trying sqlcmd:", e)
        # Parse connection string
        server_match = re.search(r"Server=([^;]+)", conn_str, re.IGNORECASE)
        db_match = re.search(r"Database=([^;]+)", conn_str, re.IGNORECASE)
        uid_match = re.search(r"User Id=([^;]+)", conn_str, re.IGNORECASE)
        pwd_match = re.search(r"Password=([^;]+)", conn_str, re.IGNORECASE)
        
        if server_match and db_match and uid_match and pwd_match:
            server = server_match.group(1)
            db = db_match.group(1)
            uid = uid_match.group(1)
            pwd = pwd_match.group(1)
            
            # Combine queries
            queries = f"DELETE FROM KhachHang WHERE MaKh = 'admin'; {sql_insert}"
            cmd = f'sqlcmd -S "{server}" -d "{db}" -U "{uid}" -P "{pwd}" -Q "{queries}"'
            res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=10)
            if res.returncode == 0:
                print("sqlcmd executed successfully!")
                print(res.stdout)
            else:
                print("sqlcmd failed:")
                print(res.stderr)
                print(res.stdout)
else:
    print("Connection string not found.")
