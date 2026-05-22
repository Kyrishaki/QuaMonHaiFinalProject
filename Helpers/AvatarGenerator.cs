using System;
using System.Security.Cryptography;
using System.Text;

namespace LTWEB_QuaMonHai_CuoiKy.Helpers
{
    public static class AvatarGenerator
    {
        /// <summary>
        /// Tạo chuỗi SVG ảnh đại diện đối xứng ngẫu nhiên dựa trên Username (giống GitHub)
        /// </summary>
        public static string GenerateGitHubAvatar(string username)
        {
            if (string.IsNullOrEmpty(username)) username = "guest";

            // 1. Băm username sang MD5 để lấy mảng byte cố định cho từng user
            byte[] hash;
            using (MD5 md5 = MD5.Create())
            {
                hash = md5.ComputeHash(Encoding.UTF8.GetBytes(username.ToLower().Trim()));
            }

            // 2. Lấy bảng màu tươi sáng mang phong cách GitHub từ mảng băm
            string[] colors = { "#34d399", "#60a5fa", "#f472b6", "#fbbf24", "#a78bfa", "#f87171", "#22d3ee", "#81c408" };
            string mainColor = colors[hash[0] % colors.Length];
            string bgColor = "#f3f4f6"; // Màu nền xám nhạt

            // 3. Khởi tạo chuỗi SVG kích thước 420x420 (để chia đều cho lưới 5x5 + padding)
            StringBuilder svg = new StringBuilder();
            svg.Append($"<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 420 420' width='100%' height='100%'>");
            svg.Append($"<rect width='420' height='420' fill='{bgColor}'/>");
            svg.Append("<g transform='translate(35, 35)'>"); // Thụt lề padding 35px xung quanh

            // Lưới 5x5 nhưng chỉ cần tính toán cho 3 cột đầu (Cột 0, 1, 2), Cột 3 và 4 đối xứng qua
            int byteIndex = 1;
            for (int col = 0; col < 3; col++)
            {
                for (int row = 0; row < 5; row++)
                {
                    // Dùng từng bit của mảng băm để quyết định ô đó có được tô màu hay không
                    bool isFilled = (hash[byteIndex % hash.Length] & (1 << (row % 8))) != 0;
                    byteIndex++;

                    if (isFilled)
                    {
                        int size = 70; // Kích thước mỗi ô vuông 70x70px
                        int y = row * size;

                        // Vẽ ô vuông ở cột hiện tại
                        int x1 = col * size;
                        svg.Append($"<rect x='{x1}' y='{y}' width='{size}' height='{size}' fill='{mainColor}'/>");

                        // Nếu không phải cột giữa (cột 2), vẽ đối xứng sang phía bên phải
                        if (col < 2)
                        {
                            int x2 = (4 - col) * size;
                            svg.Append($"<rect x='{x2}' y='{y}' width='{size}' height='{size}' fill='{mainColor}'/>");
                        }
                    }
                }
            }

            svg.Append("</g></svg>");
            return svg.ToString();
        }
    }
}