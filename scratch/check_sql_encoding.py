sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

for enc in ["utf-16", "utf-16-le", "utf-8", "cp1252"]:
    try:
        with open(sql_path, "r", encoding=enc) as f:
            content = f.read()
        print(f"Successfully read HShopScript.sql using {enc}, content size: {len(content)}")
    except Exception as e:
        print(f"Failed to read using {enc}: {e}")
