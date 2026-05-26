using LTWEB_QuaMonHai_CuoiKy.Helpers;
using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.ViewModels
{
    public class RegisterVM
    {
        //MaKH, MatKhau, HoTen, GioiTinh, NgaySinh?, DiaChi, DienThoai, Email, Hinh?
        [Display(Name = "Tên đăng nhập")]
        [Required(ErrorMessage ="Phải điền tên đăng nhập")]
        [MaxLength(20, ErrorMessage ="Tối đa 20 ký tự")]
        public string MaKh { get; set; }


        [Display(Name = "Mật Khẩu")]
        [Required(ErrorMessage = "Phải điền mật khẩu")]
        [DataType(DataType.Password)]
        public string MatKhau { get; set; }


        [Display(Name ="Họ Tên")]
        [Required(ErrorMessage = "Điền họ và tên")]
        [MaxLength(50, ErrorMessage = "Tối đa 50 ký tự")]
        public string HoTen { get; set; }


        public bool GioiTinh { get; set; } = true;


        [Display(Name = "Ngày sinh")]
        [DataType(DataType.Date)]
        [AgeRange]
        public DateTime? NgaySinh { get; set; }


        [Display(Name = "Địa Chỉ")]
        [MaxLength(60, ErrorMessage = "Tối đa 60 ký tự")]
        public string? DiaChi { get; set; }


        [Display(Name = "Điện Thoại")]
        [MaxLength(10, ErrorMessage = "Số điện thoại tối đa là 10 ký tự")]
        [RegularExpression(@"^0(3|5|7|8|9)\d{8}$", ErrorMessage = "Số điện thoại phải đủ 10 số và đúng định dạng VN ")]
        public string? DienThoai { get; set; }


        [Display(Name = "Email")]
        [Required(ErrorMessage = "Vui lòng nhập Email")]
        [RegularExpression(@"^[^@\s]+@[^@\s]+\.[^@\s]+$", ErrorMessage = "Email phải có định dạng hợp lệ (ví dụ: abc@gmail.com)")]
        public string Email { get; set; }


        public string? Hinh { get; set; }


        [Display(Name = "Mã xác nhận Email")]
        [Required(ErrorMessage = "Vui lòng nhập mã xác nhận")]
        public string VerificationCode { get; set; }
    }
}
