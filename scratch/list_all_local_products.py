import subprocess

cmd = 'sqlcmd -S localhost -U sa -P 123456 -d Hshop2023 -Q "SELECT MaHH, TenHH, MaLoai, Hinh FROM HangHoa ORDER BY MaHH" -W -s "," -u'
res = subprocess.run(cmd, shell=True, capture_output=True)

try:
    stdout_text = res.stdout.decode('utf-16')
except Exception:
    stdout_text = res.stdout.decode('utf-8', errors='ignore')

lines = stdout_text.splitlines()

out_lines = []
for line in lines[2:]:
    if not line.strip() or line.startswith("(") or line.startswith("-"):
        continue
    out_lines.append(line)

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\ordered_local_products.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print("Successfully wrote ordered products to ordered_local_products.txt")
