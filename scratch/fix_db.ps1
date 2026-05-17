$connString = "Server=0.tcp.ap.ngrok.io,26018;Database=Hshop2023;User Id=sa;Password=QuaMonHai;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connString)
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = "UPDATE KhachHang SET HoTen = @HoTen, DiaChi = @DiaChi WHERE MaKh = @MaKh"

$p1 = $cmd.CreateParameter()
$p1.ParameterName = "@HoTen"
$p1.Value = "Quản trị viên"
$cmd.Parameters.Add($p1) | Out-Null

$p2 = $cmd.CreateParameter()
$p2.ParameterName = "@DiaChi"
$p2.Value = "Biên Hòa, Đồng Nai"
$cmd.Parameters.Add($p2) | Out-Null

$p3 = $cmd.CreateParameter()
$p3.ParameterName = "@MaKh"
$p3.Value = "admin"
$cmd.Parameters.Add($p3) | Out-Null

$rowsAffected = $cmd.ExecuteNonQuery()
Write-Host "Success! Rows updated: $rowsAffected"

$conn.Close()
