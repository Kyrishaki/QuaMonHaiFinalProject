using LTWEB_QuaMonHai_CuoiKy.Helpers;
using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class HomeController : Controller {
        private readonly ILogger<HomeController> _logger;

        private readonly Hshop2023Context _context;
        public HomeController(ILogger<HomeController> logger, Hshop2023Context context) {
            _logger = logger;
            _context = context;
        }

        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, string sortBy, int page = 1) {
            var items = await ProductQueryHelper.GetFilteredProductsAsync(
                _context, User, ViewBag, loaiId, searchQuery, priceRange, sortBy, page, manage: false);

            return View(items);
        }

        public IActionResult Privacy() {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error() {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
        public IActionResult AboutUs() {
            // Đặt tiêu đề cho Breadcrumb động nhận diện
            ViewData["Title"] = "About Us";
            ViewData["Breadcrumb_Parent"] = "Trang thông tin";
            ViewData["Breadcrumb_ParentLink"] = "#";
            return View();
        }

        public IActionResult Blog() {
            ViewData["Title"] = "Bài viết & Hướng dẫn";
            ViewData["Breadcrumb_Parent"] = "Trang thông tin";
            ViewData["Breadcrumb_ParentLink"] = "#";
            return View();
        }

        [Route("/AccessDenied")]
        public IActionResult AccessDenied() {
            ViewData["Title"] = "Truy cập bị từ chối";
            return View();
        }
    }
}
