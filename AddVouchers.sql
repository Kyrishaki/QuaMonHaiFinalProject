-- ==========================================================================
-- AddVouchers.sql - Populates the GiamGia (Voucher) table with 7 beautiful promos
-- Compatible with site4now.net Remote Database and local SQL Server
-- ==========================================================================

-- Check if table GiamGia exists before inserting
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GiamGia]') AND type in (N'U'))
BEGIN
    -- 1. WELCOME5: Welcome discount for new customers
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'WELCOME5')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'WELCOME5', 5, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 20, 1000, 1);
    END

    -- 2. SUMMER10: Summer promotion code
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'SUMMER10')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'SUMMER10', 10, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 50, 500, 1);
    END

    -- 3. QMHVIP15: Exclusive discount for VIP customers
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'QMHVIP15')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'QMHVIP15', 15, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 100, 200, 1);
    END

    -- 4. BIGDEAL20: Mega discount for large orders
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'BIGDEAL20')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'BIGDEAL20', 20, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 150, 150, 1);
    END

    -- 5. MEGA50: Special high-value order discount
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'MEGA50')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'MEGA50', 50, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 300, 50, 1);
    END

    -- 6. HAPPYWEEKEND: Weekend shopping promotional discount
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'HAPPYWEEKEND')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'HAPPYWEEKEND', 8, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 40, 300, 1);
    END

    -- 7. FREESHIP: Shipping value discount code
    IF NOT EXISTS (SELECT 1 FROM [dbo].[GiamGia] WHERE [TenMa] = 'FREESHIP')
    BEGIN
        INSERT [dbo].[GiamGia] ([TenMa], [PhanTramGiam], [NgayBatDau], [NgayKetThuc], [GiaTriDonToiThieu], [SoLanSuDung], [TrangThai])
        VALUES (N'FREESHIP', 10, '2026-01-01 00:00:00.000', '2028-12-31 23:59:59.000', 30, 2000, 1);
    END
    
    PRINT '7 vouchers seeded successfully!';
END
ELSE
BEGIN
    PRINT 'Error: Table GiamGia does not exist.';
END
GO
