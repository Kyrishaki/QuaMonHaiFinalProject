DELETE FROM KhachHang WHERE MaKh = 'admin';
INSERT INTO KhachHang (MaKh, MatKhau, HoTen, GioiTinh, NgaySinh, DiaChi, DienThoai, Email, Hinh, HieuLuc, VaiTro, RandomKey)
VALUES (
    'admin', 
    '33c2264667566f6ccf60794b2a1f1a27', 
    N'Quản trị viên', 
    1, 
    '2000-01-01', 
    N'Biên Hòa, Đồng Nai', 
    '0936363636', 
    'admin@quamonhai.com', 
    'default-avatar.jpg', 
    1, 
    1, 
    'abcde'
);
