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
    }
}
