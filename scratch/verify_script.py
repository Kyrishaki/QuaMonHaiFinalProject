import re

sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(sql_path, "r", encoding="utf-16-le") as f:
    sql_text = f.read()

pattern = re.compile(r"INSERT\s+\[dbo\]\.\[HangHoa\].*?VALUES\s*\((.*?)\)(?=\s*(?:INSERT|GO|/\*\*|$))", re.DOTALL | re.IGNORECASE)
matches = pattern.findall(sql_text)

print(f"Total inserts found in modified script: {len(matches)}")
# Print first 5 to a utf-8 file to inspect
out_lines = []
for idx, match in enumerate(matches[:5]):
    out_lines.append(f"Row {idx+1}: {match.strip()}")

with open(r"h:\App\GitHub\QuaMonHaiFinalProject\scratch\verification_inserts.txt", "w", encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print("Successfully wrote first 5 inserts to verification_inserts.txt")
