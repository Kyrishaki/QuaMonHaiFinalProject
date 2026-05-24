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

        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, string sortBy, int page = 1) {
            int pageSize = 9; // Số sản phẩm trên mỗi trang

            // Lấy danh sách ID sản phẩm yêu thích của người dùng hiện tại
            var favoriteProductIds = new List<int>();
            if (User.Identity?.IsAuthenticated == true) {
                var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
                if (!string.IsNullOrEmpty(customerId)) {
                    favoriteProductIds = await _context.YeuThiches
                        .Where(y => y.MaKh == customerId && y.MaHh.HasValue)
                        .Select(y => y.MaHh ?? 0)
                        .ToListAsync();
                }
            }
            ViewBag.FavoriteProductIds = favoriteProductIds;

            // Truyền danh sách Danh Mục cho Sidebar
            ViewBag.DanhMucs = await _context.Loais.Include(l => l.HangHoas).AsNoTracking().ToListAsync();
            ViewBag.TotalProductCount = await _context.HangHoas.CountAsync();
            ViewBag.CurrentLoai = loaiId;
            ViewBag.CurrentSort = sortBy;

            // Lấy dữ liệu cơ bản
            var query = _context.HangHoas
                                .Include(h => h.MaLoaiNavigation)
                                .AsNoTracking()
                                .AsQueryable();

            // Ẩn hoàn toàn sản phẩm ngưng bán hoặc hết hàng đối với mọi người dùng ở Trang chủ
            query = query.Where(h => h.HieuLuc && h.SoLuong > 0);

            // 1. Xử lý Lọc theo Danh mục (Sidebar)
            if (loaiId.HasValue) {
                query = query.Where(h => h.MaLoai == loaiId.Value);
            }

            // 2. Xử lý Lọc theo Tên (Tìm kiếm)
            if (!string.IsNullOrEmpty(searchQuery)) {
                query = query.Where(h => h.TenHh.Contains(searchQuery));
            }

            // 3. Xử lý Lọc theo Giá
            if (!string.IsNullOrEmpty(priceRange)) {
                if (double.TryParse(priceRange, out double maxVal)) {
                    query = query.Where(h => h.DonGia <= maxVal);
                } else {
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
            }

            // 4. Xử lý Sắp xếp
            if (sortBy == "price_asc") {
                query = query.OrderBy(h => h.DonGia);
            } else if (sortBy == "price_desc") {
                query = query.OrderByDescending(h => h.DonGia);
            }

            // Xử lý Phân trang
            int totalItems = await query.CountAsync();
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            var items = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var productIds = items.Select(i => i.MaHh).ToList();
            var soldCounts = await _context.ChiTietHds
                .Where(ct => productIds.Contains(ct.MaHh) && ct.MaHdNavigation.MaTrangThai != -1)
                .GroupBy(ct => ct.MaHh)
                .Select(g => new { MaHh = g.Key, TotalSold = g.Sum(ct => ct.SoLuong) })
                .ToDictionaryAsync(x => x.MaHh, x => x.TotalSold);
            ViewBag.SoldCounts = soldCounts;

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

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
