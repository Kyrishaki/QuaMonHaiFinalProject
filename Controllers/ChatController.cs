using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class ChatController : Controller
    {
        private readonly Hshop2023Context db;

        public ChatController(Hshop2023Context context)
        {
            db = context;
        }

        private string GetOrCreateChatRoomId(out string displayName)
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                var customerId = User.Claims.FirstOrDefault(c => c.Type == "CustomerID")?.Value;
                if (!string.IsNullOrEmpty(customerId))
                {
                    var khachHang = db.KhachHangs.FirstOrDefault(kh => kh.MaKh == customerId);
                    displayName = khachHang != null ? khachHang.HoTen : (User.Identity.Name ?? "Khách hàng");
                    return customerId;
                }
            }

            // Đối với khách vãng lai (Guest)
            string guestCookieKey = "GuestChatId";
            string? guestId = Request.Cookies[guestCookieKey];

            if (string.IsNullOrEmpty(guestId))
            {
                guestId = "Guest_" + Guid.NewGuid().ToString("N").Substring(0, 8);
                CookieOptions options = new CookieOptions
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true,
                    IsEssential = true
                };
                Response.Cookies.Append(guestCookieKey, guestId, options);
            }

            displayName = "Khách " + guestId.Replace("Guest_", "").ToUpper();
            return guestId;
        }

        // GET: /Chat/GetMessages
        [HttpGet]
        public async Task<IActionResult> GetMessages()
        {
            string chatRoomId = GetOrCreateChatRoomId(out string _);

            // Tự động đánh dấu tất cả các phản hồi từ admin/staff thành đã đọc khi khách hàng xem tin nhắn
            var unreadReplies = await db.ChatMessages
                .Where(m => m.ChatRoomId == chatRoomId && !m.IsFromCustomer && !m.IsRead)
                .ToListAsync();

            if (unreadReplies.Any())
            {
                foreach (var msg in unreadReplies)
                {
                    msg.IsRead = true;
                }
                await db.SaveChangesAsync();
            }

            var messages = await db.ChatMessages
                .Where(m => m.ChatRoomId == chatRoomId)
                .OrderBy(m => m.Timestamp)
                .Select(m => new
                {
                    senderName = m.SenderName,
                    message = m.Message,
                    timestamp = m.Timestamp.ToString("HH:mm"),
                    isFromCustomer = m.IsFromCustomer
                })
                .ToListAsync();

            return Json(messages);
        }

        // POST: /Chat/SendMessage
        [HttpPost]
        public async Task<IActionResult> SendMessage(string message)
        {
            if (string.IsNullOrWhiteSpace(message))
            {
                return Json(new { success = false, error = "Tin nhắn trống" });
            }

            string chatRoomId = GetOrCreateChatRoomId(out string displayName);

            var chatMsg = new ChatMessage
            {
                ChatRoomId = chatRoomId,
                SenderId = chatRoomId,
                SenderName = displayName,
                Message = message.Trim(),
                Timestamp = DateTime.Now,
                IsFromCustomer = true,
                IsRead = false
            };

            db.ChatMessages.Add(chatMsg);
            await db.SaveChangesAsync();

            return Json(new { success = true });
        }

        // GET: /Chat/GetUnreadCount
        [HttpGet]
        public async Task<IActionResult> GetUnreadCount()
        {
            string chatRoomId = GetOrCreateChatRoomId(out string _);
            int count = await db.ChatMessages
                .CountAsync(m => m.ChatRoomId == chatRoomId && !m.IsFromCustomer && !m.IsRead);

            return Json(new { count = count });
        }
    }
}
