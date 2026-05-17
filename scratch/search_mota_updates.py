# -*- coding: utf-8 -*-
with open(r"h:\App\GitHub\QuaMonHaiFinalProject\UpdateHangHoa.sql", 'r', encoding='utf-8') as f:
    content = f.read()

import re
mota_updates = [line for line in content.split('\n') if "MoTa" in line]
print(f"Found {len(mota_updates)} lines containing MoTa in UpdateHangHoa.sql")
for line in mota_updates[:10]:
    print(line[:120])
