# -*- coding: utf-8 -*-
import json
import re

# Read appsettings.json to get connection string
appsettings_path = r"h:\App\GitHub\QuaMonHaiFinalProject\appsettings.json"

try:
    with open(appsettings_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
    conn_str = config["ConnectionStrings"]["Hshop2023ConnectionString"]
    print("Found connection string:", conn_str)
except Exception as e:
    print("Could not read appsettings.json or connection string:", e)
    conn_str = None

if conn_str:
    # Try to execute the DELETE query using pyodbc or sqlcmd
    # Let's write a python script using pyodbc
    import subprocess
    
    # Let's try to run with pyodbc
    try:
        import pyodbc
        print("pyodbc is installed. Connecting to database...")
        
        # Parse connection string to standard pyodbc format
        # pyodbc requires Driver parameter, usually '{ODBC Driver 17 for SQL Server}' or '{SQL Server}'
        # Let's detect available ODBC drivers
        drivers = [x for x in pyodbc.drivers()]
        print("Available drivers:", drivers)
        
        driver = None
        for d in ["ODBC Driver 18 for SQL Server", "ODBC Driver 17 for SQL Server", "SQL Server"]:
            if d in drivers:
                driver = d
                break
        
        if driver:
            # Construct pyodbc connection string
            # Input format: Server=0.tcp.ap.ngrok.io,26018;Database=Hshop2023;User Id=sa;Password=QuaMonHai;TrustServerCertificate=True;
            # We add Driver={}
            p_conn_str = f"Driver={{{driver}}};" + conn_str
            
            # If Driver 18 is used, we might need Encrypt=no if TrustServerCertificate isn't enough, but TrustServerCertificate=True is already there.
            print(f"Connecting with: {p_conn_str}")
            conn = pyodbc.connect(p_conn_str, timeout=5)
            cursor = conn.cursor()
            
            # Execute delete
            cursor.execute("DELETE FROM KhachHang WHERE MatKhau = 'iloveyou'")
            rows_deleted = cursor.rowcount
            conn.commit()
            print(f"Successfully deleted {rows_deleted} accounts with password 'iloveyou' from the live database!")
            conn.close()
        else:
            print("No SQL Server ODBC drivers found.")
    except Exception as e:
        print("Failed to run DELETE via pyodbc:", e)
        print("Let's try running using sqlcmd...")
        
        # Parse connection string to get server, user, password, db
        # Server=0.tcp.ap.ngrok.io,26018;Database=Hshop2023;User Id=sa;Password=QuaMonHai;...
        server_match = re.search(r"Server=([^;]+)", conn_str, re.IGNORECASE)
        db_match = re.search(r"Database=([^;]+)", conn_str, re.IGNORECASE)
        uid_match = re.search(r"User Id=([^;]+)", conn_str, re.IGNORECASE)
        pwd_match = re.search(r"Password=([^;]+)", conn_str, re.IGNORECASE)
        
        if server_match and db_match and uid_match and pwd_match:
            server = server_match.group(1)
            db = db_match.group(1)
            uid = uid_match.group(1)
            pwd = pwd_match.group(1)
            
            sql_query = "DELETE FROM KhachHang WHERE MatKhau = 'iloveyou';"
            # Let's run sqlcmd
            cmd = f'sqlcmd -S "{server}" -d "{db}" -U "{uid}" -P "{pwd}" -Q "{sql_query}"'
            print("Running command:", f'sqlcmd -S "{server}" -d "{db}" -U "{uid}" -P "***" -Q "{sql_query}"')
            try:
                res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=10)
                if res.returncode == 0:
                    print("sqlcmd executed successfully!")
                    print(res.stdout)
                else:
                    print("sqlcmd failed:")
                    print(res.stderr)
                    print(res.stdout)
            except Exception as ex:
                print("Failed to run sqlcmd:", ex)
        else:
            print("Could not parse connection string for sqlcmd parameters.")
else:
    print("No connection string available to run.")
