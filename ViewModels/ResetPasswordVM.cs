using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.ViewModels
{
    public class ResetPasswordVM
    {
        [Required(ErrorMessage = "Vui lòng nhập mã xác thực OTP")]
        public string VerificationCode { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mật khẩu mới")]
        [DataType(DataType.Password)]
        [MinLength(6, ErrorMessage = "Mật khẩu phải từ 6 ký tự trở lên")]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "Vui lòng xác nhận lại mật khẩu")]
        [DataType(DataType.Password)]
        [Compare("NewPassword", ErrorMessage = "Mật khẩu xác nhận không trùng khớp")]
        public string ConfirmPassword { get; set; }
    }
}