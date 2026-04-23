using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

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

        public IActionResult Index(int page = 1)
        {
            int pageSize = 9; // Giới hạn 9 sản phẩm mỗi trang

            // 1. Lấy toàn bộ truy vấn
            var query = _context.HangHoas.AsQueryable();

            // 2. Tính toán phân trang
            int totalItems = query.Count();
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Tránh lỗi số trang ngoài phạm vi
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            // 3. Chỉ lấy 9 sản phẩm của trang hiện tại
            var hangHoas = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            // Gửi dữ liệu phân trang qua View
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(hangHoas);
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
