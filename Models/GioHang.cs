namespace LTWEB_QuaMonHai_CuoiKy.Models {
    public partial class GioHang {
        public string MaKh { get; set; } = null!;
        public int MaHh { get; set; }
        public int SoLuong { get; set; }

        public virtual HangHoa MaHhNavigation { get; set; } = null!;
        public virtual KhachHang MaKhNavigation { get; set; } = null!;
    }
}