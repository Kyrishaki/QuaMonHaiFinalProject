using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    [Authorize] // Bắt buộc đăng nhập để sử dụng giỏ hàng cá nhân
    public class CartController : Controller {
        private readonly Hshop2023Context _Context;

        public CartController(Hshop2023Context context) {
            _Context = context;
        }

        // Đã sửa lại hàm lấy CustomerId an toàn hơn
        private string GetCustomerId() {
            var claim = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")
                     ?? User.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            return claim?.Value ?? string.Empty;
        }

        public async Task<IActionResult> Index() {
            var customerId = GetCustomerId();

            // Nếu không lấy được ID (phiên đăng nhập lỗi), bắt đăng nhập lại
            if (string.IsNullOrEmpty(customerId)) {
                return RedirectToAction("Login", "KhachHang");
            }

            // Lấy dữ liệu giỏ hàng từ Database[cite: 8]
            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            // Chuyển đổi từ Model Database sang ViewModel CartItem để hiển thị[cite: 8]
            var cartItems = gioHangDb.Select(g => new CartItem {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = g.MaHhNavigation.DonGia ?? 0,
                Hinh = g.MaHhNavigation.Hinh,
                SoLuong = g.SoLuong
            }).ToList();

            return View(cartItems);
        }

        public async Task<IActionResult> AddToCart(int id, int quantity = 1) {
            var customerId = GetCustomerId();

            // Chặn không cho thêm vào giỏ nếu chưa có ID
            if (string.IsNullOrEmpty(customerId)) {
                return RedirectToAction("Login", "KhachHang");
            }

            var hanghoa = await _Context.HangHoas.SingleOrDefaultAsync(p => p.MaHh == id);
            if (hanghoa == null) return NotFound();

            var cartItem = await _Context.GioHangs
                .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

            if (cartItem == null) {
                cartItem = new GioHang {
                    MaKh = customerId,
                    MaHh = id,
                    SoLuong = quantity
                };
                _Context.GioHangs.Add(cartItem);
            }
            else {
                cartItem.SoLuong += quantity;
                _Context.GioHangs.Update(cartItem);
            }

            await _Context.SaveChangesAsync();
            return RedirectToAction("Index");
        }

        public async Task<IActionResult> Delete(int id) {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId)) return RedirectToAction("Login", "KhachHang");

            var itemToRemove = await _Context.GioHangs
                .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

            if (itemToRemove != null) {
                _Context.GioHangs.Remove(itemToRemove);
                await _Context.SaveChangesAsync();
            }
            return RedirectToAction("Index");
        }

        public async Task<IActionResult> UpdateQuantity(int id, int delta) {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId)) return RedirectToAction("Login", "KhachHang");

            var item = await _Context.GioHangs
                .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

            if (item != null) {
                item.SoLuong += delta;

                if (item.SoLuong < 1) {
                    item.SoLuong = 1;
                }

                _Context.GioHangs.Update(item);
                await _Context.SaveChangesAsync();
            }
            return RedirectToAction("Index");
        }

        // ================= KHU VỰC THANH TOÁN (CHECKOUT) =================

        [HttpGet]
        public async Task<IActionResult> Checkout() {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId)) return RedirectToAction("Login", "KhachHang");

            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            if (!gioHangDb.Any()) return RedirectToAction("Index");

            var khachHang = await _Context.KhachHangs.SingleOrDefaultAsync(kh => kh.MaKh == customerId);
            ViewBag.Cart = gioHangDb;

            return View(new CheckoutVM {
                HoTen = khachHang?.HoTen ?? "",
                DiaChi = khachHang?.DiaChi ?? ""
            });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutVM model) {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId)) return RedirectToAction("Login", "KhachHang");

            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            if (!gioHangDb.Any()) return RedirectToAction("Index");

            if (ModelState.IsValid) {
                var hoadon = new HoaDon {
                    MaKh = customerId,
                    HoTen = model.HoTen,
                    DiaChi = model.DiaChi,
                    NgayDat = DateTime.Now,
                    NgayCan = DateTime.Now.AddDays(3),
                    MaTrangThai = 0,
                    GhiChu = model.GhiChu,
                    CachThanhToan = "COD",
                    CachVanChuyen = "Giao hàng tiêu chuẩn",
                    PhiVanChuyen = 5
                };

                _Context.HoaDons.Add(hoadon);
                await _Context.SaveChangesAsync();

                var cthds = gioHangDb.Select(item => new ChiTietHd {
                    MaHd = hoadon.MaHd,
                    MaHh = item.MaHh,
                    SoLuong = item.SoLuong,
                    DonGia = item.MaHhNavigation.DonGia ?? 0,
                    GiamGia = 0
                }).ToList();

                _Context.ChiTietHds.AddRange(cthds);
                _Context.GioHangs.RemoveRange(gioHangDb); // Xóa giỏ hàng sau khi đặt thành công[cite: 8]
                await _Context.SaveChangesAsync();

                return RedirectToAction("Success", new { id = hoadon.MaHd });
            }

            ViewBag.Cart = gioHangDb;
            return View(model);
        }

        public IActionResult Success(int id) {
            ViewBag.OrderId = id;
            return View();
        }
    }
}