$connString = "Server=0.tcp.ap.ngrok.io,26018;Database=Hshop2023;User Id=sa;Password=QuaMonHai;TrustServerCertificate=True;"
$conn = New-Object System.Data.SqlClient.SqlConnection($connString)
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = "SELECT MaNv, HoTen, Email FROM NhanVien"
$reader = $cmd.ExecuteReader()
while ($reader.Read()) {
    Write-Host "MaNv: $($reader['MaNv']) | HoTen: $($reader['HoTen']) | Email: $($reader['Email'])"
}
$reader.Close()
$conn.Close()
