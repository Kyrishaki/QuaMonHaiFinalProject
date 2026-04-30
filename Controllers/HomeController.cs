using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class HomeController : Controller {
        private readonly ILogger<HomeController> _logger;

        private readonly Hshop2023Context _context;
        public HomeController(ILogger<HomeController> logger, Hshop2023Context context) {
            _logger = logger;
            _context = context;
        }

        // Nhớ thêm các using này ở trên cùng file nếu chưa có
        // using Microsoft.EntityFrameworkCore;
        // using LTWEB_QuaMonHai_CuoiKy.Models;

        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, int page = 1) {
            int pageSize = 9;

            // Đổ danh mục ra ViewBag để Sidebar nhận được
            ViewBag.DanhMucs = await _context.Loais.AsNoTracking().ToListAsync();
            ViewBag.CurrentLoai = loaiId;

            var query = _context.HangHoas.Include(h => h.MaLoaiNavigation).AsNoTracking().AsQueryable();

            // LỌC THEO DANH MỤC
            if (loaiId.HasValue) {
                query = query.Where(h => h.MaLoai == loaiId.Value);
            }

            // LỌC THEO TÊN
            if (!string.IsNullOrEmpty(searchQuery)) {
                query = query.Where(h => h.TenHh.Contains(searchQuery));
            }

            // LỌC THEO GIÁ
            if (!string.IsNullOrEmpty(priceRange)) {
                switch (priceRange) {
                    case "under50":
                        query = query.Where(h => h.DonGia < 50);
                        break;
                    case "50to100":
                        query = query.Where(h => h.DonGia >= 50 && h.DonGia <= 100);
                        break;
                    case "over100":
                        query = query.Where(h => h.DonGia > 100);
                        break;
                }
            }

            int totalItems = await query.CountAsync();
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            var hangHoas = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(hangHoas);
        }

        public IActionResult Privacy() {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error() {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
