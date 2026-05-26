-- ==========================================================================
-- HShopScript_Full.sql - Combined SQL script generated from QMHaiDB.sql
-- Generated: 2026-05-24
-- Compatible with local SQL Server (Hshop2023) and Remote hosting (site4now.net)
-- ==========================================================================

USE [master]
GO
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Hshop2023')
BEGIN
    CREATE DATABASE [Hshop2023];
END;
GO
USE [Hshop2023]
GO

-- ========================================== 
-- 1. CREATE TABLES 
-- ========================================== 

/****** Object:  Table [dbo].[BanBe] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BanBe]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BanBe](
    	[MaBb] [int] IDENTITY(1,1) NOT NULL,
    	[MaKh] [nvarchar](20) NULL,
    	[MaHh] [int] NOT NULL,
    	[HoTen] [nvarchar](50) NULL,
    	[Email] [nvarchar](50) NOT NULL,
    	[NgayGui] [datetime] NOT NULL,
    	[GhiChu] [nvarchar](max) NULL,
     CONSTRAINT [PK_BanBe] PRIMARY KEY CLUSTERED 
    (
    	[MaBb] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[BinhLuan] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BinhLuan]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[BinhLuan](
    	[MaBL] [int] IDENTITY(1,1) NOT NULL,
    	[MaHH] [int] NOT NULL,
    	[MaKH] [nvarchar](20) NOT NULL,
    	[Sao] [int] NOT NULL,
    	[NoiDung] [nvarchar](max) NULL,
    	[Ngay] [datetime] NOT NULL,
     CONSTRAINT [PK_BinhLuan] PRIMARY KEY CLUSTERED 
    (
    	[MaBL] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[ChatMessage] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChatMessage]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ChatMessage](
    	[Id] [int] IDENTITY(1,1) NOT NULL,
    	[ChatRoomId] [nvarchar](50) NOT NULL,
    	[SenderId] [nvarchar](50) NOT NULL,
    	[SenderName] [nvarchar](100) NOT NULL,
    	[Message] [nvarchar](max) NOT NULL,
    	[Timestamp] [datetime] NOT NULL,
    	[IsFromCustomer] [bit] NOT NULL,
    	[IsRead] [bit] NOT NULL,
     CONSTRAINT [PK_ChatMessage] PRIMARY KEY CLUSTERED 
    (
    	[Id] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[ChiTietHD] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChiTietHD]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ChiTietHD](
    	[MaCT] [int] IDENTITY(1,1) NOT NULL,
    	[MaHD] [int] NOT NULL,
    	[MaHH] [int] NOT NULL,
    	[DonGia] [float] NOT NULL,
    	[SoLuong] [int] NOT NULL,
    	[GiamGia] [float] NOT NULL,
    	[MaGG] [int] NULL,
     CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
    (
    	[MaCT] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[ChuDe] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChuDe]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ChuDe](
    	[MaCD] [int] IDENTITY(1,1) NOT NULL,
    	[TenCD] [nvarchar](50) NULL,
    	[MaNV] [nvarchar](50) NULL,
     CONSTRAINT [PK_ChuDe] PRIMARY KEY CLUSTERED 
    (
    	[MaCD] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[GiamGia] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GiamGia]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GiamGia](
    	[MaGG] [int] IDENTITY(1,1) NOT NULL,
    	[TenMa] [nvarchar](50) NOT NULL,
    	[PhanTramGiam] [float] NOT NULL,
    	[NgayBatDau] [datetime] NOT NULL,
    	[NgayKetThuc] [datetime] NOT NULL,
    	[GiaTriDonToiThieu] [float] NOT NULL,
    	[SoLanSuDung] [int] NOT NULL,
    	[TrangThai] [bit] NOT NULL,
     CONSTRAINT [PK_GiamGia] PRIMARY KEY CLUSTERED 
    (
    	[MaGG] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[GioHang] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GioHang]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GioHang](
    	[MaKh] [nvarchar](20) NOT NULL,
    	[MaHh] [int] NOT NULL,
    	[SoLuong] [int] NOT NULL,
     CONSTRAINT [PK_GioHang] PRIMARY KEY CLUSTERED 
    (
    	[MaKh] ASC,
    	[MaHh] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[GopY] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GopY]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GopY](
    	[MaGY] [nvarchar](50) NOT NULL,
    	[MaCD] [int] NOT NULL,
    	[NoiDung] [nvarchar](max) NOT NULL,
    	[NgayGY] [date] NOT NULL,
    	[HoTen] [nvarchar](50) NULL,
    	[Email] [nvarchar](50) NULL,
    	[DienThoai] [nvarchar](50) NULL,
    	[CanTraLoi] [bit] NOT NULL,
    	[TraLoi] [nvarchar](50) NULL,
    	[NgayTL] [date] NULL,
     CONSTRAINT [PK_GopY] PRIMARY KEY CLUSTERED 
    (
    	[MaGY] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[HangHoa] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HangHoa]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HangHoa](
    	[MaHH] [int] IDENTITY(1,1) NOT NULL,
    	[TenHH] [nvarchar](50) NOT NULL,
    	[TenAlias] [nvarchar](50) NULL,
    	[MaLoai] [int] NOT NULL,
    	[MoTaDonVi] [nvarchar](50) NULL,
    	[DonGia] [float] NULL,
    	[Hinh] [nvarchar](50) NULL,
    	[NgaySX] [datetime] NOT NULL,
    	[GiamGia] [float] NOT NULL,
    	[SoLanXem] [int] NOT NULL,
    	[MoTa] [nvarchar](max) NULL,
    	[MaNCC] [nvarchar](50) NOT NULL,
    	[SoLuong] [int] NOT NULL,
    	[GiaSauGiam]  AS (CONVERT([decimal](18,2),round(isnull([DonGia],(0))*((1)-isnull([GiamGia],(0))/(100.0)),(2)))) PERSISTED,
    	[HieuLuc] [bit] NOT NULL,
     CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
    (
    	[MaHH] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[HoaDon] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoaDon]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HoaDon](
    	[MaHD] [int] IDENTITY(1,1) NOT NULL,
    	[MaKH] [nvarchar](20) NOT NULL,
    	[NgayDat] [datetime] NOT NULL,
    	[NgayCan] [datetime] NULL,
    	[NgayGiao] [datetime] NULL,
    	[HoTen] [nvarchar](50) NULL,
    	[DiaChi] [nvarchar](255) NOT NULL,
    	[CachThanhToan] [nvarchar](50) NOT NULL,
    	[CachVanChuyen] [nvarchar](50) NOT NULL,
    	[PhiVanChuyen] [float] NOT NULL,
    	[MaTrangThai] [int] NOT NULL,
    	[MaNV] [nvarchar](50) NULL,
    	[GhiChu] [nvarchar](50) NULL,
    	[SoDienThoai] [int] NULL,
     CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
    (
    	[MaHD] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[HoiDap] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HoiDap]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[HoiDap](
    	[MaHD] [int] NOT NULL,
    	[CauHoi] [nvarchar](50) NOT NULL,
    	[TraLoi] [nvarchar](50) NOT NULL,
    	[NgayDua] [date] NOT NULL,
    	[MaNV] [nvarchar](50) NOT NULL,
     CONSTRAINT [PK_HoiDap] PRIMARY KEY CLUSTERED 
    (
    	[MaHD] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[KhachHang] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[KhachHang]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[KhachHang](
    	[MaKH] [nvarchar](20) NOT NULL,
    	[MatKhau] [nvarchar](50) NULL,
    	[HoTen] [nvarchar](50) NOT NULL,
    	[GioiTinh] [bit] NOT NULL,
    	[NgaySinh] [datetime] NOT NULL,
    	[DiaChi] [nvarchar](60) NULL,
    	[DienThoai] [nvarchar](24) NULL,
    	[Email] [nvarchar](50) NOT NULL,
    	[Hinh] [nvarchar](50) NULL,
    	[HieuLuc] [bit] NOT NULL,
    	[VaiTro] [int] NOT NULL,
    	[RandomKey] [varchar](50) NULL,
     CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
    (
    	[MaKH] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[Loai] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Loai]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Loai](
    	[MaLoai] [int] IDENTITY(1,1) NOT NULL,
    	[TenLoai] [nvarchar](50) NOT NULL,
    	[TenLoaiAlias] [nvarchar](50) NULL,
    	[MoTa] [nvarchar](max) NULL,
    	[Hinh] [nvarchar](50) NULL,
     CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
    (
    	[MaLoai] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[NhaCungCap] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NhaCungCap]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[NhaCungCap](
    	[MaNCC] [nvarchar](50) NOT NULL,
    	[TenCongTy] [nvarchar](50) NOT NULL,
    	[Logo] [nvarchar](50) NOT NULL,
    	[NguoiLienLac] [nvarchar](50) NULL,
    	[Email] [nvarchar](50) NOT NULL,
    	[DienThoai] [nvarchar](50) NULL,
    	[DiaChi] [nvarchar](50) NULL,
    	[MoTa] [nvarchar](max) NULL,
     CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
    (
    	[MaNCC] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[NhanVien] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NhanVien]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[NhanVien](
    	[MaNV] [nvarchar](50) NOT NULL,
    	[HoTen] [nvarchar](50) NOT NULL,
    	[Email] [nvarchar](50) NOT NULL,
    	[MatKhau] [nvarchar](50) NULL,
     CONSTRAINT [PK_NhanVien] PRIMARY KEY CLUSTERED 
    (
    	[MaNV] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[PhanCong] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhanCong]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PhanCong](
    	[MaPC] [int] IDENTITY(1,1) NOT NULL,
    	[MaNV] [nvarchar](50) NOT NULL,
    	[MaPB] [varchar](7) NOT NULL,
    	[NgayPC] [datetime] NULL,
    	[HieuLuc] [bit] NULL,
     CONSTRAINT [PK_PhanCong] PRIMARY KEY CLUSTERED 
    (
    	[MaPC] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[PhanQuyen] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhanQuyen]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PhanQuyen](
    	[MaPQ] [int] IDENTITY(1,1) NOT NULL,
    	[MaPB] [varchar](7) NULL,
    	[MaTrang] [int] NULL,
    	[Them] [bit] NOT NULL,
    	[Sua] [bit] NOT NULL,
    	[Xoa] [bit] NOT NULL,
    	[Xem] [bit] NOT NULL,
     CONSTRAINT [PK_PhanQuyen] PRIMARY KEY CLUSTERED 
    (
    	[MaPQ] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[PhongBan] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PhongBan]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[PhongBan](
    	[MaPB] [varchar](7) NOT NULL,
    	[TenPB] [nvarchar](50) NOT NULL,
    	[ThongTin] [nvarchar](max) NULL,
     CONSTRAINT [PK_PhongBan] PRIMARY KEY CLUSTERED 
    (
    	[MaPB] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TrangThai] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrangThai]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TrangThai](
    	[MaTrangThai] [int] NOT NULL,
    	[TenTrangThai] [nvarchar](50) NOT NULL,
    	[MoTa] [nvarchar](500) NULL,
     CONSTRAINT [PK_TrangThai] PRIMARY KEY CLUSTERED 
    (
    	[MaTrangThai] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[TrangWeb] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TrangWeb]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TrangWeb](
    	[MaTrang] [int] IDENTITY(1,1) NOT NULL,
    	[TenTrang] [nvarchar](50) NOT NULL,
    	[URL] [nvarchar](250) NOT NULL,
     CONSTRAINT [PK_TrangWeb] PRIMARY KEY CLUSTERED 
    (
    	[MaTrang] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

/****** Object:  Table [dbo].[YeuThich] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[YeuThich]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[YeuThich](
    	[MaYT] [int] IDENTITY(1,1) NOT NULL,
    	[MaHH] [int] NULL,
    	[MaKH] [nvarchar](20) NULL,
    	[NgayChon] [datetime] NULL,
    	[MoTa] [nvarchar](255) NULL,
     CONSTRAINT [PK_Favorites] PRIMARY KEY CLUSTERED 
    (
    	[MaYT] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END
GO

-- ========================================== 
-- 2. CREATE VIEWS 
-- ========================================== 

/****** Object:  View [dbo].[vChiTietHoaDon] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vChiTietHoaDon]'))
BEGIN
    EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vChiTietHoaDon]
AS 
	SELECT cthd.*, TenHH
	FROM ChiTietHD cthd JOIN HangHoa hh 
		ON hh.MaHH = cthd.MaHH'
END
GO

-- ========================================== 
-- 3. DEFAULT CONSTRAINTS 
-- ========================================== 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_BanBe_NgayGui')
BEGIN
    ALTER TABLE [dbo].[BanBe] ADD CONSTRAINT [DF_BanBe_NgayGui] DEFAULT (getdate()) FOR [NgayGui]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_BinhLuan_Ngay')
BEGIN
    ALTER TABLE [dbo].[BinhLuan] ADD CONSTRAINT [DF_BinhLuan_Ngay] DEFAULT (getdate()) FOR [Ngay]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_ChatMessage_Timestamp')
BEGIN
    ALTER TABLE [dbo].[ChatMessage] ADD CONSTRAINT [DF_ChatMessage_Timestamp] DEFAULT (getdate()) FOR [Timestamp]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_ChatMessage_IsFromCustomer')
BEGIN
    ALTER TABLE [dbo].[ChatMessage] ADD CONSTRAINT [DF_ChatMessage_IsFromCustomer] DEFAULT ((1)) FOR [IsFromCustomer]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_ChatMessage_IsRead')
BEGIN
    ALTER TABLE [dbo].[ChatMessage] ADD CONSTRAINT [DF_ChatMessage_IsRead] DEFAULT ((0)) FOR [IsRead]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Order_Details_UnitPrice')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD] ADD  CONSTRAINT [DF_Order_Details_UnitPrice]  DEFAULT ((0)) FOR [DonGia]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Order_Details_Quantity')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD] ADD  CONSTRAINT [DF_Order_Details_Quantity]  DEFAULT ((1)) FOR [SoLuong]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Order_Details_Discount')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD] ADD  CONSTRAINT [DF_Order_Details_Discount]  DEFAULT ((0)) FOR [GiamGia]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_GiamGia_PhanTramGiam')
BEGIN
    ALTER TABLE [dbo].[GiamGia] ADD CONSTRAINT [DF_GiamGia_PhanTramGiam] DEFAULT ((0)) FOR [PhanTramGiam]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_GiamGia_TrangThai')
BEGIN
    ALTER TABLE [dbo].[GiamGia] ADD CONSTRAINT [DF_GiamGia_TrangThai] DEFAULT ((1)) FOR [TrangThai]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_GioHang_SoLuong')
BEGIN
    ALTER TABLE [dbo].[GioHang] ADD CONSTRAINT [DF_GioHang_SoLuong] DEFAULT ((1)) FOR [SoLuong]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_GopY_NgayGY')
BEGIN
    ALTER TABLE [dbo].[GopY] ADD  CONSTRAINT [DF_GopY_NgayGY]  DEFAULT (getdate()) FOR [NgayGY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_GopY_CanTraLoi')
BEGIN
    ALTER TABLE [dbo].[GopY] ADD  CONSTRAINT [DF_GopY_CanTraLoi]  DEFAULT ((0)) FOR [CanTraLoi]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Products_UnitPrice')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD  CONSTRAINT [DF_Products_UnitPrice]  DEFAULT ((0)) FOR [DonGia]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Products_ProductDate')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD  CONSTRAINT [DF_Products_ProductDate]  DEFAULT (getdate()) FOR [NgaySX]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Products_Discount')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD  CONSTRAINT [DF_Products_Discount]  DEFAULT ((0)) FOR [GiamGia]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Products_Votes')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD  CONSTRAINT [DF_Products_Votes]  DEFAULT ((0)) FOR [SoLanXem]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_HangHoa_SoLuong')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD CONSTRAINT [DF_HangHoa_SoLuong] DEFAULT ((100)) FOR [SoLuong]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_HangHoa_HieuLuc')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD CONSTRAINT [DF_HangHoa_HieuLuc] DEFAULT ((1)) FOR [HieuLuc]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_OrderDate')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_OrderDate]  DEFAULT (getdate()) FOR [NgayDat]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_RequireDate')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_RequireDate]  DEFAULT (getdate()) FOR [NgayCan]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_ShippedDate')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_ShippedDate]  DEFAULT (((1)/(1))/(1900)) FOR [NgayGiao]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_PaymentMethod')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_PaymentMethod]  DEFAULT (N'Cash') FOR [CachThanhToan]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_ShippingMethod')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_ShippingMethod]  DEFAULT (N'Airline') FOR [CachVanChuyen]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_Freight')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_Freight]  DEFAULT ((0)) FOR [PhiVanChuyen]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Orders_Status')
BEGIN
    ALTER TABLE [dbo].[HoaDon] ADD  CONSTRAINT [DF_Orders_Status]  DEFAULT ((0)) FOR [MaTrangThai]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_HoiDap_NgayDua')
BEGIN
    ALTER TABLE [dbo].[HoiDap] ADD  CONSTRAINT [DF_HoiDap_NgayDua]  DEFAULT (getdate()) FOR [NgayDua]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Customers_Gender')
BEGIN
    ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [DF_Customers_Gender]  DEFAULT ((0)) FOR [GioiTinh]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Customers_Birthday')
BEGIN
    ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [DF_Customers_Birthday]  DEFAULT (getdate()) FOR [NgaySinh]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Customers_Photo')
BEGIN
    ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [DF_Customers_Photo]  DEFAULT (N'Photo.gif') FOR [Hinh]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Customers_Active')
BEGIN
    ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [DF_Customers_Active]  DEFAULT ((0)) FOR [HieuLuc]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_Customers_UserLevel')
BEGIN
    ALTER TABLE [dbo].[KhachHang] ADD  CONSTRAINT [DF_Customers_UserLevel]  DEFAULT ((0)) FOR [VaiTro]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_PhanQuyen_Them')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen] ADD  CONSTRAINT [DF_PhanQuyen_Them]  DEFAULT ((0)) FOR [Them]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_PhanQuyen_Sua')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen] ADD  CONSTRAINT [DF_PhanQuyen_Sua]  DEFAULT ((0)) FOR [Sua]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_PhanQuyen_Xoa')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen] ADD  CONSTRAINT [DF_PhanQuyen_Xoa]  DEFAULT ((0)) FOR [Xoa]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE name = 'DF_PhanQuyen_Xem')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen] ADD  CONSTRAINT [DF_PhanQuyen_Xem]  DEFAULT ((0)) FOR [Xem]
END
GO

-- ========================================== 
-- 4. INSERT DATA 
-- ========================================== 

﻿IF NOT EXISTS (SELECT 1 FROM [dbo].[ChiTietHD])
BEGIN
    SET IDENTITY_INSERT [dbo].[ChiTietHD] ON
    SET IDENTITY_INSERT [dbo].[ChiTietHD] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[HangHoa])
BEGIN
    SET IDENTITY_INSERT [dbo].[HangHoa] ON
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1001, N'Đồng hồ Swatch Gold Chronograph', N'swatch-gold-chronograph', 1000, N'10 boxes x 20 bags', 190, N'41MJUdI2jdL._SL500_AA300_.jpg', CAST(N'2009-07-31T00:00:00.000' AS DateTime), 0, 1378, N'Đồng hồ Thụy Sỹ Swatch nổi bật với ngôn ngữ thiết kế trẻ trung, phối màu cá tính và thời trang độc đáo. Sử dụng bộ máy Quartz Thụy Sỹ đo giờ chính xác tuyệt đối, vỏ chất liệu cao cấp nhẹ nhàng cùng khả năng chống nước tốt, đây là món phụ kiện hoàn hảo để tôn lên phong cách năng động và hiện đại của bạn.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1002, N'Đồng hồ Tissot T-Touch Silver', N'tissot-t-touch-silver', 1000, N'10 boxes x 20 bags', 19, N'41TexqWVkHL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1562, N'Đồng hồ Thụy Sỹ Tissot danh tiếng lâu đời, mang phong cách thiết kế sang trọng, lịch lãm đầy lôi cuốn của giới thượng lưu. Trang bị mặt kính Sapphire nguyên khối chống trầy xước hoàn hảo, bộ máy Automatic cơ khí tinh xảo hoạt động bền bỉ, là biểu tượng đẳng cấp dành riêng cho quý ông và quý bà thành đạt.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1003, N'Laptop HP Premium Minimalist', N'hp-premium-minimalist-laptop', 1001, N'12 - 550 ml bottles', 1001, N'31EPGSm2s1L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 491, N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.', N'HP')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1004, N'Laptop ASUS Core i5 Standard', N'asus-core-i5-standard', 1001, N'48 - 6 oz jars', 22, N'41CIcYRxJKL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 216, N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.', N'AC')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1005, N'Laptop Dell Inspiron Kayak Edition', N'dell-inspiron-kayak-edition', 1001, N'36 boxes', 21.35, N'41G38jC0ajL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 134, N'Laptop Dell sở hữu thiết kế tối giản, bộ khung vỏ chắc chắn đạt tiêu chuẩn độ bền quân đội. Được trang bị cấu hình phần cứng mạnh mẽ với vi xử lý Intel Core hiệu năng cao, dung lượng RAM lớn và ổ cứng SSD tốc độ cao, máy đáp ứng hoàn hảo từ các tác vụ văn phòng, lập trình kỹ thuật chuyên sâu cho đến nhu cầu học tập và giải trí đa phương tiện mượt mà.', N'DE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1006, N'Laptop ASUS Vivobook Slim', N'asus-vivobook-slim', 1001, N'12 - 8 oz jars', 25, N'41iDo0HDhbL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 153, N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.', N'AC')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1007, N'Giày bốt tuyết Black Winter Snow', N'giay-bot-tuyet-black-winter-snow', 1006, N'12 - 1 lb pkgs.', 30, N'81k1XbQ6nQL._SL1500_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 5006, N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1008, N'Laptop HP Pavilion Silver Slim', N'hp-pavilion-silver-slim', 1001, N'12 - 12 oz jars', 40, N'41LMouG6j7L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.', N'HP')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1009, N'Nhẫn vàng đính đá Opal & Diamonds', N'nhan-vang-dinh-da-opal-diamonds', 1005, N'18 - 500 g pkgs.', 97, N'21meTyhQebL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 3, N'Nhẫn bạc đính đá Opal trắng tự nhiên với ánh ngũ sắc xà cừ kỳ diệu lấp lánh thay đổi theo góc nhìn, kết hợp cùng các viên đá kim cương nhân tạo CZ tinh xảo. Món trang sức phong thủy mang lại may mắn, bình an, đồng thời tôn lên vẻ đẹp kiêu sa, quý phái của chủ nhân.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1010, N'Vali balo Osprey Green Rolling', N'vali-balo-osprey-green-rolling', 1007, N'12 - 200 ml jars', 31, N'31hCgES5GXL._AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 3, N'Vali balo Osprey đa năng thông minh kết hợp hoàn hảo giữa balo phượt chuyên dụng và vali kéo tiện lợi. Chất liệu vải nylon chống rách siêu nhẹ chống thấm nước, quai đeo trợ lực thiết kế công thái học ôm sát lưng cùng tay kéo hợp kim chắc khỏe, là bạn đồng hành lý tưởng.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1011, N'Điện thoại BlackBerry Bold Classic', N'blackberry-bold-classic', 1003, N'1 kg pkg.', 21, N'31jsjfVfH9L._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1012, N'Điện thoại LG Cookie KP500 Stylus', N'lg-cookie-kp500-stylus', 1003, N'10 - 500 g pkgs.', 38, N'41BiMx1FKyL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'SE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1013, N'Vali Samsonite Classic Black Rolling', N'vali-samsonite-classic-black-rolling', 1007, N'2 kg box', 6, N'31ioCUUFnoL.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1014, N'Giày bốt Sorel Beige Winter Boots', N'giay-bot-sorel-beige-winter-boots', 1006, N'40 - 100 g pkgs.', 23.25, N'81Q1DvOnnoL._SL1500_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1015, N'Laptop Toshiba Dynabook Professional', N'toshiba-dynabook-professional', 1001, N'24 - 250 ml bottles', 15.5, N'41qlcUEhNmL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop Toshiba nổi tiếng với độ bền vượt trội theo thời gian và sự ổn định cao trong vận hành. Máy sở hữu thiết kế chắc chắn, bàn phím tiêu chuẩn gõ êm và cấu hình tối ưu tốt cho mọi tác vụ văn phòng cơ bản, duyệt web, xử lý dữ liệu và học tập hàng ngày.', N'SE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1016, N'Máy ảnh Nikon D7000 DSLR Professional', N'nikon-d7000-dslr-professional', 1002, N'32 - 500 g boxes', 17.45, N'41iji4-9UsL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 329, N'Máy ảnh bán chuyên nghiệp DSLR Nikon sở hữu cảm biến ảnh lớn, chip xử lý hình ảnh tốc độ cao mang lại chất lượng ảnh chuyên nghiệp tuyệt vời. Khả năng lấy nét tự động cực nhanh, dải ISO rộng chụp thiếu sáng xuất sắc cùng khả năng thay đổi ống kính linh hoạt, đáp ứng mọi đam mê sáng tạo nhiếp ảnh.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1017, N'Nhẫn bạc Celtic Knot Ring', N'nhan-bac-celtic-knot-ring', 1005, N'20 - 1 kg tins', 39, N'31LAnW1JFqL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Nhẫn bạc Celtic Knot mang ngôn ngữ thiết kế nút thắt vô tận độc đáo của người Ireland cổ đại, biểu tượng cho tình yêu vĩnh cửu và sự gắn kết vô tận. Nhẫn chế tác tinh xảo từ chất liệu bạc Sterling 925 sáng bóng, phong cách thanh lịch, tinh tế thích hợp đeo hàng ngày.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1018, N'Vali Samsonite Classic Blue Rolling', N'vali-samsonite-classic-blue-rolling', 1007, N'16 kg pkg.', 62.5, N'31yxRemzRLL._SS350_ (1).jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1019, N'Máy ảnh Canon PowerShot SD1300 Blue', N'canon-powershot-sd1300-blue', 1002, N'10 boxes x 12 pieces', 9.2, N'41KALboJKuL.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 12, N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1020, N'Máy ảnh Nikon COOLPIX Silver Pocket', N'nikon-coolpix-silver-pocket', 1002, N'30 gift boxes', 81, N'41sl3FN6NpL.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1021, N'Máy ảnh Nikon COOLPIX Lime Green', N'nikon-coolpix-lime-green', 1002, N'24 pkgs. x 4 pieces', 10, N'41w4TlVPhGL.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1022, N'Nước hoa Guess for Women EDP Pink', N'guess-for-women-edp-pink', 1004, N'24 - 500 g pkgs.', 21, N'31pT+SdvQXL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 40, N'Nước hoa Guess dành cho phái đẹp mang hương thơm thanh mát ngọt ngào đầy quyến rũ. Sự kết hợp tinh tế từ hương quả mọng tươi trẻ, hoa mẫu đơn thanh lịch ở tầng hương giữa và gỗ ấm áp xạ hương ở tầng hương cuối tạo nên một phong cách thanh lịch, quyến rũ và đầy lôi cuốn.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1023, N'Nước hoa Dolce & Gabbana Light Blue', N'dolce-gabbana-light-blue', 1004, N'12 - 250 g pkgs.', 9, N'31YOss-gC-L._AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 762, N'Nước hoa cao cấp Dolce & Gabbana Light Blue mang hương thơm phóng khoáng, tươi mát tràn đầy năng lượng tươi trẻ của biển Địa Trung Hải. Sự hòa quyện hoàn hảo giữa chanh vàng Ý tươi mát, táo xanh giòn ngọt kết hợp cùng gỗ tuyết tùng ấm áp, mang lại hương thơm sảng khoái suốt cả ngày.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1024, N'Đồng hồ Citizen Eco-Drive Promaster', N'citizen-eco-drive-promaster', 1000, N'12 - 355 ml cans', 4.5, N'41V4Ds2PtZL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 96, N'Đồng hồ Citizen tích hợp công nghệ Eco-Drive độc quyền giúp hấp thu và chuyển hóa mọi nguồn sáng thành năng lượng hoạt động, hoàn toàn không cần thay pin. Thiết kế tinh xảo với vỏ thép không gỉ cao cấp, mặt kính chống xước cùng khả năng chống nước vượt trội, mang lại vẻ ngoài lịch lãm và nam tính mạnh mẽ.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1025, N'Máy ảnh Nikon COOLPIX Royal Blue', N'nikon-coolpix-royal-blue', 1002, N'20 - 450 g glasses', 14, N'41XX7Pi240L.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1026, N'Máy ảnh Fujifilm FinePix Bridge Camera', N'fujifilm-finepix-bridge-camera', 1002, N'100 - 250 g bags', 31.23, N'41-yvkFqVZL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh Fujifilm sở hữu thiết kế cổ điển sang trọng cùng công nghệ giả lập màu phim trứ danh độc quyền. Ảnh chụp có độ chi tiết rất cao, màu sắc mang đậm tính nghệ thuật cổ điển, lấy nét tự động nhanh chóng và chính xác, lý tưởng cho những ai yêu thích nhiếp ảnh đường phố.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1027, N'Máy ảnh Canon PowerShot S95 Premium', N'canon-powershot-s95-premium', 1002, N'100 - 100 g pieces', 43.9, N'41ZE9SmWdzL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1028, N'Giày bốt Sorel Waterproof Active', N'giay-bot-sorel-waterproof-active', 1006, N'25 - 825 g cans', 45.6, N'91FM0Hog9FL._SL1500_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Giày bốt dã ngoại Sorel chống nước hoàn hảo với cổ giày lót lông ấm áp, chất liệu cao su đúc nguyên khối chống thấm bền bỉ. Thiết kế thể thao khỏe khoắn năng động, đế bám cực tốt chống trơn trượt hiệu quả, chuyên dụng cho hoạt động leo núi, dã ngoại thời tiết xấu.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1029, N'Nhẫn bạc đính đá White Opal Stone', N'nhan-bac-dinh-da-white-opal-stone', 1005, N'50 bags x 30 sausgs.', 123.79, N'31ncPnMYCxL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 2, N'Nhẫn bạc đính đá Opal trắng tự nhiên với ánh ngũ sắc xà cừ kỳ diệu lấp lánh thay đổi theo góc nhìn, kết hợp cùng các viên đá kim cương nhân tạo CZ tinh xảo. Món trang sức phong thủy mang lại may mắn, bình an, đồng thời tôn lên vẻ đẹp kiêu sa, quý phái của chủ nhân.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1030, N'Vali balo High Sierra Grey Rolling', N'vali-balo-high-sierra-grey-rolling', 1007, N'10 - 200 g glasses', 25.89, N'41lffECD-sL._SY445_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali balo High Sierra đa năng năng động tích hợp ngăn chứa đồ thông minh siêu rộng rãi. Bánh xe kéo thể thao chắc khỏe di chuyển mượt mà kết hợp hệ thống quai đeo balo ẩn hiện linh hoạt, thích hợp cho các chuyến du lịch ngắn ngày, dã ngoại dạo phố.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1031, N'Điện thoại BlackBerry Curve AT&T', N'blackberry-curve-att', 1003, N'12 - 100 g pkgs', 12.5, N'41IPLmZIKhL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1032, N'Điện thoại Nokia E71 QWERTY Silver', N'nokia-e71-qwerty-silver', 1003, N'24 - 200 g pkgs.', 32, N'41qfgTvFBwL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 0, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1033, N'Điện thoại Nokia E71 QWERTY Metallic Grey', N'nokia-e71-qwerty-metallic-grey', 1003, N'500 g', 2.5, N'41qfgTvFBwL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1034, N'Đồng hồ Michael Kors Rose Gold', N'michael-kors-rose-gold', 1000, N'24 - 12 oz bottles', 14, N'41WvZnGYUkL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 7, N'Đồng hồ Michael Kors thời trang Mỹ thời thượng với thiết kế mạ vàng hồng quý phái, viền đính đá Swarovski lấp lánh sang trọng. Đây là món trang sức hoàn hảo tôn vinh vẻ đẹp kiều diễm, thanh lịch và kiêu kỳ của phái đẹp trong mọi bữa tiệc và sự kiện quan trọng.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1035, N'Đồng hồ TAG Heuer Aquaracer Special', N'dong-ho-tag-heuer-aquaracer-special', 1000, N'24 - 12 oz bottles', 18, N'41yh1vBmqsL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1036, N'Vali balo High Sierra Black Duffel', N'vali-balo-high-sierra-black-duffel', 1007, N'24 - 250 g  jars', 19, N'41sw9ASUvBL._SX342_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali balo High Sierra đa năng năng động tích hợp ngăn chứa đồ thông minh siêu rộng rãi. Bánh xe kéo thể thao chắc khỏe di chuyển mượt mà kết hợp hệ thống quai đeo balo ẩn hiện linh hoạt, thích hợp cho các chuyến du lịch ngắn ngày, dã ngoại dạo phố.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1037, N'Vali Samsonite Burgundy Rolling', N'vali-samsonite-burgundy-rolling', 1007, N'12 - 500 g pkgs.', 26, N'41Z43OmFHjL._SX342_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1038, N'Đồng hồ Luminox Navy SEAL Sports', N'dong-ho-luminox-navy-seal-sports', 1000, N'12 - 75 cl bottles', 263.5, N'41Ymq8fjbOL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 3, N'Đồng hồ chuyên dụng quân đội siêu bền bỉ Luminox, vỏ chất liệu carbon siêu nhẹ chống sốc và chịu va đập cực tốt. Trang bị công nghệ ống khí tự phát sáng liên tục suốt 25 năm bất kể điều kiện ánh sáng, khả năng chống nước cực cao, được tin dùng bởi lực lượng đặc nhiệm Navy SEAL.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1039, N'Đồng hồ TAG Heuer Carrera Chronograph', N'dong-ho-tag-heuer-carrera-chronograph', 1000, N'750 cc per bottle', 18, N'51GBNkHO6vL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 1, N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1040, N'Vali Samsonite Essential Black Rolling', N'vali-samsonite-essential-black-rolling', 1007, N'24 - 4 oz tins', 18.4, N'51JhyHtnEgL._SL1001_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1041, N'Vali Samsonite Purple Rolling', N'vali-samsonite-purple-rolling', 1007, N'12 - 12 oz cans', 9.65, N'71bJrFAys9L._SL1280_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1042, N'Nước hoa Paris Hilton Eau de Parfum', N'paris-hilton-eau-de-parfum', 1004, N'32 - 1 kg pkgs.', 14, N'41A9R5KXCXL._AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 0, N'Nước hoa Paris Hilton mang phong cách ngọt ngào, gợi cảm và vô cùng quyến rũ, kiêu sa. Hương thơm chủ đạo là sự kết hợp ngọt lịm từ dưa gang nhiệt đới, đào mọng cùng hương các loài hoa sang quý, thích hợp cho những buổi hẹn hò lãng mạn hoặc tiệc đêm sang trọng.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1043, N'Đồng hồ Citizen Eco-Drive Chandler', N'citizen-eco-drive-chandler', 1000, N'16 - 500 g tins', 46, N'51czOOat0OL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 2, N'Đồng hồ Citizen tích hợp công nghệ Eco-Drive độc quyền giúp hấp thu và chuyển hóa mọi nguồn sáng thành năng lượng hoạt động, hoàn toàn không cần thay pin. Thiết kế tinh xảo với vỏ thép không gỉ cao cấp, mặt kính chống xước cùng khả năng chống nước vượt trội, mang lại vẻ ngoài lịch lãm và nam tính mạnh mẽ.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1044, N'Laptop Dell Latitude Business Slim', N'dell-latitude-business-slim', 1001, N'20 - 2 kg bags', 19.45, N'41riQRGf-6L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop Dell sở hữu thiết kế tối giản, bộ khung vỏ chắc chắn đạt tiêu chuẩn độ bền quân đội. Được trang bị cấu hình phần cứng mạnh mẽ với vi xử lý Intel Core hiệu năng cao, dung lượng RAM lớn và ổ cứng SSD tốc độ cao, máy đáp ứng hoàn hảo từ các tác vụ văn phòng, lập trình kỹ thuật chuyên sâu cho đến nhu cầu học tập và giải trí đa phương tiện mượt mà.', N'DE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1045, N'Vali Samsonite Red Premium Rolling', N'vali-samsonite-red-premium-rolling', 1007, N'1k pkg.', 9.5, N'71cBwWAgvIL._SL1430_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1046, N'Vali London Fog Pegasus Brown Leather', N'vali-london-fog-pegasus-brown-leather', 1007, N'4 - 450 g glasses', 12, N'91T2BjUkYmL._SL1500_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Vali kéo cao cấp London Fog mang phong cách cổ điển lịch lãm mang đậm chất hoàng gia Anh. Vali sử dụng chất liệu vải dệt họa tiết sang trọng kết hợp viền da cao cấp bền bỉ, khoang chứa rộng rãi chia ngăn thông minh cùng hệ thống bánh xe xoay 360 độ êm ái.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1047, N'Máy ảnh Panasonic LUMIX Red Compact', N'panasonic-lumix-red-compact', 1002, N'10 - 4 oz boxes', 9.5, N'51s6pbRlNyL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Máy ảnh Panasonic LUMIX dòng compact cao cấp, trang bị ống kính Leica danh tiếng thế giới. Máy cho chất lượng quay phim và chụp ảnh sắc nét, dải tương phản động rộng cùng hệ thống chống rung quang học 5 trục hiện đại, phong cách gọn nhẹ tiện dụng.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1048, N'Máy ảnh Fujifilm FinePix J40 Black', N'fujifilm-finepix-j40-black', 1002, N'10 pkgs.', 12.75, N'91JUBDf1jTL._AA1500_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh Fujifilm sở hữu thiết kế cổ điển sang trọng cùng công nghệ giả lập màu phim trứ danh độc quyền. Ảnh chụp có độ chi tiết rất cao, màu sắc mang đậm tính nghệ thuật cổ điển, lấy nét tự động nhanh chóng và chính xác, lý tưởng cho những ai yêu thích nhiếp ảnh đường phố.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1049, N'Máy ảnh Canon PowerShot SX130 IS', N'canon-powershot-sx130-is', 1002, N'24 - 50 g pkgs.', 20, N'51w+JqOnmSL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1050, N'Máy ảnh Nikon D3100 DSLR Starter', N'nikon-d3100-dslr-starter', 1002, N'12 - 100 g bars', 16.25, N'51yomC0EodL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh bán chuyên nghiệp DSLR Nikon sở hữu cảm biến ảnh lớn, chip xử lý hình ảnh tốc độ cao mang lại chất lượng ảnh chuyên nghiệp tuyệt vời. Khả năng lấy nét tự động cực nhanh, dải ISO rộng chụp thiếu sáng xuất sắc cùng khả năng thay đổi ống kính linh hoạt, đáp ứng mọi đam mê sáng tạo nhiếp ảnh.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1051, N'Giày bốt UGG Classic Pink Button', N'giay-bot-ugg-classic-pink-button', 1006, N'50 - 300 g pkgs.', 53, N'416pdroSEkL.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Giày bốt lông cừu UGG thời trang cổ ngắn cực kỳ cá tính với thiết kế đính khuy tiện lợi, chất liệu da lộn mềm mại cao cấp. Lớp lông cừu tự nhiên dày ấm bên trong đem lại cảm giác êm ái tối đa cho từng bước đi, phong cách trẻ trung năng động thích hợp cho mùa đông dạo phố.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1052, N'Nước hoa Paris Hilton Heiress Perfume', N'paris-hilton-heiress-perfume', 1004, N'16 - 2 kg boxes', 7, N'41Pg1ahql8L._AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nước hoa Paris Hilton mang phong cách ngọt ngào, gợi cảm và vô cùng quyến rũ, kiêu sa. Hương thơm chủ đạo là sự kết hợp ngọt lịm từ dưa gang nhiệt đới, đào mọng cùng hương các loài hoa sang quý, thích hợp cho những buổi hẹn hò lãng mạn hoặc tiệc đêm sang trọng.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1053, N'Nhẫn bạc đính đá Solitaire Diamond', N'nhan-bac-dinh-da-solitaire-diamond', 1005, N'48 pieces', 32.8, N'31pAGovVENL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nhẫn bạc đính viên đá Solitaire Diamond CZ nhô cao cổ điển lấp lánh tuyệt đẹp thu hút mọi ánh nhìn. Nhẫn được thiết kế tinh xảo, là minh chứng tuyệt vời cho tình yêu đôi lứa bền chặt và là món quà hoàn hảo nhất cho các buổi lễ đính hôn, kỷ niệm đặc biệt.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1054, N'Nhẫn bạc đính đá Moonstone Gem', N'nhan-bac-dinh-da-moonstone-gem', 1005, N'16 pies', 7.45, N'31TB6tC6BOL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 1, N'Nhẫn bạc đính đá Moonstone (đá mặt trăng) mang ánh sáng xà cừ huyền ảo dịu nhẹ đầy cuốn hút dưới ánh đèn. Thiết kế nhẫn thanh mảnh kết hợp ổ nhẫn bạc 925 chế tác tỉ mỉ, mang lại vẻ đẹp dịu dàng thanh tao, mang hơi hướng tâm linh may mắn cho phái đẹp.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1055, N'Nhẫn bạc đính đá Orange Amber', N'nhan-bac-dinh-da-orange-amber', 1005, N'24 boxes x 2 pies', 24, N'41brDHtPY9L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nhẫn bạc đính đá hổ phách Amber tự nhiên màu cam mật ong ấm áp quý phái, mang ý nghĩa thu hút tài lộc, sức khỏe và sự thịnh vượng. Thiết kế nhẫn sang trọng, cổ điển độc bản, vô cùng nổi bật khi kết hợp cùng trang phục dạ tiệc.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1056, N'Nước hoa Calvin Klein Eternity for Men', N'calvin-klein-eternity-for-men', 1004, N'24 - 250 g pkgs.', 38, N'51nukXFJLJL.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nước hoa Calvin Klein Eternity mang phong cách cổ điển, ấm áp, sâu lắng đầy mạnh mẽ nam tính. Tông hương tinh tế mở đầu với oải hương, hương thảo mộc thanh mát, tiếp nối bằng hương gỗ đàn hương và hổ phách ấm áp ở tầng hương cuối, tôn vinh vẻ lịch lãm trưởng thành.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1057, N'Nước hoa Nautica Blue Eau de Toilette', N'nautica-blue-eau-de-toilette', 1004, N'24 - 250 g pkgs.', 19.5, N'410PjzqoC8L._AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nước hoa Nautica Blue mang hương thơm đại dương xanh mát, sảng khoái và tràn đầy năng lượng nam tính mạnh mẽ. Tông hương mát lạnh của cam chanh quyện cùng gỗ tuyết tùng và xạ hương, cực kỳ thích hợp cho các hoạt động thể thao ngoài trời và sử dụng trong mùa hè nóng bức.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1058, N'Vali London Fog Pegasus Brown Leather II', N'vali-london-fog-pegasus-brown-leather-ii', 1007, N'24 pieces', 13.25, N'91T2BjUkYmL._SL1500_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali kéo cao cấp London Fog mang phong cách cổ điển lịch lãm mang đậm chất hoàng gia Anh. Vali sử dụng chất liệu vải dệt họa tiết sang trọng kết hợp viền da cao cấp bền bỉ, khoang chứa rộng rãi chia ngăn thông minh cùng hệ thống bánh xe xoay 360 độ êm ái.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1059, N'Điện thoại Nokia 5310 XpressMusic', N'nokia-5310-xpressmusic', 1003, N'5 kg pkg.', 55, N'41sdBTtnUDL._SL500_AA300_.jpg', CAST(N'2009-08-01T00:00:00.000' AS DateTime), 0, 0, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1060, N'Điện thoại Nokia C7 Touch Sleek', N'nokia-c7-touch-sleek', 1003, N'15 - 300 g rounds', 34, N'41zxxR71G+L._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1061, N'Laptop MSI Prestige Business', N'msi-prestige-business-laptop', 1001, N'24 - 500 ml bottles', 28.5, N'41RxtSQOd2L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop MSI được thiết kế tối ưu cho hiệu năng đồ họa chuyên nghiệp và trải nghiệm gaming đỉnh cao. Máy sở hữu ngoại hình hầm hố cá tính, trang bị card đồ họa rời mạnh mẽ, hệ thống tản nhiệt Cooler Boost độc quyền cực mát cùng màn hình tần số quét cao siêu mượt, là trợ thủ đắc lực cho các game thủ và nhà sáng tạo nội dung.', N'SE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1062, N'Máy ảnh Nikon COOLPIX Autumn Red', N'nikon-coolpix-autumn-red', 1002, N'48 pies', 49.3, N'415cOCbeyML.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 1, N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1063, N'Laptop HP Essential Grey Slim', N'hp-essential-grey-slim', 1001, N'15 - 625 g jars', 43.9, N'41sd2DTD8EL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.', N'HP')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1064, N'Nước hoa Britney Spears Fantasy Pink', N'britney-spears-fantasy-pink', 1004, N'20 bags x 4 pieces', 33.25, N'419WCoqfamL._AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Nước hoa Britney Spears Fantasy mang phong cách ngọt ngào lãng mạn đầy mê hoặc như một câu chuyện cổ tích. Tông hương chủ đạo ngọt ngào dễ thương từ sô cô la trắng, bánh cupcake kết hợp tinh tế cùng hoa nhài quyến rũ và gỗ đàn hương, độ lưu hương cực tốt.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1065, N'Laptop MSI Dodgers Edition Gaming', N'msi-dodgers-edition-gaming', 1001, N'32 - 8 oz bottles', 21.05, N'41wHu2N4tVL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop MSI được thiết kế tối ưu cho hiệu năng đồ họa chuyên nghiệp và trải nghiệm gaming đỉnh cao. Máy sở hữu ngoại hình hầm hố cá tính, trang bị card đồ họa rời mạnh mẽ, hệ thống tản nhiệt Cooler Boost độc quyền cực mát cùng màn hình tần số quét cao siêu mượt, là trợ thủ đắc lực cho các game thủ và nhà sáng tạo nội dung.', N'SE')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1066, N'Laptop ASUS ROG Premium Gaming', N'asus-rog-premium-gaming', 1001, N'24 - 8 oz jars', 17, N'416OcTXFfeL._AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.', N'AC')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1067, N'Đồng hồ TAG Heuer Carrera Silver Steel', N'dong-ho-tag-heuer-carrera-silver-steel', 1000, N'24 - 12 oz bottles', 14, N'51GBNkHO6vL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1068, N'Máy ảnh Canon PowerShot SD1300 Silver', N'canon-powershot-sd1300-silver', 1002, N'10 boxes x 8 pieces', 12.5, N'Camera1.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1069, N'Điện thoại BlackBerry Torch Slider', N'blackberry-torch-slider', 1003, N'10 kg pkg.', 36, N'51+4d3VBFvL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1070, N'Đồng hồ Casio Pro Trek Tough Solar', N'casio-pro-trek-tough-solar', 1000, N'24 - 355 ml bottles', 15, N'51Lj5bxbNtL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Đồng hồ chuyên thám hiểm dã ngoại Casio Pro Trek tích hợp công nghệ Tough Solar tự động sạc bằng năng lượng mặt trời. Máy trang bị bộ ba cảm biến (Triple Sensor) gồm la bàn số, đo áp suất/độ cao và nhiệt độ vô cùng chính xác, là người bạn đồng hành hoàn hảo cho những chuyến leo núi, phượt dã ngoại chuyên nghiệp.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1071, N'Điện thoại Nokia N8 Touch Smartphone', N'nokia-n8-touch-smartphone', 1003, N'10 - 500 g pkgs.', 21.5, N'51l46qQB50L._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1072, N'Điện thoại Nokia Nseries Luxury Flip', N'nokia-nseries-luxury-flip', 1003, N'24 - 200 g pkgs.', 34.8, N'5195-l+nflL._AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 1, N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.', N'NK')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1073, N'Vali Samsonite Light Blue Hard-Shell', N'vali-samsonite-light-blue-hard-shell', 1007, N'24 - 150 g jars', 15, N'513UnnRfFML._SL1001_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1074, N'Giày bốt Black Fur Trimmed Winter', N'giay-bot-black-fur-trimmed-winter', 1006, N'5 kg pkg.', 10, N'816zGZv1ORL._SL1500_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1075, N'Đồng hồ Casio G-Shock Black', N'casio-g-shock-black', 1000, N'24 - 0.5 l bottles', 7.75, N'51uJ-pWfc9L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Đồng hồ Casio G-Shock huyền thoại với cấu trúc chống va đập, chống sốc và chống nước ở độ sâu 200m vượt trội. Thiết kế thể thao hầm hố, tích hợp các tính năng thông minh như giờ thế giới, bấm giờ thể thao, báo thức và đèn LED cực sáng, mang lại độ bền bỉ bất chấp thời gian.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1076, N'Đồng hồ Square Steel Chronograph Retro', N'dong-ho-square-steel-chronograph-retro', 1000, N'500 ml', 18, N'51vxcBS1sQL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 0, N'Đồng hồ thời trang cao cấp chính hãng, thiết kế sang trọng tinh tế tinh xảo đến từng chi tiết. Sử dụng bộ máy hoạt động chính xác bền bỉ, mặt kính chống xước tốt và khả năng chống nước cao, tôn lên phong cách thời thượng và đẳng cấp của người đeo.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1077, N'Laptop HP Compaq Vintage Edition', N'hp-compaq-vintage-edition', 1001, N'12 boxes', 13, N'1009.gif', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 1, N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.', N'HP')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1081, N'Đồng hồ Casio G-Shock Analog-Digital', N'casio-g-shock-analog-digital', 1000, N'10 boxes x 20 bags', 19, N'51y46IslQkL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 4, N'Đồng hồ Casio G-Shock huyền thoại với cấu trúc chống va đập, chống sốc và chống nước ở độ sâu 200m vượt trội. Thiết kế thể thao hầm hố, tích hợp các tính năng thông minh như giờ thế giới, bấm giờ thể thao, báo thức và đèn LED cực sáng, mang lại độ bền bỉ bất chấp thời gian.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1083, N'Nhẫn Claddagh Blue Heart Gem', N'nhan-claddagh-blue-heart-gem', 1005, N'18 - 500 g pkgs.', 97, N'41GVLtgNngL._SL500_AA300_.jpg', CAST(N'2009-07-31T07:00:00.000' AS DateTime), 0, 0, N'Nhẫn Claddagh truyền thống của Ireland với biểu tượng hai bàn tay nâng niu trái tim đội vương miện, tượng trưng cho tình bạn chân thành, tình yêu nồng cháy và lòng trung thành tuyệt đối. Chế tác tinh xảo từ bạc 925 cao cấp.', N'SM')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1084, N'Đồng hồ Casio Pro Trek Pathfinder', N'casio-pro-trek-pathfinder', 1000, N'10 boxes x 20 bags', 19, N'51Z9tfgl4aL._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 1, N'Đồng hồ chuyên thám hiểm dã ngoại Casio Pro Trek tích hợp công nghệ Tough Solar tự động sạc bằng năng lượng mặt trời. Máy trang bị bộ ba cảm biến (Triple Sensor) gồm la bàn số, đo áp suất/độ cao và nhiệt độ vô cùng chính xác, là người bạn đồng hành hoàn hảo cho những chuyến leo núi, phượt dã ngoại chuyên nghiệp.', N'MO')
    INSERT [dbo].[HangHoa] ([MaHH], [TenHH], [TenAlias], [MaLoai], [MoTaDonVi], [DonGia], [Hinh], [NgaySX], [GiamGia], [SoLanXem], [MoTa], [MaNCC]) VALUES (1085, N'Laptop ASUS Zenbook Premium Ultra', N'asus-zenbook-premium-ultra', 1001, N'12 - 550 ml bottles', 1001, N'31EPGSm2s1L._SL500_AA300_.jpg', CAST(N'2009-08-01T07:00:00.000' AS DateTime), 0, 491, N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.', N'AC')
    SET IDENTITY_INSERT [dbo].[HangHoa] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[HoaDon])
BEGIN
    SET IDENTITY_INSERT [dbo].[HoaDon] ON
    SET IDENTITY_INSERT [dbo].[HoaDon] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[KhachHang] WHERE [MaKH] = N'admin')
BEGIN
    INSERT [dbo].[KhachHang] ([MaKH], [MatKhau], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [DienThoai], [Email], [Hinh], [HieuLuc], [VaiTro], [RandomKey]) VALUES (N'admin', N'33c2264667566f6ccf60794b2a1f1a27', N'Admin', 1, CAST(N'2000-01-01T00:00:00.000' AS DateTime), N'Admin Address', N'0999999999', N'admin@quamonhai.com', N'[API]:Admin', 1, 1, N'abcde')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[KhachHang] WHERE [MaKH] <> N'admin')
BEGIN
    INSERT [dbo].[KhachHang] ([MaKH], [MatKhau], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [DienThoai], [Email], [Hinh], [HieuLuc], [VaiTro], [RandomKey]) VALUES (N'hello', N'1', N'nnghiem@yahoo.com', 0, CAST(N'2011-01-12T07:00:00.000' AS DateTime), N'aaa', N'aaa', N'hello@abc.com', N'man.gif', 0, 2, NULL)
    INSERT [dbo].[KhachHang] ([MaKH], [MatKhau], [HoTen], [GioiTinh], [NgaySinh], [DiaChi], [DienThoai], [Email], [Hinh], [HieuLuc], [VaiTro], [RandomKey]) VALUES (N'KH0002', N'a0cd8c2ab5e0bd6f61ba4ffa626f5c3e', N'Lê Văn Thê', 1, CAST(N'2000-11-11T00:00:00.000' AS DateTime), N'105 Bà Huyện Thanh Quan', N'0123456789', N'aspnhatnghe@gmail.com', NULL, 0, 0, N'kt2[v')
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[Loai])
BEGIN
    SET IDENTITY_INSERT [dbo].[Loai] ON
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1000, N'Đồng hồ', N'dong-ho', N'Các loại đồng hồ thời trang, đồng hồ thông minh và đồng hồ cao cấp chính hãng.', N'Best.png')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1001, N'Laptop', N'lap-top', N'Máy tính xách tay cấu hình cao, laptop văn phòng, laptop gaming thiết kế hiện đại.', N'Certificate.png')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1002, N'Máy ảnh', N'may-anh', N'Máy ảnh chuyên nghiệp, máy ảnh kỹ thuật số, ống kính và phụ kiện chụp ảnh.', N'')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1003, N'Điện thoại', N'dien-thoai', N'Điện thoại di động thông minh, máy tính bảng và các thiết bị liên lạc hiện đại.', N'Bell.png')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1004, N'Nước hoa', N'nuoc-hoa', N'Nước hoa cao cấp, nước hoa quyến rũ dành cho nam và nữ chính hãng.', N'Favourites.png')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1005, N'Trang sức', N'trang-suc', N'Trang sức cao cấp, nhẫn, vòng cổ, khuyên tai đính đá quý sang trọng.', N'Dice.png')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1006, N'Giày', N'giay', N'Giày bốt thời trang, giày thể thao, giày da nam nữ chất lượng cao.', N'')
    INSERT [dbo].[Loai] ([MaLoai], [TenLoai], [TenLoaiAlias], [MoTa], [Hinh]) VALUES (1007, N'Vali', N'vali', N'Vali du lịch chống xước, balo, túi xách thời trang cao cấp.', N'Microsoft.png')
    SET IDENTITY_INSERT [dbo].[Loai] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap])
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'AP', N'Apple', N'apple.gif', N'Petter Pike', N'pike@yahoo.com', N'0987345876', N'765 Hello, Califonia, United States', N'Thiết bị di động, sản phẩm công nghệ cao cấp của Apple.')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'MO', N'Motorola', N'motorola.gif', N'John David', N'john@gmail.com', N'0918456987', N'22 Rose, Messachuset, United States', N'Công ty viễn thông và thiết bị di động Motorola.')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'NK', N'Nokia', N'Nokia.gif', N'Okawa', N'okawa@gmail.com', N'0913745789', N'123 Revenue, Tokyo, Japan', N'Thương hiệu thiết bị di động và viễn thông Nokia.')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SM', N'Seamen', N'semen.gif', N'David Brown', N'brown@gmail.com', N'0987456876', N'23 New World, Texas, United Kindom', N'Công ty thiết bị kỹ thuật số và công nghệ.')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SS', N'Samsung', N'samsung.gif', N'LeeSongChai', N'lee@yahoo.com', N'0913745789', N'456 Romario, Seaul, Korea', N'Sản phẩm điện tử, công nghệ cao cấp của Samsung.')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'DE', N'Dell Inc.', N'dell-logo.jpg', N'Michael Dell', N'contact@dell.com', N'0987111222', N'One Dell Way, Round Rock, Texas, US', N'Dell Premium Laptops and Computers')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'HP', N'HP Inc.', N'hp-logo.jpg', N'Enrique Lores', N'contact@hp.com', N'0987333444', N'Palo Alto, California, US', N'HP Invent Laptops and Digital Devices')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'AC', N'Acer Inc.', N'Acer_logo-300x300.gif', N'Jason Chen', N'contact@acer.com', N'0987555666', N'New Taipei City, Taiwan', N'Acer Explore Beyond Limits Laptops')
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) VALUES (N'SE', N'Sony Ericsson', N'sonny-ericsson.jpg', N'Sony CEO', N'contact@sony.com', N'0987777888', N'Tokyo, Japan', N'Sony Mobile and Electronics Devices')
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhanVien])
BEGIN
    INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [Email], [MatKhau]) VALUES (N'lvc', N'Lê Văn C', N'lvc@gmail.com', N'123')
    INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [Email], [MatKhau]) VALUES (N'nva', N'Trần Văn A', N'tva@gmail.com', N'123')
    INSERT [dbo].[NhanVien] ([MaNV], [HoTen], [Email], [MatKhau]) VALUES (N'nvb', N'Nguyễn Văn B', N'nvb@gmail.com', N'123')
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[PhanCong])
BEGIN
    SET IDENTITY_INSERT [dbo].[PhanCong] ON
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (1, N'lvc', N'BGD', CAST(N'2017-12-17T10:10:06.877' AS DateTime), 0)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (2, N'nva', N'BGD', CAST(N'2017-11-11T00:00:00.000' AS DateTime), 0)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (3, N'lvc', N'BGD', CAST(N'2017-12-17T10:15:51.303' AS DateTime), 1)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (4, N'nva', N'BGD', CAST(N'2017-12-17T10:15:51.333' AS DateTime), 1)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (5, N'nva', N'PKT', CAST(N'2017-12-17T10:16:19.203' AS DateTime), 0)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (6, N'nvb', N'PKT', CAST(N'2017-12-17T10:16:19.213' AS DateTime), 0)
    INSERT [dbo].[PhanCong] ([MaPC], [MaNV], [MaPB], [NgayPC], [HieuLuc]) VALUES (7, N'nvb', N'PKT', CAST(N'2017-12-17T10:16:39.180' AS DateTime), 1)
    SET IDENTITY_INSERT [dbo].[PhanCong] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[PhanQuyen])
BEGIN
    SET IDENTITY_INSERT [dbo].[PhanQuyen] ON
    INSERT [dbo].[PhanQuyen] ([MaPQ], [MaPB], [MaTrang], [Them], [Sua], [Xoa], [Xem]) VALUES (16, N'BGD', 1, 0, 0, 0, 0)
    INSERT [dbo].[PhanQuyen] ([MaPQ], [MaPB], [MaTrang], [Them], [Sua], [Xoa], [Xem]) VALUES (17, N'BGD', 2, 0, 0, 0, 0)
    INSERT [dbo].[PhanQuyen] ([MaPQ], [MaPB], [MaTrang], [Them], [Sua], [Xoa], [Xem]) VALUES (18, N'BGD', 3, 0, 1, 1, 1)
    SET IDENTITY_INSERT [dbo].[PhanQuyen] OFF
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[PhongBan])
BEGIN
    INSERT [dbo].[PhongBan] ([MaPB], [TenPB], [ThongTin]) VALUES (N'BGD', N'Ban Giám Đốc', NULL)
    INSERT [dbo].[PhongBan] ([MaPB], [TenPB], [ThongTin]) VALUES (N'PKD', N'Phòng kinh doanh', NULL)
    INSERT [dbo].[PhongBan] ([MaPB], [TenPB], [ThongTin]) VALUES (N'PKT', N'Phòng Kỹ thuật', NULL)
    INSERT [dbo].[PhongBan] ([MaPB], [TenPB], [ThongTin]) VALUES (N'PKTo', N'Phòng Kế toán', NULL)
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[TrangThai])
BEGIN
    INSERT [dbo].[TrangThai] ([MaTrangThai], [TenTrangThai], [MoTa]) VALUES (-1, N'Khách hàng hủy đơn hàng', NULL)
    INSERT [dbo].[TrangThai] ([MaTrangThai], [TenTrangThai], [MoTa]) VALUES (0, N'Mới đặt hàng', NULL)
    INSERT [dbo].[TrangThai] ([MaTrangThai], [TenTrangThai], [MoTa]) VALUES (1, N'Đã thanh toán', NULL)
    INSERT [dbo].[TrangThai] ([MaTrangThai], [TenTrangThai], [MoTa]) VALUES (2, N'Chờ giao hàng', NULL)
    INSERT [dbo].[TrangThai] ([MaTrangThai], [TenTrangThai], [MoTa]) VALUES (3, N'Đã giao hàng', NULL)
END

GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[TrangWeb])
BEGIN
    SET IDENTITY_INSERT [dbo].[TrangWeb] ON
    INSERT [dbo].[TrangWeb] ([MaTrang], [TenTrang], [URL]) VALUES (1, N'Trang chủ Admin', N'Default.aspx')
    INSERT [dbo].[TrangWeb] ([MaTrang], [TenTrang], [URL]) VALUES (2, N'Quản lý Đơn hàng', N'QLDonHang.aspx')
    INSERT [dbo].[TrangWeb] ([MaTrang], [TenTrang], [URL]) VALUES (3, N'Quản lý Hàng hóa', N'QLHangHoa.aspx')
    SET IDENTITY_INSERT [dbo].[TrangWeb] OFF
END

GO

-- Cập nhật số lượng chuẩn theo hình ảnh
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Swatch Gold Chronograph', [TenAlias] = N'swatch-gold-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1001;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Tissot T-Touch Silver', [TenAlias] = N'tissot-t-touch-silver', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1002;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Premium Minimalist', [TenAlias] = N'hp-premium-minimalist-laptop', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 25 WHERE [MaHH] = 1003;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Core i5 Standard', [TenAlias] = N'asus-core-i5-standard', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 95 WHERE [MaHH] = 1004;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Inspiron Kayak Edition', [TenAlias] = N'dell-inspiron-kayak-edition', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1005;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Vivobook Slim', [TenAlias] = N'asus-vivobook-slim', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 105 WHERE [MaHH] = 1006;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt tuyết Black Winter Snow', [TenAlias] = N'giay-bot-tuyet-black-winter-snow', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1007;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Pavilion Silver Slim', [TenAlias] = N'hp-pavilion-silver-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 115 WHERE [MaHH] = 1008;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn vàng đính đá Opal & Diamonds', [TenAlias] = N'nhan-vang-dinh-da-opal-diamonds', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1009;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo Osprey Green Rolling', [TenAlias] = N'vali-balo-osprey-green-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1010;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Bold Classic', [TenAlias] = N'blackberry-bold-classic', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 65 WHERE [MaHH] = 1011;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại LG Cookie KP500 Stylus', [TenAlias] = N'lg-cookie-kp500-stylus', [MaLoai] = 1003, [MaNCC] = N'SE', [SoLuong] = 135 WHERE [MaHH] = 1012;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Black Rolling', [TenAlias] = N'vali-samsonite-classic-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1013;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Beige Winter Boots', [TenAlias] = N'giay-bot-sorel-beige-winter-boots', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1014;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Toshiba Dynabook Professional', [TenAlias] = N'toshiba-dynabook-professional', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 85 WHERE [MaHH] = 1015;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D7000 DSLR Professional', [TenAlias] = N'nikon-d7000-dslr-professional', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1016;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc Celtic Knot Ring', [TenAlias] = N'nhan-bac-celtic-knot-ring', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1017;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Blue Rolling', [TenAlias] = N'vali-samsonite-classic-blue-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1018;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Blue', [TenAlias] = N'canon-powershot-sd1300-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1019;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Silver Pocket', [TenAlias] = N'nikon-coolpix-silver-pocket', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1020;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Lime Green', [TenAlias] = N'nikon-coolpix-lime-green', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1021;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Guess for Women EDP Pink', [TenAlias] = N'guess-for-women-edp-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1022;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Dolce & Gabbana Light Blue', [TenAlias] = N'dolce-gabbana-light-blue', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1023;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Promaster', [TenAlias] = N'citizen-eco-drive-promaster', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1024;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Royal Blue', [TenAlias] = N'nikon-coolpix-royal-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1025;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix Bridge Camera', [TenAlias] = N'fujifilm-finepix-bridge-camera', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1026;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot S95 Premium', [TenAlias] = N'canon-powershot-s95-premium', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1027;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Waterproof Active', [TenAlias] = N'giay-bot-sorel-waterproof-active', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1028;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá White Opal Stone', [TenAlias] = N'nhan-bac-dinh-da-white-opal-stone', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1029;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Grey Rolling', [TenAlias] = N'vali-balo-high-sierra-grey-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1030;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Curve AT&T', [TenAlias] = N'blackberry-curve-att', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1031;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Silver', [TenAlias] = N'nokia-e71-qwerty-silver', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1032;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Metallic Grey', [TenAlias] = N'nokia-e71-qwerty-metallic-grey', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1033;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Michael Kors Rose Gold', [TenAlias] = N'michael-kors-rose-gold', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1034;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Aquaracer Special', [TenAlias] = N'dong-ho-tag-heuer-aquaracer-special', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1035;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Black Duffel', [TenAlias] = N'vali-balo-high-sierra-black-duffel', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1036;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Burgundy Rolling', [TenAlias] = N'vali-samsonite-burgundy-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1037;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Luminox Navy SEAL Sports', [TenAlias] = N'dong-ho-luminox-navy-seal-sports', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1038;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Chronograph', [TenAlias] = N'dong-ho-tag-heuer-carrera-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1039;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Essential Black Rolling', [TenAlias] = N'vali-samsonite-essential-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1040;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Purple Rolling', [TenAlias] = N'vali-samsonite-purple-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1041;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Eau de Parfum', [TenAlias] = N'paris-hilton-eau-de-parfum', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1042;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Chandler', [TenAlias] = N'citizen-eco-drive-chandler', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1043;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Latitude Business Slim', [TenAlias] = N'dell-latitude-business-slim', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1044;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Red Premium Rolling', [TenAlias] = N'vali-samsonite-red-premium-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1045;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather', [TenAlias] = N'vali-london-fog-pegasus-brown-leather', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1046;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Panasonic LUMIX Red Compact', [TenAlias] = N'panasonic-lumix-red-compact', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1047;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix J40 Black', [TenAlias] = N'fujifilm-finepix-j40-black', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1048;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SX130 IS', [TenAlias] = N'canon-powershot-sx130-is', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1049;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D3100 DSLR Starter', [TenAlias] = N'nikon-d3100-dslr-starter', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1050;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt UGG Classic Pink Button', [TenAlias] = N'giay-bot-ugg-classic-pink-button', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1051;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Heiress Perfume', [TenAlias] = N'paris-hilton-heiress-perfume', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1052;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Solitaire Diamond', [TenAlias] = N'nhan-bac-dinh-da-solitaire-diamond', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1053;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Moonstone Gem', [TenAlias] = N'nhan-bac-dinh-da-moonstone-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1054;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Orange Amber', [TenAlias] = N'nhan-bac-dinh-da-orange-amber', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1055;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Calvin Klein Eternity for Men', [TenAlias] = N'calvin-klein-eternity-for-men', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1056;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Nautica Blue Eau de Toilette', [TenAlias] = N'nautica-blue-eau-de-toilette', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1057;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather II', [TenAlias] = N'vali-london-fog-pegasus-brown-leather-ii', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1058;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia 5310 XpressMusic', [TenAlias] = N'nokia-5310-xpressmusic', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1059;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia C7 Touch Sleek', [TenAlias] = N'nokia-c7-touch-sleek', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 115 WHERE [MaHH] = 1060;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Prestige Business', [TenAlias] = N'msi-prestige-business-laptop', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 55 WHERE [MaHH] = 1061;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Autumn Red', [TenAlias] = N'nikon-coolpix-autumn-red', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1062;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Essential Grey Slim', [TenAlias] = N'hp-essential-grey-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 65 WHERE [MaHH] = 1063;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Britney Spears Fantasy Pink', [TenAlias] = N'britney-spears-fantasy-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1064;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Dodgers Edition Gaming', [TenAlias] = N'msi-dodgers-edition-gaming', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 75 WHERE [MaHH] = 1065;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS ROG Premium Gaming', [TenAlias] = N'asus-rog-premium-gaming', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 15 WHERE [MaHH] = 1066;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Silver Steel', [TenAlias] = N'dong-ho-tag-heuer-carrera-silver-steel', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1067;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Silver', [TenAlias] = N'canon-powershot-sd1300-silver', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1068;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Torch Slider', [TenAlias] = N'blackberry-torch-slider', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 95 WHERE [MaHH] = 1069;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Tough Solar', [TenAlias] = N'casio-pro-trek-tough-solar', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1070;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia N8 Touch Smartphone', [TenAlias] = N'nokia-n8-touch-smartphone', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1071;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia Nseries Luxury Flip', [TenAlias] = N'nokia-nseries-luxury-flip', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1072;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Light Blue Hard-Shell', [TenAlias] = N'vali-samsonite-light-blue-hard-shell', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1073;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Black Fur Trimmed Winter', [TenAlias] = N'giay-bot-black-fur-trimmed-winter', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1074;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Black', [TenAlias] = N'casio-g-shock-black', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 125 WHERE [MaHH] = 1075;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Square Steel Chronograph Retro', [TenAlias] = N'dong-ho-square-steel-chronograph-retro', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1076;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Compaq Vintage Edition', [TenAlias] = N'hp-compaq-vintage-edition', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 135 WHERE [MaHH] = 1077;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Analog-Digital', [TenAlias] = N'casio-g-shock-analog-digital', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 25 WHERE [MaHH] = 1081;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn Claddagh Blue Heart Gem', [TenAlias] = N'nhan-claddagh-blue-heart-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1083;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Pathfinder', [TenAlias] = N'casio-pro-trek-pathfinder', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 105 WHERE [MaHH] = 1084;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Zenbook Premium Ultra', [TenAlias] = N'asus-zenbook-premium-ultra', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 45 WHERE [MaHH] = 1085;

-- ========================================== 
-- 5. FOREIGN KEY CONSTRAINTS 
-- ========================================== 

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_BanBe_HangHoa')
BEGIN
    ALTER TABLE [dbo].[BanBe]  WITH CHECK ADD  CONSTRAINT [FK_BanBe_HangHoa] FOREIGN KEY([MaHh])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ALTER TABLE [dbo].[BanBe] CHECK CONSTRAINT [FK_BanBe_HangHoa]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_BanBe_KhachHang')
BEGIN
    ALTER TABLE [dbo].[BanBe]  WITH CHECK ADD  CONSTRAINT [FK_BanBe_KhachHang] FOREIGN KEY([MaKh])
    REFERENCES [dbo].[KhachHang] ([MaKH])
    ALTER TABLE [dbo].[BanBe] CHECK CONSTRAINT [FK_BanBe_KhachHang]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_QuangBa_HangHoa')
BEGIN
    ALTER TABLE [dbo].[BanBe]  WITH CHECK ADD  CONSTRAINT [FK_QuangBa_HangHoa] FOREIGN KEY([MaHh])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[BanBe] CHECK CONSTRAINT [FK_QuangBa_HangHoa]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_BinhLuan_HangHoa')
BEGIN
    ALTER TABLE [dbo].[BinhLuan]  WITH CHECK ADD  CONSTRAINT [FK_BinhLuan_HangHoa] FOREIGN KEY([MaHH])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ON DELETE CASCADE
    ALTER TABLE [dbo].[BinhLuan] CHECK CONSTRAINT [FK_BinhLuan_HangHoa]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_BinhLuan_KhachHang')
BEGIN
    ALTER TABLE [dbo].[BinhLuan]  WITH CHECK ADD  CONSTRAINT [FK_BinhLuan_KhachHang] FOREIGN KEY([MaKH])
    REFERENCES [dbo].[KhachHang] ([MaKH])
    ON DELETE CASCADE
    ALTER TABLE [dbo].[BinhLuan] CHECK CONSTRAINT [FK_BinhLuan_KhachHang]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_ChiTietHD_GiamGia')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHD_GiamGia] FOREIGN KEY([MaGG])
    REFERENCES [dbo].[GiamGia] ([MaGG])
    ON DELETE SET NULL
    ALTER TABLE [dbo].[ChiTietHD] CHECK CONSTRAINT [FK_ChiTietHD_GiamGia]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_OrderDetails_Orders')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([MaHD])
    REFERENCES [dbo].[HoaDon] ([MaHD])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[ChiTietHD] CHECK CONSTRAINT [FK_OrderDetails_Orders]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_OrderDetails_Products')
BEGIN
    ALTER TABLE [dbo].[ChiTietHD]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([MaHH])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ON UPDATE CASCADE
    ALTER TABLE [dbo].[ChiTietHD] CHECK CONSTRAINT [FK_OrderDetails_Products]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_ChuDe_NhanVien')
BEGIN
    ALTER TABLE [dbo].[ChuDe]  WITH CHECK ADD  CONSTRAINT [FK_ChuDe_NhanVien] FOREIGN KEY([MaNV])
    REFERENCES [dbo].[NhanVien] ([MaNV])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[ChuDe] CHECK CONSTRAINT [FK_ChuDe_NhanVien]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_GioHang_HangHoa')
BEGIN
    ALTER TABLE [dbo].[GioHang]  WITH CHECK ADD  CONSTRAINT [FK_GioHang_HangHoa] FOREIGN KEY([MaHh])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ALTER TABLE [dbo].[GioHang] CHECK CONSTRAINT [FK_GioHang_HangHoa]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_GioHang_KhachHang')
BEGIN
    ALTER TABLE [dbo].[GioHang]  WITH CHECK ADD  CONSTRAINT [FK_GioHang_KhachHang] FOREIGN KEY([MaKh])
    REFERENCES [dbo].[KhachHang] ([MaKH])
    ALTER TABLE [dbo].[GioHang] CHECK CONSTRAINT [FK_GioHang_KhachHang]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_GopY_ChuDe')
BEGIN
    ALTER TABLE [dbo].[GopY]  WITH CHECK ADD  CONSTRAINT [FK_GopY_ChuDe] FOREIGN KEY([MaCD])
    REFERENCES [dbo].[ChuDe] ([MaCD])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[GopY] CHECK CONSTRAINT [FK_GopY_ChuDe]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_Products_Categories')
BEGIN
    ALTER TABLE [dbo].[HangHoa]  WITH CHECK ADD  CONSTRAINT [FK_Products_Categories] FOREIGN KEY([MaLoai])
    REFERENCES [dbo].[Loai] ([MaLoai])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[HangHoa] CHECK CONSTRAINT [FK_Products_Categories]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_Products_Suppliers')
BEGIN
    ALTER TABLE [dbo].[HangHoa]  WITH CHECK ADD  CONSTRAINT [FK_Products_Suppliers] FOREIGN KEY([MaNCC])
    REFERENCES [dbo].[NhaCungCap] ([MaNCC])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[HangHoa] CHECK CONSTRAINT [FK_Products_Suppliers]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_HoaDon_NhanVien')
BEGIN
    ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_NhanVien] FOREIGN KEY([MaNV])
    REFERENCES [dbo].[NhanVien] ([MaNV])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_NhanVien]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_HoaDon_TrangThai')
BEGIN
    ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_TrangThai] FOREIGN KEY([MaTrangThai])
    REFERENCES [dbo].[TrangThai] ([MaTrangThai])
    ON UPDATE CASCADE
    ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_TrangThai]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_Orders_Customers')
BEGIN
    ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([MaKH])
    REFERENCES [dbo].[KhachHang] ([MaKH])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_Orders_Customers]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_HoiDap_NhanVien')
BEGIN
    ALTER TABLE [dbo].[HoiDap]  WITH CHECK ADD  CONSTRAINT [FK_HoiDap_NhanVien] FOREIGN KEY([MaNV])
    REFERENCES [dbo].[NhanVien] ([MaNV])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[HoiDap] CHECK CONSTRAINT [FK_HoiDap_NhanVien]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_PhanCong_NhanVien')
BEGIN
    ALTER TABLE [dbo].[PhanCong]  WITH CHECK ADD  CONSTRAINT [FK_PhanCong_NhanVien] FOREIGN KEY([MaNV])
    REFERENCES [dbo].[NhanVien] ([MaNV])
    ALTER TABLE [dbo].[PhanCong] CHECK CONSTRAINT [FK_PhanCong_NhanVien]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_PhanCong_PhongBan')
BEGIN
    ALTER TABLE [dbo].[PhanCong]  WITH CHECK ADD  CONSTRAINT [FK_PhanCong_PhongBan] FOREIGN KEY([MaPB])
    REFERENCES [dbo].[PhongBan] ([MaPB])
    ALTER TABLE [dbo].[PhanCong] CHECK CONSTRAINT [FK_PhanCong_PhongBan]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_PhanQuyen_PhongBan')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen]  WITH CHECK ADD  CONSTRAINT [FK_PhanQuyen_PhongBan] FOREIGN KEY([MaPB])
    REFERENCES [dbo].[PhongBan] ([MaPB])
    ALTER TABLE [dbo].[PhanQuyen] CHECK CONSTRAINT [FK_PhanQuyen_PhongBan]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_PhanQuyen_TrangWeb')
BEGIN
    ALTER TABLE [dbo].[PhanQuyen]  WITH CHECK ADD  CONSTRAINT [FK_PhanQuyen_TrangWeb] FOREIGN KEY([MaTrang])
    REFERENCES [dbo].[TrangWeb] ([MaTrang])
    ALTER TABLE [dbo].[PhanQuyen] CHECK CONSTRAINT [FK_PhanQuyen_TrangWeb]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_Favorites_Customers')
BEGIN
    ALTER TABLE [dbo].[YeuThich]  WITH CHECK ADD  CONSTRAINT [FK_Favorites_Customers] FOREIGN KEY([MaKH])
    REFERENCES [dbo].[KhachHang] ([MaKH])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[YeuThich] CHECK CONSTRAINT [FK_Favorites_Customers]
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_YeuThich_HangHoa')
BEGIN
    ALTER TABLE [dbo].[YeuThich]  WITH CHECK ADD  CONSTRAINT [FK_YeuThich_HangHoa] FOREIGN KEY([MaHH])
    REFERENCES [dbo].[HangHoa] ([MaHH])
    ON UPDATE CASCADE
    ON DELETE CASCADE
    ALTER TABLE [dbo].[YeuThich] CHECK CONSTRAINT [FK_YeuThich_HangHoa]
END
GO

-- ========================================== 
-- 6. CHECK CONSTRAINTS 
-- ========================================== 

IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = N'CK_GiamGia_PhanTramGiam_0_100')
BEGIN
    ALTER TABLE [dbo].[GiamGia]  WITH CHECK ADD  CONSTRAINT [CK_GiamGia_PhanTramGiam_0_100] CHECK  (([PhanTramGiam]>=(0) AND [PhanTramGiam]<=(100)))
    ALTER TABLE [dbo].[GiamGia] CHECK CONSTRAINT [CK_GiamGia_PhanTramGiam_0_100]
END
GO

IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE name = N'CK_HangHoa_GiamGia_0_100')
BEGIN
    ALTER TABLE [dbo].[HangHoa]  WITH CHECK ADD  CONSTRAINT [CK_HangHoa_GiamGia_0_100] CHECK  (([GiamGia]>=(0) AND [GiamGia]<=(100)))
    ALTER TABLE [dbo].[HangHoa] CHECK CONSTRAINT [CK_HangHoa_GiamGia_0_100]
END
GO

PRINT '============================================================';
PRINT ' HShopScript_Full.sql chay thanh cong!';
PRINT ' Database da san sang su dung.';

-- ==========================================================================
-- UpdateHangHoa.sql - Consolidated updates and additions to products/vendors
-- ==========================================================================
USE [Hshop2023]
GO

-- 1. THÊM CỘT SOLUONG VÀO BẢNG HANGHOA NẾU CHƯA CÓ
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[HangHoa]') AND name = N'SoLuong')
BEGIN
    ALTER TABLE [dbo].[HangHoa] ADD [SoLuong] INT NOT NULL DEFAULT 100;
END
GO

-- 2. THÊM NHÀ CUNG CẤP MỚI NẾU CHƯA TỒN TẠI
IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'DE')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'DE', N'Dell Inc.', N'dell-logo.jpg', N'Michael Dell', N'contact@dell.com', N'0987111222', N'One Dell Way, Round Rock, Texas, US', N'Dell Premium Laptops and Computers')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'HP')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'HP', N'HP Inc.', N'hp-logo.jpg', N'Enrique Lores', N'contact@hp.com', N'0987333444', N'Palo Alto, California, US', N'HP Invent Laptops and Digital Devices')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'AC')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'AC', N'Acer Inc.', N'Acer_logo-300x300.gif', N'Jason Chen', N'contact@acer.com', N'0987555666', N'New Taipei City, Taiwan', N'Acer Explore Beyond Limits Laptops')
END

IF NOT EXISTS (SELECT 1 FROM [dbo].[NhaCungCap] WHERE [MaNCC] = N'SE')
BEGIN
    INSERT [dbo].[NhaCungCap] ([MaNCC], [TenCongTy], [Logo], [NguoiLienLac], [Email], [DienThoai], [DiaChi], [MoTa]) 
    VALUES (N'SE', N'Sony Ericsson', N'sonny-ericsson.jpg', N'Sony CEO', N'contact@sony.com', N'0987777888', N'Tokyo, Japan', N'Sony Mobile and Electronics Devices')
END
GO

-- 3. CẬP NHẬT THÔNG TIN HÀNG HÓA VÀ SỐ LƯỢNG CHUẨN THEO ẢNH
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Swatch Gold Chronograph', [TenAlias] = N'swatch-gold-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1001;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Tissot T-Touch Silver', [TenAlias] = N'tissot-t-touch-silver', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1002;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Premium Minimalist', [TenAlias] = N'hp-premium-minimalist-laptop', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 25 WHERE [MaHH] = 1003;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Core i5 Standard', [TenAlias] = N'asus-core-i5-standard', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 95 WHERE [MaHH] = 1004;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Inspiron Kayak Edition', [TenAlias] = N'dell-inspiron-kayak-edition', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1005;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Vivobook Slim', [TenAlias] = N'asus-vivobook-slim', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 105 WHERE [MaHH] = 1006;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt tuyết Black Winter Snow', [TenAlias] = N'giay-bot-tuyet-black-winter-snow', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1007;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Pavilion Silver Slim', [TenAlias] = N'hp-pavilion-silver-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 115 WHERE [MaHH] = 1008;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn vàng đính đá Opal & Diamonds', [TenAlias] = N'nhan-vang-dinh-da-opal-diamonds', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1009;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo Osprey Green Rolling', [TenAlias] = N'vali-balo-osprey-green-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1010;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Bold Classic', [TenAlias] = N'blackberry-bold-classic', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 65 WHERE [MaHH] = 1011;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại LG Cookie KP500 Stylus', [TenAlias] = N'lg-cookie-kp500-stylus', [MaLoai] = 1003, [MaNCC] = N'SE', [SoLuong] = 135 WHERE [MaHH] = 1012;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Black Rolling', [TenAlias] = N'vali-samsonite-classic-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1013;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Beige Winter Boots', [TenAlias] = N'giay-bot-sorel-beige-winter-boots', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1014;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Toshiba Dynabook Professional', [TenAlias] = N'toshiba-dynabook-professional', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 85 WHERE [MaHH] = 1015;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D7000 DSLR Professional', [TenAlias] = N'nikon-d7000-dslr-professional', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1016;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc Celtic Knot Ring', [TenAlias] = N'nhan-bac-celtic-knot-ring', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1017;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Classic Blue Rolling', [TenAlias] = N'vali-samsonite-classic-blue-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1018;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Blue', [TenAlias] = N'canon-powershot-sd1300-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1019;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Silver Pocket', [TenAlias] = N'nikon-coolpix-silver-pocket', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1020;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Lime Green', [TenAlias] = N'nikon-coolpix-lime-green', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1021;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Guess for Women EDP Pink', [TenAlias] = N'guess-for-women-edp-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1022;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Dolce & Gabbana Light Blue', [TenAlias] = N'dolce-gabbana-light-blue', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1023;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Promaster', [TenAlias] = N'citizen-eco-drive-promaster', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1024;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Royal Blue', [TenAlias] = N'nikon-coolpix-royal-blue', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1025;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix Bridge Camera', [TenAlias] = N'fujifilm-finepix-bridge-camera', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1026;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot S95 Premium', [TenAlias] = N'canon-powershot-s95-premium', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1027;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Sorel Waterproof Active', [TenAlias] = N'giay-bot-sorel-waterproof-active', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1028;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá White Opal Stone', [TenAlias] = N'nhan-bac-dinh-da-white-opal-stone', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1029;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Grey Rolling', [TenAlias] = N'vali-balo-high-sierra-grey-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1030;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Curve AT&T', [TenAlias] = N'blackberry-curve-att', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1031;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Silver', [TenAlias] = N'nokia-e71-qwerty-silver', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1032;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia E71 QWERTY Metallic Grey', [TenAlias] = N'nokia-e71-qwerty-metallic-grey', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1033;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Michael Kors Rose Gold', [TenAlias] = N'michael-kors-rose-gold', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1034;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Aquaracer Special', [TenAlias] = N'dong-ho-tag-heuer-aquaracer-special', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1035;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali balo High Sierra Black Duffel', [TenAlias] = N'vali-balo-high-sierra-black-duffel', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1036;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Burgundy Rolling', [TenAlias] = N'vali-samsonite-burgundy-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1037;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Luminox Navy SEAL Sports', [TenAlias] = N'dong-ho-luminox-navy-seal-sports', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1038;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Chronograph', [TenAlias] = N'dong-ho-tag-heuer-carrera-chronograph', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1039;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Essential Black Rolling', [TenAlias] = N'vali-samsonite-essential-black-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1040;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Purple Rolling', [TenAlias] = N'vali-samsonite-purple-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1041;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Eau de Parfum', [TenAlias] = N'paris-hilton-eau-de-parfum', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1042;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Citizen Eco-Drive Chandler', [TenAlias] = N'citizen-eco-drive-chandler', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1043;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop Dell Latitude Business Slim', [TenAlias] = N'dell-latitude-business-slim', [MaLoai] = 1001, [MaNCC] = N'DE', [SoLuong] = 35 WHERE [MaHH] = 1044;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Red Premium Rolling', [TenAlias] = N'vali-samsonite-red-premium-rolling', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1045;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather', [TenAlias] = N'vali-london-fog-pegasus-brown-leather', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 45 WHERE [MaHH] = 1046;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Panasonic LUMIX Red Compact', [TenAlias] = N'panasonic-lumix-red-compact', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1047;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Fujifilm FinePix J40 Black', [TenAlias] = N'fujifilm-finepix-j40-black', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1048;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SX130 IS', [TenAlias] = N'canon-powershot-sx130-is', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1049;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon D3100 DSLR Starter', [TenAlias] = N'nikon-d3100-dslr-starter', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1050;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt UGG Classic Pink Button', [TenAlias] = N'giay-bot-ugg-classic-pink-button', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1051;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Paris Hilton Heiress Perfume', [TenAlias] = N'paris-hilton-heiress-perfume', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 75 WHERE [MaHH] = 1052;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Solitaire Diamond', [TenAlias] = N'nhan-bac-dinh-da-solitaire-diamond', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 15 WHERE [MaHH] = 1053;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Moonstone Gem', [TenAlias] = N'nhan-bac-dinh-da-moonstone-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1054;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn bạc đính đá Orange Amber', [TenAlias] = N'nhan-bac-dinh-da-orange-amber', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1055;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Calvin Klein Eternity for Men', [TenAlias] = N'calvin-klein-eternity-for-men', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 95 WHERE [MaHH] = 1056;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Nautica Blue Eau de Toilette', [TenAlias] = N'nautica-blue-eau-de-toilette', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1057;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali London Fog Pegasus Brown Leather II', [TenAlias] = N'vali-london-fog-pegasus-brown-leather-ii', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 105 WHERE [MaHH] = 1058;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia 5310 XpressMusic', [TenAlias] = N'nokia-5310-xpressmusic', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1059;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia C7 Touch Sleek', [TenAlias] = N'nokia-c7-touch-sleek', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 115 WHERE [MaHH] = 1060;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Prestige Business', [TenAlias] = N'msi-prestige-business-laptop', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 55 WHERE [MaHH] = 1061;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Nikon COOLPIX Autumn Red', [TenAlias] = N'nikon-coolpix-autumn-red', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 125 WHERE [MaHH] = 1062;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Essential Grey Slim', [TenAlias] = N'hp-essential-grey-slim', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 65 WHERE [MaHH] = 1063;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nước hoa Britney Spears Fantasy Pink', [TenAlias] = N'britney-spears-fantasy-pink', [MaLoai] = 1004, [MaNCC] = N'SM', [SoLuong] = 135 WHERE [MaHH] = 1064;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop MSI Dodgers Edition Gaming', [TenAlias] = N'msi-dodgers-edition-gaming', [MaLoai] = 1001, [MaNCC] = N'SE', [SoLuong] = 75 WHERE [MaHH] = 1065;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS ROG Premium Gaming', [TenAlias] = N'asus-rog-premium-gaming', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 15 WHERE [MaHH] = 1066;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ TAG Heuer Carrera Silver Steel', [TenAlias] = N'dong-ho-tag-heuer-carrera-silver-steel', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 85 WHERE [MaHH] = 1067;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Máy ảnh Canon PowerShot SD1300 Silver', [TenAlias] = N'canon-powershot-sd1300-silver', [MaLoai] = 1002, [MaNCC] = N'SM', [SoLuong] = 25 WHERE [MaHH] = 1068;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại BlackBerry Torch Slider', [TenAlias] = N'blackberry-torch-slider', [MaLoai] = 1003, [MaNCC] = N'MO', [SoLuong] = 95 WHERE [MaHH] = 1069;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Tough Solar', [TenAlias] = N'casio-pro-trek-tough-solar', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 35 WHERE [MaHH] = 1070;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia N8 Touch Smartphone', [TenAlias] = N'nokia-n8-touch-smartphone', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 105 WHERE [MaHH] = 1071;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Điện thoại Nokia Nseries Luxury Flip', [TenAlias] = N'nokia-nseries-luxury-flip', [MaLoai] = 1003, [MaNCC] = N'NK', [SoLuong] = 45 WHERE [MaHH] = 1072;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Vali Samsonite Light Blue Hard-Shell', [TenAlias] = N'vali-samsonite-light-blue-hard-shell', [MaLoai] = 1007, [MaNCC] = N'SM', [SoLuong] = 115 WHERE [MaHH] = 1073;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Giày bốt Black Fur Trimmed Winter', [TenAlias] = N'giay-bot-black-fur-trimmed-winter', [MaLoai] = 1006, [MaNCC] = N'SM', [SoLuong] = 55 WHERE [MaHH] = 1074;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Black', [TenAlias] = N'casio-g-shock-black', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 125 WHERE [MaHH] = 1075;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Square Steel Chronograph Retro', [TenAlias] = N'dong-ho-square-steel-chronograph-retro', [MaLoai] = 1000, [MaNCC] = N'SM', [SoLuong] = 65 WHERE [MaHH] = 1076;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop HP Compaq Vintage Edition', [TenAlias] = N'hp-compaq-vintage-edition', [MaLoai] = 1001, [MaNCC] = N'HP', [SoLuong] = 135 WHERE [MaHH] = 1077;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio G-Shock Analog-Digital', [TenAlias] = N'casio-g-shock-analog-digital', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 25 WHERE [MaHH] = 1081;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Nhẫn Claddagh Blue Heart Gem', [TenAlias] = N'nhan-claddagh-blue-heart-gem', [MaLoai] = 1005, [MaNCC] = N'SM', [SoLuong] = 35 WHERE [MaHH] = 1083;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Đồng hồ Casio Pro Trek Pathfinder', [TenAlias] = N'casio-pro-trek-pathfinder', [MaLoai] = 1000, [MaNCC] = N'MO', [SoLuong] = 105 WHERE [MaHH] = 1084;
UPDATE [dbo].[HangHoa] SET [TenHH] = N'Laptop ASUS Zenbook Premium Ultra', [TenAlias] = N'asus-zenbook-premium-ultra', [MaLoai] = 1001, [MaNCC] = N'AC', [SoLuong] = 45 WHERE [MaHH] = 1085;

GO

-- ==========================================================================
-- UpdateDescriptions.sql - Consolidated Vietnamese SEO descriptions
-- ==========================================================================
-- ========================================================
-- BẢN CẬP NHẬT MÔ TẢ SẢN PHẨM TIẾNG VIỆT CHUẨN SEO
-- Dự án: QuaMonHai - HShop2023
-- Chạy file này trên Somee hoặc Local SSMS để sửa lỗi mô tả
-- ========================================================
USE [Hshop2023];
GO

UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Thụy Sỹ Swatch nổi bật với ngôn ngữ thiết kế trẻ trung, phối màu cá tính và thời trang độc đáo. Sử dụng bộ máy Quartz Thụy Sỹ đo giờ chính xác tuyệt đối, vỏ chất liệu cao cấp nhẹ nhàng cùng khả năng chống nước tốt, đây là món phụ kiện hoàn hảo để tôn lên phong cách năng động và hiện đại của bạn.' WHERE [MaHH] = 1001;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Thụy Sỹ Tissot danh tiếng lâu đời, mang phong cách thiết kế sang trọng, lịch lãm đầy lôi cuốn của giới thượng lưu. Trang bị mặt kính Sapphire nguyên khối chống trầy xước hoàn hảo, bộ máy Automatic cơ khí tinh xảo hoạt động bền bỉ, là biểu tượng đẳng cấp dành riêng cho quý ông và quý bà thành đạt.' WHERE [MaHH] = 1002;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.' WHERE [MaHH] = 1003;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.' WHERE [MaHH] = 1004;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop Dell sở hữu thiết kế tối giản, bộ khung vỏ chắc chắn đạt tiêu chuẩn độ bền quân đội. Được trang bị cấu hình phần cứng mạnh mẽ với vi xử lý Intel Core hiệu năng cao, dung lượng RAM lớn và ổ cứng SSD tốc độ cao, máy đáp ứng hoàn hảo từ các tác vụ văn phòng, lập trình kỹ thuật chuyên sâu cho đến nhu cầu học tập và giải trí đa phương tiện mượt mà.' WHERE [MaHH] = 1005;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.' WHERE [MaHH] = 1006;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.' WHERE [MaHH] = 1007;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.' WHERE [MaHH] = 1008;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc đính đá Opal trắng tự nhiên với ánh ngũ sắc xà cừ kỳ diệu lấp lánh thay đổi theo góc nhìn, kết hợp cùng các viên đá kim cương nhân tạo CZ tinh xảo. Món trang sức phong thủy mang lại may mắn, bình an, đồng thời tôn lên vẻ đẹp kiêu sa, quý phái của chủ nhân.' WHERE [MaHH] = 1009;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali balo Osprey đa năng thông minh kết hợp hoàn hảo giữa balo phượt chuyên dụng và vali kéo tiện lợi. Chất liệu vải nylon chống rách siêu nhẹ chống thấm nước, quai đeo trợ lực thiết kế công thái học ôm sát lưng cùng tay kéo hợp kim chắc khỏe, là bạn đồng hành lý tưởng.' WHERE [MaHH] = 1010;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1011;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1012;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1013;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.' WHERE [MaHH] = 1014;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop Toshiba nổi tiếng với độ bền vượt trội theo thời gian và sự ổn định cao trong vận hành. Máy sở hữu thiết kế chắc chắn, bàn phím tiêu chuẩn gõ êm và cấu hình tối ưu tốt cho mọi tác vụ văn phòng cơ bản, duyệt web, xử lý dữ liệu và học tập hàng ngày.' WHERE [MaHH] = 1015;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh bán chuyên nghiệp DSLR Nikon sở hữu cảm biến ảnh lớn, chip xử lý hình ảnh tốc độ cao mang lại chất lượng ảnh chuyên nghiệp tuyệt vời. Khả năng lấy nét tự động cực nhanh, dải ISO rộng chụp thiếu sáng xuất sắc cùng khả năng thay đổi ống kính linh hoạt, đáp ứng mọi đam mê sáng tạo nhiếp ảnh.' WHERE [MaHH] = 1016;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc Celtic Knot mang ngôn ngữ thiết kế nút thắt vô tận độc đáo của người Ireland cổ đại, biểu tượng cho tình yêu vĩnh cửu và sự gắn kết vô tận. Nhẫn chế tác tinh xảo từ chất liệu bạc Sterling 925 sáng bóng, phong cách thanh lịch, tinh tế thích hợp đeo hàng ngày.' WHERE [MaHH] = 1017;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1018;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.' WHERE [MaHH] = 1019;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.' WHERE [MaHH] = 1020;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.' WHERE [MaHH] = 1021;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Guess dành cho phái đẹp mang hương thơm thanh mát ngọt ngào đầy quyến rũ. Sự kết hợp tinh tế từ hương quả mọng tươi trẻ, hoa mẫu đơn thanh lịch ở tầng hương giữa và gỗ ấm áp xạ hương ở tầng hương cuối tạo nên một phong cách thanh lịch, quyến rũ và đầy lôi cuốn.' WHERE [MaHH] = 1022;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa cao cấp Dolce & Gabbana Light Blue mang hương thơm phóng khoáng, tươi mát tràn đầy năng lượng tươi trẻ của biển Địa Trung Hải. Sự hòa quyện hoàn hảo giữa chanh vàng Ý tươi mát, táo xanh giòn ngọt kết hợp cùng gỗ tuyết tùng ấm áp, mang lại hương thơm sảng khoái suốt cả ngày.' WHERE [MaHH] = 1023;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Citizen tích hợp công nghệ Eco-Drive độc quyền giúp hấp thu và chuyển hóa mọi nguồn sáng thành năng lượng hoạt động, hoàn toàn không cần thay pin. Thiết kế tinh xảo với vỏ thép không gỉ cao cấp, mặt kính chống xước cùng khả năng chống nước vượt trội, mang lại vẻ ngoài lịch lãm và nam tính mạnh mẽ.' WHERE [MaHH] = 1024;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.' WHERE [MaHH] = 1025;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh Fujifilm sở hữu thiết kế cổ điển sang trọng cùng công nghệ giả lập màu phim trứ danh độc quyền. Ảnh chụp có độ chi tiết rất cao, màu sắc mang đậm tính nghệ thuật cổ điển, lấy nét tự động nhanh chóng và chính xác, lý tưởng cho những ai yêu thích nhiếp ảnh đường phố.' WHERE [MaHH] = 1026;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.' WHERE [MaHH] = 1027;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Giày bốt dã ngoại Sorel chống nước hoàn hảo với cổ giày lót lông ấm áp, chất liệu cao su đúc nguyên khối chống thấm bền bỉ. Thiết kế thể thao khỏe khoắn năng động, đế bám cực tốt chống trơn trượt hiệu quả, chuyên dụng cho hoạt động leo núi, dã ngoại thời tiết xấu.' WHERE [MaHH] = 1028;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc đính đá Opal trắng tự nhiên với ánh ngũ sắc xà cừ kỳ diệu lấp lánh thay đổi theo góc nhìn, kết hợp cùng các viên đá kim cương nhân tạo CZ tinh xảo. Món trang sức phong thủy mang lại may mắn, bình an, đồng thời tôn lên vẻ đẹp kiêu sa, quý phái của chủ nhân.' WHERE [MaHH] = 1029;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali balo High Sierra đa năng năng động tích hợp ngăn chứa đồ thông minh siêu rộng rãi. Bánh xe kéo thể thao chắc khỏe di chuyển mượt mà kết hợp hệ thống quai đeo balo ẩn hiện linh hoạt, thích hợp cho các chuyến du lịch ngắn ngày, dã ngoại dạo phố.' WHERE [MaHH] = 1030;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1031;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1032;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1033;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Michael Kors thời trang Mỹ thời thượng với thiết kế mạ vàng hồng quý phái, viền đính đá Swarovski lấp lánh sang trọng. Đây là món trang sức hoàn hảo tôn vinh vẻ đẹp kiều diễm, thanh lịch và kiêu kỳ của phái đẹp trong mọi bữa tiệc và sự kiện quan trọng.' WHERE [MaHH] = 1034;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.' WHERE [MaHH] = 1035;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali balo High Sierra đa năng năng động tích hợp ngăn chứa đồ thông minh siêu rộng rãi. Bánh xe kéo thể thao chắc khỏe di chuyển mượt mà kết hợp hệ thống quai đeo balo ẩn hiện linh hoạt, thích hợp cho các chuyến du lịch ngắn ngày, dã ngoại dạo phố.' WHERE [MaHH] = 1036;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1037;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ chuyên dụng quân đội siêu bền bỉ Luminox, vỏ chất liệu carbon siêu nhẹ chống sốc và chịu va đập cực tốt. Trang bị công nghệ ống khí tự phát sáng liên tục suốt 25 năm bất kể điều kiện ánh sáng, khả năng chống nước cực cao, được tin dùng bởi lực lượng đặc nhiệm Navy SEAL.' WHERE [MaHH] = 1038;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.' WHERE [MaHH] = 1039;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1040;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1041;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Paris Hilton mang phong cách ngọt ngào, gợi cảm và vô cùng quyến rũ, kiêu sa. Hương thơm chủ đạo là sự kết hợp ngọt lịm từ dưa gang nhiệt đới, đào mọng cùng hương các loài hoa sang quý, thích hợp cho những buổi hẹn hò lãng mạn hoặc tiệc đêm sang trọng.' WHERE [MaHH] = 1042;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Citizen tích hợp công nghệ Eco-Drive độc quyền giúp hấp thu và chuyển hóa mọi nguồn sáng thành năng lượng hoạt động, hoàn toàn không cần thay pin. Thiết kế tinh xảo với vỏ thép không gỉ cao cấp, mặt kính chống xước cùng khả năng chống nước vượt trội, mang lại vẻ ngoài lịch lãm và nam tính mạnh mẽ.' WHERE [MaHH] = 1043;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop Dell sở hữu thiết kế tối giản, bộ khung vỏ chắc chắn đạt tiêu chuẩn độ bền quân đội. Được trang bị cấu hình phần cứng mạnh mẽ với vi xử lý Intel Core hiệu năng cao, dung lượng RAM lớn và ổ cứng SSD tốc độ cao, máy đáp ứng hoàn hảo từ các tác vụ văn phòng, lập trình kỹ thuật chuyên sâu cho đến nhu cầu học tập và giải trí đa phương tiện mượt mà.' WHERE [MaHH] = 1044;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1045;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali kéo cao cấp London Fog mang phong cách cổ điển lịch lãm mang đậm chất hoàng gia Anh. Vali sử dụng chất liệu vải dệt họa tiết sang trọng kết hợp viền da cao cấp bền bỉ, khoang chứa rộng rãi chia ngăn thông minh cùng hệ thống bánh xe xoay 360 độ êm ái.' WHERE [MaHH] = 1046;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh Panasonic LUMIX dòng compact cao cấp, trang bị ống kính Leica danh tiếng thế giới. Máy cho chất lượng quay phim và chụp ảnh sắc nét, dải tương phản động rộng cùng hệ thống chống rung quang học 5 trục hiện đại, phong cách gọn nhẹ tiện dụng.' WHERE [MaHH] = 1047;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh Fujifilm sở hữu thiết kế cổ điển sang trọng cùng công nghệ giả lập màu phim trứ danh độc quyền. Ảnh chụp có độ chi tiết rất cao, màu sắc mang đậm tính nghệ thuật cổ điển, lấy nét tự động nhanh chóng và chính xác, lý tưởng cho những ai yêu thích nhiếp ảnh đường phố.' WHERE [MaHH] = 1048;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.' WHERE [MaHH] = 1049;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh bán chuyên nghiệp DSLR Nikon sở hữu cảm biến ảnh lớn, chip xử lý hình ảnh tốc độ cao mang lại chất lượng ảnh chuyên nghiệp tuyệt vời. Khả năng lấy nét tự động cực nhanh, dải ISO rộng chụp thiếu sáng xuất sắc cùng khả năng thay đổi ống kính linh hoạt, đáp ứng mọi đam mê sáng tạo nhiếp ảnh.' WHERE [MaHH] = 1050;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Giày bốt lông cừu UGG thời trang cổ ngắn cực kỳ cá tính với thiết kế đính khuy tiện lợi, chất liệu da lộn mềm mại cao cấp. Lớp lông cừu tự nhiên dày ấm bên trong đem lại cảm giác êm ái tối đa cho từng bước đi, phong cách trẻ trung năng động thích hợp cho mùa đông dạo phố.' WHERE [MaHH] = 1051;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Paris Hilton mang phong cách ngọt ngào, gợi cảm và vô cùng quyến rũ, kiêu sa. Hương thơm chủ đạo là sự kết hợp ngọt lịm từ dưa gang nhiệt đới, đào mọng cùng hương các loài hoa sang quý, thích hợp cho những buổi hẹn hò lãng mạn hoặc tiệc đêm sang trọng.' WHERE [MaHH] = 1052;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc đính viên đá Solitaire Diamond CZ nhô cao cổ điển lấp lánh tuyệt đẹp thu hút mọi ánh nhìn. Nhẫn được thiết kế tinh xảo, là minh chứng tuyệt vời cho tình yêu đôi lứa bền chặt và là món quà hoàn hảo nhất cho các buổi lễ đính hôn, kỷ niệm đặc biệt.' WHERE [MaHH] = 1053;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc đính đá Moonstone (đá mặt trăng) mang ánh sáng xà cừ huyền ảo dịu nhẹ đầy cuốn hút dưới ánh đèn. Thiết kế nhẫn thanh mảnh kết hợp ổ nhẫn bạc 925 chế tác tỉ mỉ, mang lại vẻ đẹp dịu dàng thanh tao, mang hơi hướng tâm linh may mắn cho phái đẹp.' WHERE [MaHH] = 1054;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn bạc đính đá hổ phách Amber tự nhiên màu cam mật ong ấm áp quý phái, mang ý nghĩa thu hút tài lộc, sức khỏe và sự thịnh vượng. Thiết kế nhẫn sang trọng, cổ điển độc bản, vô cùng nổi bật khi kết hợp cùng trang phục dạ tiệc.' WHERE [MaHH] = 1055;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Calvin Klein Eternity mang phong cách cổ điển, ấm áp, sâu lắng đầy mạnh mẽ nam tính. Tông hương tinh tế mở đầu với oải hương, hương thảo mộc thanh mát, tiếp nối bằng hương gỗ đàn hương và hổ phách ấm áp ở tầng hương cuối, tôn vinh vẻ lịch lãm trưởng thành.' WHERE [MaHH] = 1056;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Nautica Blue mang hương thơm đại dương xanh mát, sảng khoái và tràn đầy năng lượng nam tính mạnh mẽ. Tông hương mát lạnh của cam chanh quyện cùng gỗ tuyết tùng và xạ hương, cực kỳ thích hợp cho các hoạt động thể thao ngoài trời và sử dụng trong mùa hè nóng bức.' WHERE [MaHH] = 1057;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali kéo cao cấp London Fog mang phong cách cổ điển lịch lãm mang đậm chất hoàng gia Anh. Vali sử dụng chất liệu vải dệt họa tiết sang trọng kết hợp viền da cao cấp bền bỉ, khoang chứa rộng rãi chia ngăn thông minh cùng hệ thống bánh xe xoay 360 độ êm ái.' WHERE [MaHH] = 1058;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1059;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1060;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop MSI được thiết kế tối ưu cho hiệu năng đồ họa chuyên nghiệp và trải nghiệm gaming đỉnh cao. Máy sở hữu ngoại hình hầm hố cá tính, trang bị card đồ họa rời mạnh mẽ, hệ thống tản nhiệt Cooler Boost độc quyền cực mát cùng màn hình tần số quét cao siêu mượt, là trợ thủ đắc lực cho các game thủ và nhà sáng tạo nội dung.' WHERE [MaHH] = 1061;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh compact Nikon COOLPIX siêu mỏng nhẹ thời thượng với nhiều phiên bản màu sắc nổi bật. Sử dụng ống kính NIKKOR cao cấp lấy nét siêu nhanh, tích hợp công nghệ chống rung quang học xuất sắc giúp bạn dễ dàng ghi lại những bức ảnh gia đình và bạn bè sắc nét, tươi sáng nhất.' WHERE [MaHH] = 1062;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.' WHERE [MaHH] = 1063;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nước hoa Britney Spears Fantasy mang phong cách ngọt ngào lãng mạn đầy mê hoặc như một câu chuyện cổ tích. Tông hương chủ đạo ngọt ngào dễ thương từ sô cô la trắng, bánh cupcake kết hợp tinh tế cùng hoa nhài quyến rũ và gỗ đàn hương, độ lưu hương cực tốt.' WHERE [MaHH] = 1064;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop MSI được thiết kế tối ưu cho hiệu năng đồ họa chuyên nghiệp và trải nghiệm gaming đỉnh cao. Máy sở hữu ngoại hình hầm hố cá tính, trang bị card đồ họa rời mạnh mẽ, hệ thống tản nhiệt Cooler Boost độc quyền cực mát cùng màn hình tần số quét cao siêu mượt, là trợ thủ đắc lực cho các game thủ và nhà sáng tạo nội dung.' WHERE [MaHH] = 1065;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.' WHERE [MaHH] = 1066;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ TAG Heuer thể thao cao cấp từ Thụy Sỹ, sở hữu thiết kế cơ khí mạnh mẽ nam tính với vòng Bezel xoay Chronograph thể thao năng động. Bộ máy cơ học tinh xảo đạt độ chính xác cực cao, vỏ thép không gỉ chống va đập và chống nước độ sâu vượt trội, dành riêng cho những quý ông đam mê tốc độ và sự chinh phục.' WHERE [MaHH] = 1067;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Máy ảnh du lịch Canon PowerShot sở hữu thiết kế vô cùng nhỏ gọn, thời trang và tiện lợi. Trang bị cảm biến hình ảnh độ phân giải cao cùng khả năng zoom quang học mạnh mẽ, tích hợp các chế độ chụp tự động thông minh và quay phim Full HD sắc nét, cực kỳ thích hợp để lưu giữ những khoảnh khắc đẹp trong mọi chuyến đi.' WHERE [MaHH] = 1068;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1069;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ chuyên thám hiểm dã ngoại Casio Pro Trek tích hợp công nghệ Tough Solar tự động sạc bằng năng lượng mặt trời. Máy trang bị bộ ba cảm biến (Triple Sensor) gồm la bàn số, đo áp suất/độ cao và nhiệt độ vô cùng chính xác, là người bạn đồng hành hoàn hảo cho những chuyến leo núi, phượt dã ngoại chuyên nghiệp.' WHERE [MaHH] = 1070;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1071;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Sản phẩm cao cấp chất lượng vượt trội chính hãng, được đông đảo khách hàng tin dùng lựa chọn. Thiết kế tiện dụng hiện đại, chất liệu bền bỉ an toàn, mang lại trải nghiệm sử dụng hoàn hảo và giá trị bền vững cho cuộc sống của bạn.' WHERE [MaHH] = 1072;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Vali Samsonite cao cấp siêu bền bỉ, chế tác từ chất liệu Polycarbonate có khả năng đàn hồi cực cao chống bể vỡ và chống xước hoàn hảo. Trang bị khóa số bảo mật chuẩn quốc tế TSA an toàn, bánh xe đôi xoay 360 độ siêu êm ái giúp di chuyển nhẹ nhàng trên mọi địa hình.' WHERE [MaHH] = 1073;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Giày bốt đi tuyết cao cổ chuyên dụng, chất liệu da chống thấm nước tuyệt đối kết hợp lớp lót lông cừu dày dặn, ấm áp mềm mại giúp giữ ấm đôi bàn chân hoàn hảo dưới thời tiết giá lạnh. Đế cao su chịu lực với rãnh chống trượt sâu, vô cùng an toàn khi di chuyển.' WHERE [MaHH] = 1074;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Casio G-Shock huyền thoại với cấu trúc chống va đập, chống sốc và chống nước ở độ sâu 200m vượt trội. Thiết kế thể thao hầm hố, tích hợp các tính năng thông minh như giờ thế giới, bấm giờ thể thao, báo thức và đèn LED cực sáng, mang lại độ bền bỉ bất chấp thời gian.' WHERE [MaHH] = 1075;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ thời trang cao cấp chính hãng, thiết kế sang trọng tinh tế tinh xảo đến từng chi tiết. Sử dụng bộ máy hoạt động chính xác bền bỉ, mặt kính chống xước tốt và khả năng chống nước cao, tôn lên phong cách thời thượng và đẳng cấp của người đeo.' WHERE [MaHH] = 1076;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop HP sở hữu vẻ ngoài thanh lịch thời thượng với tông màu bạc sang trọng, các đường nét thiết kế tinh tế và viền màn hình siêu mỏng sắc nét. Cấu hình mạnh mẽ mang lại trải nghiệm làm việc năng suất vượt trội, bàn phím gõ cực kỳ êm ái cùng thời lượng pin bền bỉ, là sự lựa chọn lý tưởng cho doanh nhân, nhân viên văn phòng và các bạn sinh viên.' WHERE [MaHH] = 1077;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ Casio G-Shock huyền thoại với cấu trúc chống va đập, chống sốc và chống nước ở độ sâu 200m vượt trội. Thiết kế thể thao hầm hố, tích hợp các tính năng thông minh như giờ thế giới, bấm giờ thể thao, báo thức và đèn LED cực sáng, mang lại độ bền bỉ bất chấp thời gian.' WHERE [MaHH] = 1081;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Nhẫn Claddagh truyền thống của Ireland với biểu tượng hai bàn tay nâng niu trái tim đội vương miện, tượng trưng cho tình bạn chân thành, tình yêu nồng cháy và lòng trung thành tuyệt đối. Chế tác tinh xảo từ bạc 925 cao cấp.' WHERE [MaHH] = 1083;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Đồng hồ chuyên thám hiểm dã ngoại Casio Pro Trek tích hợp công nghệ Tough Solar tự động sạc bằng năng lượng mặt trời. Máy trang bị bộ ba cảm biến (Triple Sensor) gồm la bàn số, đo áp suất/độ cao và nhiệt độ vô cùng chính xác, là người bạn đồng hành hoàn hảo cho những chuyến leo núi, phượt dã ngoại chuyên nghiệp.' WHERE [MaHH] = 1084;
UPDATE [dbo].[HangHoa] SET [MoTa] = N'Laptop ASUS nổi bật với ngôn ngữ thiết kế hiện đại, trẻ trung và vô cùng mỏng nhẹ, cực kỳ thuận tiện cho việc di chuyển hàng ngày. Màn hình độ phân giải cao hiển thị màu sắc sống động, bộ vi xử lý tối ưu hiệu năng cùng hệ thống tản nhiệt thông minh hoạt động êm ái, mang lại trải nghiệm sử dụng trọn vẹn cho cả công việc và giải trí.' WHERE [MaHH] = 1085;

PRINT N'Cập nhật thành công 81 mô tả sản phẩm tiếng Việt!';

-- ==========================================================================
-- AddVouchers.sql - Seeds promotion codes
-- ==========================================================================
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

PRINT '============================================================';
PRINT ' QMHaiShop_Full_Setup.sql run successfully!';
PRINT ' Database is fully configured and ready to use.!';
PRINT '============================================================';
