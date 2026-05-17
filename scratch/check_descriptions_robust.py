# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql", 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
count = 0
for idx, line in enumerate(lines):
    if "INSERT [dbo].[HangHoa]" in line:
        count += 1
        # Let's extract values
        parts = line.split("VALUES (")
        if len(parts) > 1:
            vals_str = parts[1].rstrip(')').strip()
            # Simple split by ', ' but taking care of quotes
            # We can use python's csv module or a simple parser
            import csv
            import io
            reader = csv.reader(io.StringIO(vals_str), delimiter=',', quotechar="'", skipinitialspace=True)
            try:
                row = next(reader)
                mahh = row[0].strip()
                tenhh = row[1].replace("N'", "'").strip("'").strip()
                mota = row[10].replace("N'", "'").strip("'").strip()
                print(f"ID: {mahh} | Name: {tenhh} | Description starts with: {mota[:60]}...")
            except Exception as e:
                print(f"Error parsing line {idx+1}: {e}")
        if count >= 15:
            break
