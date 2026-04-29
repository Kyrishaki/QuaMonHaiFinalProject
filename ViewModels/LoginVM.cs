using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.ViewModels
{
    public class LoginVM
    {
        [Display(Name ="Tên đăng nhập")]
        [Required(ErrorMessage ="*")]
        [MaxLength(20, ErrorMessage ="Tối đa 20 ký tự")]
        public string LoginName { get; set; }
        [Display(Name = "Mật khẩu")]
        [Required(ErrorMessage = "*")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
    }
}
