import csv

csv_path = r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\local_products_utf8.csv"

with open(csv_path, "r", encoding="utf-8-sig") as f:
    reader = csv.reader(f)
    headers = next(reader)
    print("Headers:", headers)
    first_row = next(reader)
    print("First row:", first_row)
