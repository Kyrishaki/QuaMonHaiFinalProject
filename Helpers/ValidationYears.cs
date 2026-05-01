using System.ComponentModel.DataAnnotations;
namespace LTWEB_QuaMonHai_CuoiKy.Helpers
{
public class AgeRangeAttribute : ValidationAttribute
{
    protected override ValidationResult IsValid(object value, ValidationContext validationContext)
    {
        if (value is DateTime date)
        {
            int currentYear = DateTime.Now.Year;
            int minYear = currentYear - 100; // Giới hạn 100 tuổi
            int maxYear = currentYear - 16;  // Phải từ 16 tuổi trở lên
                if (date.Year > maxYear)
                {
                    return new ValidationResult($"Người đăng ký phải từ 16 tuổi trở lên.");
                }

                // 2. Kiểm tra nếu quá 100 tuổi
                if (date.Year < minYear)
                {
                    return new ValidationResult($"Tuổi giới hạn là 100.");
                }
            }
        return ValidationResult.Success;
    }
}
}
