using System;
using System.Collections.Generic;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class ChiTietHd
{
    public int MaCt { get; set; }

    public int MaHd { get; set; }

    public int MaHh { get; set; }

    public double DonGia { get; set; }

    public int SoLuong { get; set; }

    public double GiamGia { get; set; }

    /// <summary>FK đến bảng GiamGia. Nullable vì không bắt buộc phải có mã giảm giá</summary>
    public int? MaGg { get; set; }

    public virtual HoaDon MaHdNavigation { get; set; } = null!;

    public virtual HangHoa MaHhNavigation { get; set; } = null!;

    /// <summary>Navigation property đến mã giảm giá được áp dụng</summary>
    public virtual GiamGia? MaGgNavigation { get; set; }
}
