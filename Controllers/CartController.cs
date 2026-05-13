using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class CartController : Controller {
        private readonly Hshop2023Context _Context;
        public List<CartItem> shopCart => HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart) ?? new List<CartItem>();


        public CartController(Hshop2023Context context) {
            _Context = context;
        }

        
        private string GetCustomerId() {
            var claim = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")
                     ?? User.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            return claim?.Value ?? string.Empty;
        }

       public async Task<IActionResult> Index()
        {
            var customerId = GetCustomerId();
            var sessionCart = shopCart; // List<CartItem> lấy từ Session

            // CHƯA ĐĂNG NHẬP
            if (string.IsNullOrEmpty(customerId))
            {
                return View(sessionCart);
            }

            //  ĐÃ ĐĂNG NHẬP (Thực hiện gộp giỏ hàng Session vào DB)
            if (sessionCart.Any())
            {
                foreach (var item in sessionCart)
                {
                    // Kiểm tra xem món hàng trong Session đã có trong DB của User này chưa
                    var dbItem = await _Context.GioHangs
                        .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == item.MaHh);

                    if (dbItem != null)
                    {
                        dbItem.SoLuong += item.SoLuong; // Nếu có rồi thì cộng dồn
                    }
                    else
                    {
                        // Nếu chưa có thì thêm mới vào DB
                        _Context.GioHangs.Add(new GioHang
                        {
                            MaKh = customerId,
                            MaHh = item.MaHh,
                            SoLuong = item.SoLuong
                        });
                    }
                }

                // Sau khi đã gộp xong vào Database, xóa sạch Session để tránh gộp lặp lại 
                await _Context.SaveChangesAsync();
                HttpContext.Session.Remove(mySetting.ShopCart);
            }

            // Lấy toàn bộ dữ liệu từ Database ra để hiển thị (bao gồm cả các món vừa được gộp)
            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            var cartItems = gioHangDb.Select(g => new CartItem
            {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = g.MaHhNavigation.DonGia ?? 0,
                Hinh = g.MaHhNavigation.Hinh,
                SoLuong = g.SoLuong
            }).ToList();

            return View(cartItems);
        }

        public async Task<IActionResult> AddToCart(int id, int quantity = 1)
        {
            var customerId = GetCustomerId();

            // TRƯỜNG HỢP 1: CHƯA ĐĂNG NHẬP -> THAO TÁC TRÊN SESSION
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = shopCart; // Lấy List từ thuộc tính shopCart (Session)
                var item = carlist.SingleOrDefault(p => p.MaHh == id);

                if (item == null)
                {
                    var hh = _Context.HangHoas.AsNoTracking().SingleOrDefault(p => p.MaHh == id);
                    if (hh == null) return NotFound();

                    carlist.Add(new CartItem
                    {
                        MaHh = id,
                        TenHh = hh.TenHh,
                        DonGia = hh.DonGia ?? 0,
                        Hinh = hh.Hinh,
                        SoLuong = quantity
                    });
                }
                else
                {
                    item.SoLuong += quantity;
                }

                HttpContext.Session.Set(mySetting.ShopCart, carlist);
            }
            // TRƯỜNG HỢP 2: ĐÃ ĐĂNG NHẬP -> THAO TÁC TRÊN DATABASE
            else
            {
                var cartItem = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

                if (cartItem == null)
                {
                    // Kiểm tra hàng hóa tồn tại trước khi thêm vào bảng GioHang
                    var exists = await _Context.HangHoas.AnyAsync(p => p.MaHh == id);
                    if (!exists) return NotFound();

                    _Context.GioHangs.Add(new GioHang
                    {
                        MaKh = customerId,
                        MaHh = id,
                        SoLuong = quantity
                    });
                }
                else
                {
                    cartItem.SoLuong += quantity;
                }

                await _Context.SaveChangesAsync();
            }

            return RedirectToAction("Index");
        }
        public async Task<IActionResult> Delete(int id) {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = shopCart;
                var item = carlist.SingleOrDefault(p => p.MaHh == id);
                if (item == null) return NotFound();
                carlist.Remove(item);
                HttpContext.Session.Set(mySetting.ShopCart, carlist);
                return RedirectToAction("Index");
            }

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
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = shopCart;
                var updateItem = carlist.SingleOrDefault(p => p.MaHh == id);
                if (updateItem != null) {
                    updateItem.SoLuong += delta;
                    if (updateItem.SoLuong < 1) {
                        updateItem.SoLuong = 1;
                    }
                    HttpContext.Session.Set(mySetting.ShopCart, carlist);
                }
            }

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

        
    }
}