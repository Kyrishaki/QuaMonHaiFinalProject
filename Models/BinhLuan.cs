using System;
using System.Collections.Generic;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class BinhLuan
{
    public int MaBl { get; set; }

    public int MaHh { get; set; }

    public string MaKh { get; set; } = null!;

    public int Sao { get; set; }

    public string? NoiDung { get; set; }

    public DateTime Ngay { get; set; }

    public virtual HangHoa MaHhNavigation { get; set; } = null!;

    public virtual KhachHang MaKhNavigation { get; set; } = null!;
}
