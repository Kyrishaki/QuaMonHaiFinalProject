import subprocess
import re

# We will run sqlcmd to get a CSV-like output
cmd = 'sqlcmd -S localhost -U sa -P 123456 -d Hshop2023 -Q "SELECT MaHH, TenHH, MaLoai, Hinh FROM HangHoa" -W -s ","'
res = subprocess.run(cmd, shell=True, capture_output=True, text=True)

lines = res.stdout.splitlines()
print(f"Total rows fetched: {len(lines)}")
# Write output to parsed_local_db.txt with UTF-8
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\parsed_local_db.txt", "w", encoding="utf-8") as f:
    for line in lines:
        f.write(line + "\n")

print("First 20 lines of output:")
for line in lines[:20]:
    print(line)
