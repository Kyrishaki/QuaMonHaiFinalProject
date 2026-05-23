using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class HangHoa
{
    public int MaHh { get; set; }

    public string TenHh { get; set; } = null!;

    public string? TenAlias { get; set; }

    public int MaLoai { get; set; }

    public string? MoTaDonVi { get; set; }

    public double? DonGia { get; set; }

    public decimal GiaSauGiam { get; set; }

    public string? Hinh { get; set; }

    public DateTime NgaySx { get; set; }

    [Range(0, 100, ErrorMessage = "Giảm giá chỉ được nhập từ 0 đến 100%.")]
    public double GiamGia { get; set; }

    public int SoLanXem { get; set; }

    public string? MoTa { get; set; }

    public string MaNcc { get; set; } = null!;

    public int SoLuong { get; set; }

    public virtual ICollection<BanBe> BanBes { get; set; } = new List<BanBe>();

    public virtual ICollection<ChiTietHd> ChiTietHds { get; set; } = new List<ChiTietHd>();

    public virtual ICollection<GioHang> GioHangs { get; set; } = new List<GioHang>();

    public virtual Loai MaLoaiNavigation { get; set; } = null!;

    public virtual NhaCungCap MaNccNavigation { get; set; } = null!;

    public virtual ICollection<YeuThich> YeuThiches { get; set; } = new List<YeuThich>();

    public virtual ICollection<BinhLuan> BinhLuans { get; set; } = new List<BinhLuan>();
}

