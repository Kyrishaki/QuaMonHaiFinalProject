import os
import re

img_dir = r"h:\App\GitHub\QuaMonHaiFinalProject\wwwroot\img\Hinh\HangHoa"
img_files = os.listdir(img_dir)

# Find all files starting with digits or matching product IDs
print("Images matching digits/patterns:")
for f in img_files:
    match = re.match(r"^(\d+)", f)
    if match:
        print(f"File: {f}, matches number: {match.group(1)}")
