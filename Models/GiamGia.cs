using System;
using System.Collections.Generic;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class GiamGia
{
    /// <summary>Khóa chính, tự tăng</sumary>
    public int MaGg { get; set; }

    /// <summary>Tên/mã voucher, ví dụ: SUMMER2026, SALE50</summary>
    public string TenMa { get; set; } = null!;

    /// <summary>Phần trăm giảm giá, ví dụ: 10 = giảm 10%</summary>
    public double PhanTramGiam { get; set; }

    public DateTime? NgayBatDau { get; set; }
    public DateTime? NgayKetThuc { get; set; }
    public double? GiaTriDonToiThieu { get; set; }
    public int? SoLanSuDung { get; set; }
    public bool TrangThai { get; set; } = true;

    // Navigation property: Một mã giảm giá có thể được dùng trong nhiều chi tiết hóa đơn
    public virtual ICollection<ChiTietHd> ChiTietHds { get; set; } = new List<ChiTietHd>();
}
