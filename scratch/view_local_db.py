import os

txt_path = r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\local_db_products.txt"

# Read file, trying multiple encodings since sqlcmd output on Windows can be ANSI or UTF-16
content = None
for enc in ["utf-16", "utf-8", "cp1252", "mbcs"]:
    try:
        with open(txt_path, "r", encoding=enc) as f:
            content = f.read()
        print(f"Successfully read using encoding: {enc}")
        break
    except Exception as e:
        continue

if content:
    lines = content.splitlines()
    print(f"Total lines in file: {len(lines)}")
    print("First 25 lines:")
    for line in lines[:25]:
        print(line)
else:
    print("Failed to read the file with any encoding.")
