# -*- coding: utf-8 -*-
import json
import re
import subprocess

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
    server_match = re.search(r"Server=([^;]+)", conn_str, re.IGNORECASE)
    db_match = re.search(r"Database=([^;]+)", conn_str, re.IGNORECASE)
    uid_match = re.search(r"User Id=([^;]+)", conn_str, re.IGNORECASE)
    pwd_match = re.search(r"Password=([^;]+)", conn_str, re.IGNORECASE)
    
    if server_match and db_match and uid_match and pwd_match:
        server = server_match.group(1)
        db = db_match.group(1)
        uid = uid_match.group(1)
        pwd = pwd_match.group(1)
        
        sql_file = r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\upsert_admin.sql"
        cmd = f'sqlcmd -S "{server}" -d "{db}" -U "{uid}" -P "{pwd}" -i "{sql_file}"'
        print("Running:", f'sqlcmd -S "{server}" -d "{db}" -U "{uid}" -P "***" -i "{sql_file}"')
        
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=15)
        if res.returncode == 0:
            print("Successfully executed upsert_admin.sql!")
            print(res.stdout)
        else:
            print("Failed to run sqlcmd:")
            print(res.stderr)
            print(res.stdout)
    else:
        print("Could not parse connection string.")
else:
    print("No connection string.")
