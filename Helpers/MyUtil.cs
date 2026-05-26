using System.Text;
using SkiaSharp;

namespace LTWEB_QuaMonHai_CuoiKy.Helpers
{
    public class MyUtil
    {
        public static string UploadAvatar(IFormFile Hinh, string folder)
        {
            try
            {
                // 1. Tạo tên file duy nhất với định dạng .webp
                var fileName = Guid.NewGuid().ToString() + ".webp";
                
                // 2. Đường dẫn lưu: wwwroot/img/Hinh/KhachHang/
                var folderPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "img", "Hinh", folder);
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }
                
                var fullPath = Path.Combine(folderPath, fileName);

                // 3. Xử lý ảnh với SkiaSharp
                using (var inputStream = Hinh.OpenReadStream())
                using (var originalBitmap = SKBitmap.Decode(inputStream))
                {
                    if (originalBitmap == null) return string.Empty;

                    int targetSize = 300;
                    int origWidth = originalBitmap.Width;
                    int origHeight = originalBitmap.Height;

                    // Crop thành hình vuông từ chính giữa (center crop)
                    int minDim = Math.Min(origWidth, origHeight);
                    int x = (origWidth - minDim) / 2;
                    int y = (origHeight - minDim) / 2;

                    var cropRect = new SKRectI(x, y, x + minDim, y + minDim);

                    using (var croppedBitmap = new SKBitmap(minDim, minDim))
                    {
                        originalBitmap.ExtractSubset(croppedBitmap, cropRect);

                        // Resize về 300x300 pixel
                        using (var resizedBitmap = croppedBitmap.Resize(new SKImageInfo(targetSize, targetSize), SKFilterQuality.High))
                        {
                            if (resizedBitmap == null) return string.Empty;

                            // Lưu dưới định dạng WebP chất lượng nén 75%
                            using (var image = SKImage.FromBitmap(resizedBitmap))
                            using (var data = image.Encode(SKEncodedImageFormat.Webp, 75))
                            using (var stream = new FileStream(fullPath, FileMode.Create))
                            {
                                data.SaveTo(stream);
                            }
                        }
                    }
                }

                return fileName;
            }
            catch (Exception)
            {
                return string.Empty;
            }
        }

        public static string GenerateRandomKey(int length = 5)
        {
            var pattern = @"qazwsxedcrfvtgbyhnujmiklopQAZWSXEDCRFVTGBYHNUJMIKLOP!";
            var sb = new StringBuilder();
            var rd = new Random();
            for (int i = 0; i < length; i++)
            {
                sb.Append(pattern[rd.Next(0, pattern.Length)]);
            }

            return sb.ToString();
        }
    }
}
