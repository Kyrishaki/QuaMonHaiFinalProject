using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.ViewModels
{
    public class ChangePasswordVM
    {
        [Required]
        public string ChangeMethod { get; set; } // "OldPassword" hoặc "EmailOTP"

        [Display(Name = "Mật khẩu hiện tại")]
        [DataType(DataType.Password)]
        public string? OldPassword { get; set; } // Thêm dấu ? ở đây

        [Display(Name = "Mã xác thực OTP")]
        public string? VerificationCode { get; set; } // Thêm dấu ? ở đây

        [Display(Name = "Mật khẩu mới")]
        [Required(ErrorMessage = "Vui lòng nhập mật khẩu mới")]
        [DataType(DataType.Password)]
        [MinLength(6, ErrorMessage = "Mật khẩu mới phải có ít nhất 6 ký tự")]
        public string NewPassword { get; set; }

        [Display(Name = "Xác nhận mật khẩu mới")]
        [Required(ErrorMessage = "Vui lòng xác nhận mật khẩu mới")]
        [DataType(DataType.Password)]
        [Compare("NewPassword", ErrorMessage = "Xác nhận mật khẩu không khớp với mật khẩu mới")]
        public string ConfirmPassword { get; set; }
    }
}