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
            var sessionCart = shopCart; // List<CartItem> láº¥y tá»« Session

            // CHÆ¯A ÄÄ‚NG NHáº¬P
            if (string.IsNullOrEmpty(customerId))
            {
                return View(sessionCart);
            }

            //  ÄÃƒ ÄÄ‚NG NHáº¬P (Thá»±c hiá»‡n gá»™p giá» hÃ ng Session vÃ o DB)
            if (sessionCart.Any())
            {
                foreach (var item in sessionCart)
                {
                    // Kiá»ƒm tra xem mÃ³n hÃ ng trong Session Ä‘Ã£ cÃ³ trong DB cá»§a User nÃ y chÆ°a
                    var dbItem = await _Context.GioHangs
                        .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == item.MaHh);

                    if (dbItem != null)
                    {
                        dbItem.SoLuong += item.SoLuong; // Náº¿u cÃ³ rá»“i thÃ¬ cá»™ng dá»“n
                    }
                    else
                    {
                        // Náº¿u chÆ°a cÃ³ thÃ¬ thÃªm má»›i vÃ o DB
                        _Context.GioHangs.Add(new GioHang
                        {
                            MaKh = customerId,
                            MaHh = item.MaHh,
                            SoLuong = item.SoLuong
                        });
                    }
                }

                // Sau khi Ä‘Ã£ gá»™p xong vÃ o Database, xÃ³a sáº¡ch Session Ä‘á»ƒ trÃ¡nh gá»™p láº·p láº¡i 
                await _Context.SaveChangesAsync();
                HttpContext.Session.Remove(mySetting.ShopCart);
            }

            // Láº¥y toÃ n bá»™ dá»¯ liá»‡u tá»« Database ra Ä‘á»ƒ hiá»ƒn thá»‹ (bao gá»“m cáº£ cÃ¡c mÃ³n vá»«a Ä‘Æ°á»£c gá»™p)
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

            // TRÆ¯á»œNG Há»¢P 1: CHÆ¯A ÄÄ‚NG NHáº¬P -> THAO TÃC TRÃŠN SESSION
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = shopCart; // Láº¥y List tá»« thuá»™c tÃ­nh shopCart (Session)
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
            // TRÆ¯á»œNG Há»¢P 2: ÄÃƒ ÄÄ‚NG NHáº¬P -> THAO TÃC TRÃŠN DATABASE
            else
            {
                var cartItem = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

                if (cartItem == null)
                {
                    // Kiá»ƒm tra hÃ ng hÃ³a tá»“n táº¡i trÆ°á»›c khi thÃªm vÃ o báº£ng GioHang
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

            // Redirect back to the page the user came from (if available)
            var referer = Request.Headers["Referer"].ToString();
            if (!string.IsNullOrEmpty(referer))
                return Redirect(referer);
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

        [HttpPost]
        public async Task<IActionResult> AddToCartAjax(int id, int quantity = 1)
        {
            var customerId = GetCustomerId();
            bool success = true;

            try {
                if (string.IsNullOrEmpty(customerId))
                {
                    var carlist = shopCart;
                    var item = carlist.SingleOrDefault(p => p.MaHh == id);

                    if (item == null)
                    {
                        var hh = _Context.HangHoas.AsNoTracking().SingleOrDefault(p => p.MaHh == id);
                        if (hh == null) return Json(new { success = false, message = "Sáº£n pháº©m khÃ´ng tá»“n táº¡i" });

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
                else
                {
                    var cartItem = await _Context.GioHangs
                        .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

                    if (cartItem == null)
                    {
                        var exists = await _Context.HangHoas.AnyAsync(p => p.MaHh == id);
                        if (!exists) return Json(new { success = false, message = "Sáº£n pháº©m khÃ´ng tá»“n táº¡i" });

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
            } catch (Exception) {
                success = false;
            }

            int count = 0;
            if (string.IsNullOrEmpty(customerId)) {
                var cartSession = HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart);
                if (cartSession != null) count = cartSession.Sum(c => c.SoLuong);
            } else {
                count = await _Context.GioHangs
                    .Where(g => g.MaKh == customerId)
                    .SumAsync(g => (int?)g.SoLuong) ?? 0;
            }

            return Json(new { success = success, count = count });
        }

        [HttpPost]
        public async Task<IActionResult> DeleteAjax(int id) {
            var customerId = GetCustomerId();
            bool success = true;

            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = shopCart;
                var item = carlist.SingleOrDefault(p => p.MaHh == id);
                if (item != null) {
                    carlist.Remove(item);
                    HttpContext.Session.Set(mySetting.ShopCart, carlist);
                }
            }
            else {
                var itemToRemove = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);
                if (itemToRemove != null) {
                    _Context.GioHangs.Remove(itemToRemove);
                    await _Context.SaveChangesAsync();
                }
            }

            int count = 0;
            if (string.IsNullOrEmpty(customerId)) {
                var cartSession = HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart);
                if (cartSession != null) count = cartSession.Sum(c => c.SoLuong);
            } else {
                count = await _Context.GioHangs
                    .Where(g => g.MaKh == customerId)
                    .SumAsync(g => (int?)g.SoLuong) ?? 0;
            }

            return Json(new { success = success, count = count });
        }

        [HttpPost]
        public async Task<IActionResult> ClearCartAjax() {
            var customerId = GetCustomerId();
            
            if (string.IsNullOrEmpty(customerId))
            {
                HttpContext.Session.Remove(mySetting.ShopCart);
            }
            else {
                var items = _Context.GioHangs.Where(g => g.MaKh == customerId);
                _Context.GioHangs.RemoveRange(items);
                await _Context.SaveChangesAsync();
            }

            return Json(new { success = true, count = 0 });
        }

        // ----------------------------------------------------------------
        // Existing fullâ€‘page reload version (kept for nonâ€‘AJAX fallback)
        // ----------------------------------------------------------------
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
            else {
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
            }
            return RedirectToAction("Index");
        }

        // ----------------------------------------------------------------
        // AJAX version â€“ returns JSON with the new quantity and line total
        // ----------------------------------------------------------------
        [HttpGet]
        public async Task<IActionResult> UpdateQuantityAjax(int id, int delta) {
            var customerId = GetCustomerId();
            int newQty = 0;
            double lineTotal = 0;
            double unitPrice = 0;

            if (string.IsNullOrEmpty(customerId)) {
                var carlist = shopCart;
                var updateItem = carlist.SingleOrDefault(p => p.MaHh == id);
                if (updateItem != null) {
                    updateItem.SoLuong += delta;
                    if (updateItem.SoLuong < 1) updateItem.SoLuong = 1;
                    newQty = updateItem.SoLuong;
                    unitPrice = updateItem.DonGia;
                    lineTotal = unitPrice * newQty;
                    HttpContext.Session.Set(mySetting.ShopCart, carlist);
                }
            } else {
                var item = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);
                if (item != null) {
                    item.SoLuong += delta;
                    if (item.SoLuong < 1) item.SoLuong = 1;
                    await _Context.SaveChangesAsync();
                    newQty = item.SoLuong;
                    // Need price from related HangHoa â€“ fetch it
                    var hh = await _Context.HangHoas
                        .Where(h => h.MaHh == id)
                        .Select(h => h.DonGia ?? 0)
                        .FirstOrDefaultAsync();
                    unitPrice = hh;
                    lineTotal = unitPrice * newQty;
                }
            }

            return Json(new { quantity = newQty, lineTotal = lineTotal, unitPrice = unitPrice });
        }

        // ----------------------------------------------------------------
        // Endpoint to get current cart item count (used by navbar badge)
        // ----------------------------------------------------------------
        [HttpGet]
        public async Task<IActionResult> CartCount() {
            var customerId = GetCustomerId();
            int count = 0;
            if (string.IsNullOrEmpty(customerId)) {
                var cartSession = HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart);
                if (cartSession != null) count = cartSession.Sum(c => c.SoLuong);
            } else {
                count = await _Context.GioHangs
                    .Where(g => g.MaKh == customerId)
                    .SumAsync(g => (int?)g.SoLuong) ?? 0;
            }
            return Json(count);
        }

        // ============================================================
        // GET: /Cart/Check_Out
        // Hiá»ƒn thá»‹ trang checkout - YÃŠU Cáº¦U Ä‘Äƒng nháº­p (khÃ¡ch vÃ£ng lai bá»‹ redirect vá» DangNhap)
        // Load danh sÃ¡ch voucher tá»« DB vÃ o ViewBag
        // ============================================================
        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Check_Out(List<int> selectedIds)
        {
            selectedIds ??= new List<int>();

            var customerId = GetCustomerId();

            // ====== KIá»‚M TRA ÄÄ‚NG NHáº¬P ======
            // KhÃ¡ch vÃ£ng lai chÆ°a Ä‘Äƒng nháº­p â†’ yÃªu cáº§u Ä‘Äƒng nháº­p trÆ°á»›c khi thanh toÃ¡n
            if (string.IsNullOrEmpty(customerId))
            {
                TempData["url"] = "/Cart/Check_Out";
                if (selectedIds != null && selectedIds.Any())
                {
                    TempData["SavedItems"] = string.Join(",", selectedIds);
                }
                return RedirectToAction("DangNhap", "KhachHang");
            }

            // Gá»™p Session vÃ o DB náº¿u cÃ³
            var sessionCart = shopCart;
            if (sessionCart.Any())
            {
                foreach (var item in sessionCart)
                {
                    var dbItem = await _Context.GioHangs
                        .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == item.MaHh);

                    if (dbItem != null)
                    {
                        dbItem.SoLuong += item.SoLuong;
                    }
                    else
                    {
                        _Context.GioHangs.Add(new GioHang
                        {
                            MaKh = customerId,
                            MaHh = item.MaHh,
                            SoLuong = item.SoLuong
                        });
                    }
                }
                await _Context.SaveChangesAsync();
                HttpContext.Session.Remove(mySetting.ShopCart);
            }

            // ÄÃƒ ÄÄ‚NG NHáº¬P: láº¥y giá» hÃ ng tá»« Database
            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            if ((!selectedIds.Any()) && TempData["SavedItems"] != null)
            {
                var savedString = TempData["SavedItems"].ToString();
                selectedIds = savedString.Split(',').Select(int.Parse).ToList();
            }
            if (selectedIds.Any())
            {
                gioHangDb = gioHangDb.Where(g => selectedIds.Contains(g.MaHh)).ToList();
            }
            else
            {
                // Náº¿u khÃ´ng chá»n mÃ³n nÃ o mÃ  báº¥m submit form thÃ¬ báº¯t quay vá» giá» hÃ ng
                return RedirectToAction("Index");
            }
            var cartItems = gioHangDb.Select(g => new CartItem
            {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = g.MaHhNavigation.DonGia ?? 0,
                Hinh = g.MaHhNavigation.Hinh,
                SoLuong = g.SoLuong
            }).ToList();


            // Load danh sÃ¡ch voucher tá»« DB â†’ Ä‘áº©y vÃ o ViewBag Ä‘á»ƒ View render
            ViewBag.Vouchers = await _Context.GiamGias.ToListAsync();

            return View(cartItems);
        }
        // POST: /Cart/PlaceOrder
        // Nhan du lieu tu form checkout, kiem tra hop le, luu vao DB
        // ============================================================
        [HttpPost]
        public async Task<IActionResult> PlaceOrder(
            string HoTen,
            string DiaChi,
            string SoDienThoai,
            string? GhiChu,
            string shipping_method,
            string payment_method,
            int? MaGg,
            List<int>? selectedIds)
        {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId))
            {
                return RedirectToAction("DangNhap", "KhachHang", new { ReturnUrl = "/Cart/Check_Out" });
            }

            selectedIds ??= new List<int>();
            if (!selectedIds.Any())
            {
                TempData["Error"] = "Vui lòng chọn sản phẩm để đặt hàng";
                return RedirectToAction("Index");
            }

            TempData["SavedItems"] = string.Join(",", selectedIds);

            if (string.IsNullOrWhiteSpace(HoTen) || string.IsNullOrWhiteSpace(DiaChi) || string.IsNullOrWhiteSpace(SoDienThoai))
            {
                TempData["Error"] = "Vui lòng điền đầy đủ thông tin nhận hàng";
                return RedirectToAction("Check_Out");
            }

            if (!int.TryParse(SoDienThoai, out var soDienThoai))
            {
                TempData["Error"] = "Số điện thoại không hợp lệ";
                return RedirectToAction("Check_Out");
            }

            var gioHangDb = await _Context.GioHangs
                .Where(g => g.MaKh == customerId && selectedIds.Contains(g.MaHh))
                .Include(g => g.MaHhNavigation)
                .ToListAsync();

            if (!gioHangDb.Any())
            {
                TempData["Error"] = "Giỏ hàng rỗng";
                return RedirectToAction("Check_Out");
            }

            if (gioHangDb.Count != selectedIds.Distinct().Count())
            {
                TempData["Error"] = "Giỏ hàng có sản phẩm không hợp lệ";
                return RedirectToAction("Check_Out");
            }

            var subtotal = gioHangDb.Sum(g => (g.MaHhNavigation.DonGia ?? 0) * g.SoLuong);
            GiamGia? voucher = null;
            if (MaGg.HasValue)
            {
                voucher = await _Context.GiamGias.SingleOrDefaultAsync(x => x.MaGg == MaGg.Value);
                if (voucher == null)
                {
                    TempData["Error"] = "Mã giảm giá không tồn tại";
                    return RedirectToAction("Check_Out");
                }

                var now = DateTime.Now;
                if (!voucher.TrangThai
                    || (voucher.NgayBatDau.HasValue && voucher.NgayBatDau.Value > now)
                    || (voucher.NgayKetThuc.HasValue && voucher.NgayKetThuc.Value < now))
                {
                    TempData["Error"] = "Mã giảm giá đã hết hạn hoặc chưa được kích hoạt";
                    return RedirectToAction("Check_Out");
                }

                if (voucher.GiaTriDonToiThieu.HasValue && subtotal < voucher.GiaTriDonToiThieu.Value)
                {
                    TempData["Error"] = "Đơn hàng chưa đạt giá trị tối thiểu để dùng mã giảm giá";
                    return RedirectToAction("Check_Out");
                }
            }

            string ptVanChuyen;
            double phiVanChuyen;
            switch (shipping_method)
            {
                case "standard":
                    ptVanChuyen = "standard";
                    phiVanChuyen = 2;
                    break;
                case "express":
                    ptVanChuyen = "express";
                    phiVanChuyen = 5;
                    break;
                default:
                    TempData["Error"] = "Phương thức vận chuyển không hợp lệ";
                    return RedirectToAction("Check_Out");
            }

            if (payment_method != "cod")
            {
                TempData["Error"] = "Phương thức thanh toán không hợp lệ";
                return RedirectToAction("Check_Out");
            }

            var nowOrder = DateTime.Now;
            var hoaDon = new HoaDon
            {
                MaKh = customerId,
                NgayDat = nowOrder,
                NgayCan = nowOrder.AddDays(5),
                NgayGiao = nowOrder.AddDays(3),
                HoTen = HoTen,
                DiaChi = DiaChi,
                SoDienThoai = soDienThoai,
                CachThanhToan = payment_method,
                CachVanChuyen = ptVanChuyen,
                PhiVanChuyen = phiVanChuyen,
                MaTrangThai = 1,
                GhiChu = GhiChu,
                ChiTietHds = gioHangDb.Select(g =>
                {
                    var lineTotal = (g.MaHhNavigation.DonGia ?? 0) * g.SoLuong;
                    return new ChiTietHd
                    {
                        MaHh = g.MaHh,
                        SoLuong = g.SoLuong,
                        DonGia = g.MaHhNavigation.DonGia ?? 0,
                        GiamGia = voucher == null ? 0 : lineTotal * voucher.PhanTramGiam / 100,
                        MaGg = voucher?.MaGg
                    };
                }).ToList()
            };

            _Context.HoaDons.Add(hoaDon);
            _Context.GioHangs.RemoveRange(gioHangDb);
            await _Context.SaveChangesAsync();
            TempData.Remove("SavedItems");

            return RedirectToAction("OrderSuccess", new { id = hoaDon.MaHd });
        }
        // GET: /Cart/OrderSuccess?id=42
        public async Task<IActionResult> OrderSuccess(int id)
        {
            var customerId = GetCustomerId();
            var hoaDon = await _Context.HoaDons
                .Include(h => h.ChiTietHds)
                .ThenInclude(c => c.MaHhNavigation)
                .SingleOrDefaultAsync(h => h.MaHd == id && h.MaKh == customerId);

            if (hoaDon == null) return NotFound();

            return View(hoaDon);
        }

        // ============================================================
        // GET: /Cart/OrderHistory
        // ============================================================
        public async Task<IActionResult> OrderHistory()
        {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId))
            {
                return RedirectToAction("DangNhap", "KhachHang", new { ReturnUrl = "/Cart/OrderHistory" });
            }

            var dsHoaDon = await _Context.HoaDons
                .Include(h => h.ChiTietHds)
                .ThenInclude(c => c.MaHhNavigation)
                .Where(h => h.MaKh == customerId)
                .OrderByDescending(h => h.NgayDat)
                .ToListAsync();

            return View(dsHoaDon);
        }        
        }
    }
