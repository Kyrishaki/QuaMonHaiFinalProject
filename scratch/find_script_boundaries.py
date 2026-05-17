sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-16-le") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "HangHoa" in line:
        # print 5 lines before and after if it contains IDENTITY_INSERT or similar setup
        if "IDENTITY_INSERT" in line or "ON" in line or "OFF" in line:
            print(f"Line {i+1}: {line.strip()}")
