$connString = "Server=0.tcp.ap.ngrok.io,26018;Database=Hshop2023;User Id=sa;Password=QuaMonHai;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connString)
$conn.Open()

$patterns = @('%á»%', '%Ã²', '%Ã¡%', '%Ãª%', '%Ã¹%', '%Ãº%', '%Ã¬%', '%Ã­%', '%Ã¢%', '%Ã´%', '%Ä‘%', '%Ä%', '%áº%', '%á»…%')

$cmd = $conn.CreateCommand()
$cmd.CommandText = @"
SELECT 
    t.name AS TableName, 
    c.name AS ColumnName
FROM sys.tables t
INNER JOIN sys.columns c ON t.object_id = c.object_id
INNER JOIN sys.types y ON c.user_type_id = y.user_type_id
WHERE y.name IN ('varchar', 'nvarchar', 'char', 'nchar')
"@

$columns = @()
$reader = $cmd.ExecuteReader()
while ($reader.Read()) {
    $columns += [PSCustomObject]@{
        TableName = $reader['TableName']
        ColumnName = $reader['ColumnName']
    }
}
$reader.Close()

Write-Host "Scanning $($columns.Count) text columns for potential corrupted encoding..."

foreach ($col in $columns) {
    $tableName = $col.TableName
    $columnName = $col.ColumnName
    
    $whereClauses = @()
    foreach ($p in $patterns) {
        $whereClauses += "[$columnName] LIKE '$p'"
    }
    $whereStr = $whereClauses -join " OR "
    
    try {
        $checkCmd = $conn.CreateCommand()
        $checkCmd.CommandText = "SELECT COUNT(*) FROM [$tableName] WHERE $whereStr"
        $count = $checkCmd.ExecuteScalar()
        if ($count -gt 0) {
            Write-Host "  [FOUND] Table: $tableName | Column: $columnName | Rows: $count"
            
            $exCmd = $conn.CreateCommand()
            $exCmd.CommandText = "SELECT TOP 3 [$columnName] FROM [$tableName] WHERE $whereStr"
            $exReader = $exCmd.ExecuteReader()
            while ($exReader.Read()) {
                Write-Host "    Example value: $($exReader[0])"
            }
            $exReader.Close()
        }
    } catch {
        # Column might not be compatible or table is special view, skip
    }
}

$conn.Close()
