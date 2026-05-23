using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    [Authorize(Roles = "Admin,Staff")]
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
        [Authorize(Roles = "Admin")]
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
        [Authorize(Roles = "Admin")]
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

            string roleName = vaiTro == 1 ? "Admin" : (vaiTro == 2 ? "Nhân viên (Staff)" : "Khách hàng");
            TempData["Success"] = $"Đã cập nhật phân quyền tài khoản {id} thành {roleName}!";
            return RedirectToAction(nameof(UserManagement));
        }

        // POST: Admin/DeleteUser
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteUser(string id)
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
                TempData["Error"] = "Bạn không thể tự xóa tài khoản của chính mình!";
                return RedirectToAction(nameof(UserManagement));
            }

            khachHang.HieuLuc = false;
            _context.Update(khachHang);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Đã tắt (xóa mềm) tài khoản {id} thành công!";
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

        // GET: Admin/ChatDashboard
        [HttpGet]
        public IActionResult ChatDashboard()
        {
            return View();
        }

        // GET: Admin/GetActiveRooms
        [HttpGet]
        public async Task<IActionResult> GetActiveRooms()
        {
            var rooms = await _context.ChatMessages
                .GroupBy(m => m.ChatRoomId)
                .Select(g => new {
                    RoomId = g.Key,
                    LastMessageTime = g.Max(m => m.Timestamp)
                })
                .OrderByDescending(r => r.LastMessageTime)
                .ToListAsync();

            var resultList = new List<object>();
            foreach (var r in rooms)
            {
                var messages = _context.ChatMessages.Where(m => m.ChatRoomId == r.RoomId);
                var lastMsg = await messages.OrderByDescending(m => m.Timestamp).FirstOrDefaultAsync();
                var customerName = await messages.Where(m => m.IsFromCustomer).Select(m => m.SenderName).FirstOrDefaultAsync() 
                                   ?? lastMsg?.SenderName 
                                   ?? "Khách hàng";
                int unreadCount = await messages.CountAsync(m => m.IsFromCustomer && !m.IsRead);
                
                resultList.Add(new {
                    roomId = r.RoomId,
                    customerName = customerName,
                    lastMessage = lastMsg?.Message ?? "",
                    timestamp = lastMsg?.Timestamp.ToString("dd/MM HH:mm") ?? "",
                    unreadCount = unreadCount
                });
            }
            return Json(resultList);
        }

        // GET: Admin/GetRoomMessages
        [HttpGet]
        public async Task<IActionResult> GetRoomMessages(string roomId)
        {
            if (string.IsNullOrEmpty(roomId))
            {
                return Json(new List<object>());
            }

            // Đánh dấu tất cả tin nhắn khách gửi trong phòng này là đã đọc vì admin đã mở xem
            var unreadCustomerMsgs = await _context.ChatMessages
                .Where(m => m.ChatRoomId == roomId && m.IsFromCustomer && !m.IsRead)
                .ToListAsync();

            if (unreadCustomerMsgs.Any())
            {
                foreach (var msg in unreadCustomerMsgs)
                {
                    msg.IsRead = true;
                }
                await _context.SaveChangesAsync();
            }

            var messages = await _context.ChatMessages
                .Where(m => m.ChatRoomId == roomId)
                .OrderBy(m => m.Timestamp)
                .Select(m => new
                {
                    id = m.Id,
                    senderName = m.SenderName,
                    message = m.Message,
                    timestamp = m.Timestamp.ToString("HH:mm"),
                    isFromCustomer = m.IsFromCustomer,
                    isRead = m.IsRead
                })
                .ToListAsync();

            return Json(messages);
        }

        // POST: Admin/ReplyMessage
        [HttpPost]
        public async Task<IActionResult> ReplyMessage(string roomId, string message)
        {
            if (string.IsNullOrEmpty(roomId) || string.IsNullOrWhiteSpace(message))
            {
                return Json(new { success = false, error = "Dữ liệu không hợp lệ" });
            }

            var currentUserId = User.Claims.FirstOrDefault(c => c.Type == "CustomerID")?.Value ?? "Admin";
            var staff = await _context.KhachHangs.FirstOrDefaultAsync(kh => kh.MaKh == currentUserId);
            string senderName = staff != null ? staff.HoTen : (User.Identity?.Name ?? "Quản trị viên");

            var chatMsg = new ChatMessage
            {
                ChatRoomId = roomId,
                SenderId = currentUserId,
                SenderName = senderName,
                Message = message.Trim(),
                Timestamp = DateTime.Now,
                IsFromCustomer = false,
                IsRead = false
            };

            _context.ChatMessages.Add(chatMsg);
            await _context.SaveChangesAsync();

            return Json(new { success = true });
        }

        // POST: Admin/MarkAsRead
        [HttpPost]
        public async Task<IActionResult> MarkAsRead(string roomId)
        {
            if (string.IsNullOrEmpty(roomId))
            {
                return Json(new { success = false });
            }

            var unread = await _context.ChatMessages
                .Where(m => m.ChatRoomId == roomId && m.IsFromCustomer && !m.IsRead)
                .ToListAsync();

            if (unread.Any())
            {
                foreach (var msg in unread)
                {
                    msg.IsRead = true;
                }
                await _context.SaveChangesAsync();
            }

            return Json(new { success = true });
        }

        // GET: Admin/GetTotalUnreadCount
        [HttpGet]
        public async Task<IActionResult> GetTotalUnreadCount()
        {
            int count = await _context.ChatMessages
                .CountAsync(m => m.IsFromCustomer && !m.IsRead);
            return Json(new { count = count });
        }
    }
}
