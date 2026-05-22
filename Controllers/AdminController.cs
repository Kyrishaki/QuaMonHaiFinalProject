using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    [Authorize(Roles = "Admin")]
    public class AdminController : Controller
    {
        private readonly Hshop2023Context _context;

        public AdminController(Hshop2023Context context)
        {
            _context = context;
        }

        // GET: Admin/UserManagement
        [HttpGet]
        public async Task<IActionResult> UserManagement(string searchQuery)
        {
            ViewBag.SearchQuery = searchQuery;

            var query = _context.KhachHangs.AsNoTracking().AsQueryable();

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query = query.Where(kh => kh.MaKh.Contains(searchQuery) || 
                                          kh.HoTen.Contains(searchQuery) || 
                                          kh.Email.Contains(searchQuery));
            }

            // Đưa tài khoản Admin lên trước, sắp xếp theo tên đăng nhập
            var users = await query.OrderByDescending(kh => kh.VaiTro)
                                   .ThenBy(kh => kh.MaKh)
                                   .ToListAsync();

            return View(users);
        }

        // POST: Admin/ToggleHieuLuc
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleHieuLuc(string id)
        {
            var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(kh => kh.MaKh == id);
            if (khachHang == null)
            {
                return NotFound();
            }

            // Lấy ID Admin đang đăng nhập hiện tại
            var currentUserId = User.Claims.FirstOrDefault(c => c.Type == "CustomerID")?.Value;
            if (id == currentUserId)
            {
                TempData["Error"] = "Bạn không thể tự khóa tài khoản của chính mình!";
                return RedirectToAction(nameof(UserManagement));
            }

            khachHang.HieuLuc = !khachHang.HieuLuc;
            _context.Update(khachHang);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Đã {(khachHang.HieuLuc ? "mở khóa" : "khóa")} tài khoản {id} thành công!";
            return RedirectToAction(nameof(UserManagement));
        }

        // POST: Admin/ChangeRole
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangeRole(string id, int vaiTro)
        {
            var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(kh => kh.MaKh == id);
            if (khachHang == null)
            {
                return NotFound();
            }

            // Lấy ID Admin đang đăng nhập hiện tại
            var currentUserId = User.Claims.FirstOrDefault(c => c.Type == "CustomerID")?.Value;
            if (id == currentUserId)
            {
                TempData["Error"] = "Bạn không thể tự thu hồi quyền Admin của chính mình!";
                return RedirectToAction(nameof(UserManagement));
            }

            khachHang.VaiTro = vaiTro;
            _context.Update(khachHang);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Đã cập nhật phân quyền tài khoản {id} thành {(vaiTro == 1 ? "Admin" : "Khách hàng")}!";
            return RedirectToAction(nameof(UserManagement));
        }

        // GET: Admin/OrderHistory
        [HttpGet]
        public async Task<IActionResult> OrderHistory(string searchQuery, int? statusId)
        {
            ViewBag.SearchQuery = searchQuery;
            ViewBag.StatusId = statusId;

            var query = _context.HoaDons
                .Include(h => h.MaKhNavigation)
                .Include(h => h.ChiTietHds)
                .ThenInclude(c => c.MaHhNavigation)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query = query.Where(h => (h.HoTen != null && h.HoTen.Contains(searchQuery)) || 
                                         h.MaKh.Contains(searchQuery) ||
                                         h.MaHd.ToString() == searchQuery);
            }

            if (statusId.HasValue)
            {
                query = query.Where(h => h.MaTrangThai == statusId.Value);
            }

            var orders = await query.OrderByDescending(h => h.NgayDat).ToListAsync();
            return View(orders);
        }

        // POST: Admin/UpdateOrderStatus
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> UpdateOrderStatus(int id, int statusId)
        {
            var order = await _context.HoaDons.FirstOrDefaultAsync(h => h.MaHd == id);
            if (order == null)
            {
                return NotFound();
            }

            order.MaTrangThai = statusId;
            _context.Update(order);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Đã cập nhật trạng thái đơn hàng #{id} thành công!";
            return RedirectToAction(nameof(OrderHistory));
        }

        // GET: Admin/ReviewManagement
        [HttpGet]
        public async Task<IActionResult> ReviewManagement(string searchQuery, int? stars)
        {
            ViewBag.SearchQuery = searchQuery;
            ViewBag.Stars = stars;

            var query = _context.BinhLuans
                .Include(bl => bl.MaHhNavigation)
                .Include(bl => bl.MaKhNavigation)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query = query.Where(bl => (bl.NoiDung != null && bl.NoiDung.Contains(searchQuery)) ||
                                          bl.MaKhNavigation.HoTen.Contains(searchQuery) ||
                                          bl.MaKhNavigation.MaKh.Contains(searchQuery) ||
                                          bl.MaHhNavigation.TenHh.Contains(searchQuery));
            }

            if (stars.HasValue)
            {
                query = query.Where(bl => bl.Sao == stars.Value);
            }

            var reviews = await query.OrderByDescending(bl => bl.Ngay).ToListAsync();
            return View(reviews);
        }

        // POST: Admin/DeleteReview
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteReview(int id)
        {
            var review = await _context.BinhLuans.FirstOrDefaultAsync(bl => bl.MaBl == id);
            if (review == null)
            {
                return NotFound();
            }

            _context.BinhLuans.Remove(review);
            await _context.SaveChangesAsync();

            TempData["Success"] = "Đã xóa đánh giá thành công!";
            return RedirectToAction(nameof(ReviewManagement));
        }
    }
}
