using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class GiamGia
{
    public int MaGg { get; set; }
    public string TenMa { get; set; } 
    [Range(0, 100, ErrorMessage = "Phần trăm giảm chỉ được nhập từ 0 đến 100%.")]
    public double PhanTramGiam { get; set; } 

    public DateTime NgayBatDau { get; set; } 
    public DateTime NgayKetThuc { get; set; }
    public double GiaTriDonToiThieu { get; set; }
    public int SoLanSuDung { get; set; }
    public bool TrangThai { get; set; } = true;
    public virtual ICollection<ChiTietHd> ChiTietHds { get; set; } = new List<ChiTietHd>();
}
