import pyodbc

conn_str = (
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=0.tcp.ap.ngrok.io,26018;"
    "DATABASE=Hshop2023;"
    "UID=sa;"
    "PWD=QuaMonHai;"
    "TrustServerCertificate=yes;"
)

patterns = ['á»', 'Ã²', 'Ã¡', 'Ãª', 'Ã¹', 'Ãº', 'Ã¬', 'Ã­', 'Ã¢', 'Ã´', 'Ä‘', 'Ä', 'áº', 'á»…']

try:
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    
    # Get all text columns of all user tables
    cursor.execute("""
        SELECT 
            t.name AS TableName, 
            c.name AS ColumnName
        FROM sys.tables t
        INNER JOIN sys.columns c ON t.object_id = c.object_id
        INNER JOIN sys.types y ON c.user_type_id = y.user_type_id
        WHERE y.name IN ('varchar', 'nvarchar', 'char', 'nchar')
    """)
    
    columns = cursor.fetchall()
    print(f"Scanning {len(columns)} text columns for potential corrupted encoding...")
    
    found_any = False
    for row in columns:
        table_name = row.TableName
        column_name = row.ColumnName
        
        # Build check query
        where_clauses = [f"[{column_name}] LIKE ?" for _ in patterns]
        where_str = " OR ".join(where_clauses)
        params = [f"%{p}%" for p in patterns]
        
        query = f"SELECT COUNT(*) FROM [{table_name}] WHERE {where_str}"
        try:
            cursor.execute(query, params)
            count = cursor.fetchone()[0]
            if count > 0:
                found_any = True
                print(f"\n[FOUND] Table: {table_name} | Column: {column_name} | Corrupted Rows: {count}")
                
                # Fetch examples
                cursor.execute(f"SELECT TOP 3 [{column_name}] FROM [{table_name}] WHERE {where_str}", params)
                examples = cursor.fetchall()
                for idx, ex in enumerate(examples):
                    print(f"    Example {idx+1}: {ex[0]}")
        except Exception as e:
            # Skip tables/columns that fail (e.g. system/special columns)
            pass
            
    if not found_any:
        print("\nAll scanned columns are 100% clean and correct! No corrupted strings found.")
        
    conn.close()

except Exception as e:
    print(f"Connection failed: {e}")
