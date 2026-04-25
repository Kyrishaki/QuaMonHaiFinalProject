using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Text.Json;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly Hshop2023Context _context;

        public HomeController(ILogger<HomeController> logger, Hshop2023Context context)
        {
            _logger = logger;
            _context = context;
        }

        // Hàm Index hỗ trợ tham số page để phân trang
        public async Task<IActionResult> Index(int page = 1)
        {
            int pageSize = 9; // Số sản phẩm hiển thị trên 1 trang (3x3)
            int skip = (page - 1) * pageSize; // Tính số lượng sản phẩm cần bỏ qua

            List<ApiProduct> dsSanPham = new List<ApiProduct>();
            int totalItems = 0;

            using (var client = new HttpClient())
            {
                // Gọi API với limit và skip để thực hiện phân trang
                // DummyJSON có tổng cộng 100 sản phẩm gốc
                string url = $"https://dummyjson.com/products?limit={pageSize}&skip={skip}";

                try
                {
                    var response = await client.GetAsync(url);
                    if (response.IsSuccessStatusCode)
                    {
                        var jsonString = await response.Content.ReadAsStringAsync();

                        // Cấu hình không phân biệt chữ hoa chữ thường khi đọc JSON
                        var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };

                        // Giải mã JSON sang Model ProductApiResponse
                        var apiData = JsonSerializer.Deserialize<ProductApiResponse>(jsonString, options);

                        if (apiData != null && apiData.products != null)
                        {
                            dsSanPham = apiData.products;
                            // Lấy giá trị tổng sản phẩm từ API (thường là 100 hoặc 194 tùy đợt update của DummyJSON)
                            totalItems = apiData.total;
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Ghi lại lỗi nếu không thể kết nối Internet hoặc API lỗi
                    ViewBag.Error = "Lỗi kết nối API: " + ex.Message;
                }
            }

            // Gửi dữ liệu tính toán phân trang sang View qua ViewBag
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            return View(dsSanPham);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}