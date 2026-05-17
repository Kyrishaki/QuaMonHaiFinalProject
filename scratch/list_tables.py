# -*- coding: utf-8 -*-
import re

file_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Let's find all unique tables inserted into
insert_tables = set(re.findall(r"INSERT\s+\[dbo\]\.\[([^\]]+)\]", content, re.IGNORECASE))
print("Tables in script:", insert_tables)
