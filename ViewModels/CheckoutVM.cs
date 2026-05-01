using System.ComponentModel.DataAnnotations;

namespace LTWEB_QuaMonHai_CuoiKy.ViewModels {
    public class CheckoutVM {
        [Display(Name = "Họ tên người nhận")]
        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        public string HoTen { get; set; }

        [Display(Name = "Địa chỉ giao hàng")]
        [Required(ErrorMessage = "Vui lòng nhập địa chỉ")]
        public string DiaChi { get; set; }

        [Display(Name = "Ghi chú thêm")]
        public string? GhiChu { get; set; }
    }
}