import subprocess

# Run sqlcmd with codepage 65001 (UTF-8)
cmd = 'sqlcmd -S localhost -U sa -P 123456 -d Hshop2023 -Q "SELECT TenHH FROM HangHoa WHERE MaHH = 1001" -f 65001'
res = subprocess.run(cmd, shell=True, capture_output=True)

print("Raw bytes of sqlcmd output with -f 65001:")
print(res.stdout)

try:
    decoded = res.stdout.decode("utf-8")
    print("\nDecoded successfully with UTF-8:")
    print(decoded)
except Exception as e:
    print(f"\nDecoding failed: {e}")
