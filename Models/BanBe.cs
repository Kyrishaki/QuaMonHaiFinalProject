using System.ComponentModel.DataAnnotations; // Add this using directive

namespace LTWEB_QuaMonHai_CuoiKy.Models;

public partial class BanBe {
    [Key] // Tell EF Core this is the Primary Key
    public int MaBb { get; set; }

    public string? MaKh { get; set; }

    public int MaHh { get; set; }

    public string? HoTen { get; set; }

    public string Email { get; set; } = null!;

    public DateTime NgayGui { get; set; }

    public string? GhiChu { get; set; }

    public virtual HangHoa MaHhNavigation { get; set; } = null!;

    public virtual KhachHang? MaKhNavigation { get; set; }
}