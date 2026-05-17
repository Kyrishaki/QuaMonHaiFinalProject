sql_path = r"h:\App\GitHub\QuaMonHaiFinalProject\HShopScript.sql"

# Read in UTF-16 LE
with open(sql_path, "r", encoding="utf-16-le") as f:
    content = f.read()

# Original database creation code block to find
old_block = """IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Hshop2023')
BEGIN
  CREATE DATABASE Hshop2023;
END;
GO

USE [Hshop2023]
GO"""

# Let's also try to find variations in case of whitespace/newlines
# A safer replacement is to replace everything before "CREATE TABLE [dbo].[ChiTietHD]"
table_start = "CREATE TABLE [dbo].[ChiTietHD]"
start_idx = content.find(table_start)

if start_idx == -1:
    raise Exception("Could not find start of table creation in HShopScript.sql")

# Robust drop and create database header in SQL
new_header = """USE [master]
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Hshop2023')
BEGIN
    ALTER DATABASE Hshop2023 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Hshop2023;
END;
GO
CREATE DATABASE Hshop2023;
GO
USE [Hshop2023]
GO
"""

# Assemble new content
new_content = new_header + content[start_idx:]

with open(sql_path, "w", encoding="utf-16-le") as f:
    f.write(new_content)

print("Successfully updated HShopScript.sql header to perform a clean database drop and recreation!")
