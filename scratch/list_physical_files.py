import os

dir_path = r"h:\App\GitHub\QuaMonHaiFinalProject\wwwroot\img\Hinh\HangHoa"
files = sorted(os.listdir(dir_path))
print(f"Total files in HangHoa: {len(files)}")
print("First 30 files:")
for f in files[:30]:
    print(f)
print("\nLast 30 files:")
for f in files[-30:]:
    print(f)
