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
                        if (hh == null) return Json(new { success = false, message = "Sản phẩm không tồn tại" });

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
                        if (!exists) return Json(new { success = false, message = "Sản phẩm không tồn tại" });

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
        // Existing full‑page reload version (kept for non‑AJAX fallback)
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
        // AJAX version – returns JSON with the new quantity and line total
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
                    // Need price from related HangHoa – fetch it
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
        // Hiển thị trang checkout - YÊU CẦU đăng nhập (khách vãng lai bị redirect về DangNhap)
        // Load danh sách voucher từ DB vào ViewBag
        // ============================================================
        public async Task<IActionResult> Check_Out(List<int> selected)
        {
            var customerId = GetCustomerId();

            // ====== KIỂM TRA ĐĂNG NHẬP ======
            // Khách vãng lai chưa đăng nhập → yêu cầu đăng nhập trước khi thanh toán
            if (string.IsNullOrEmpty(customerId))
            {
                TempData["Info"] = "Vui lòng đăng nhập để tiến hành thanh toán.";
                string queryString = Request.QueryString.ToString();
                return RedirectToAction("Login", "Customer", new { ReturnUrl = "/Cart/Check_Out" + queryString });
            }

            // Gộp Session vào DB nếu có
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

            // ĐÃ ĐĂNG NHẬP: lấy giỏ hàng từ Database
            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            if (selected != null && selected.Any())
            {
                gioHangDb = gioHangDb.Where(g => selected.Contains(g.MaHh)).ToList();
            }

            var cartItems = gioHangDb.Select(g => new CartItem
            {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = g.MaHhNavigation.DonGia ?? 0,
                Hinh = g.MaHhNavigation.Hinh,
                SoLuong = g.SoLuong
            }).ToList();

            // Giỏ hàng trống → quay về trang giỏ hàng
            if (!cartItems.Any())
            {
                return RedirectToAction("Index");
            }

            // Load danh sách voucher từ DB → đẩy vào ViewBag để View render
            ViewBag.Vouchers = await _Context.GiamGias.ToListAsync();

            return View(cartItems);
        }

        // ============================================================
        // POST: /Cart/PlaceOrder
        // Nhận dữ liệu từ form checkout, kiểm tra hợp lệ, lưu vào DB
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
            List<int> selected)
        {
            var customerId = GetCustomerId();

            // ====== BƯỚC 1: Kiểm tra đăng nhập ======
            // MaKh là FK tham chiếu đến bảng KhachHang → bắt buộc phải đăng nhập
            if (string.IsNullOrEmpty(customerId))
            {
                TempData["Error"] = "Vui lòng đăng nhập để đặt hàng.";
                return RedirectToAction("Login", "Customer", new { ReturnUrl = "/Cart/Check_Out" });
            }

            // ====== BƯỚC 2: Lấy giỏ hàng từ DB ======
            var gioHangDb = await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();

            if (selected != null && selected.Any())
            {
                gioHangDb = gioHangDb.Where(g => selected.Contains(g.MaHh)).ToList();
            }

            var cartItems = gioHangDb.Select(g => new CartItem
            {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = g.MaHhNavigation.DonGia ?? 0,
                Hinh = g.MaHhNavigation.Hinh,
                SoLuong = g.SoLuong
            }).ToList();

            // ====== BƯỚC 2: Kiểm tra tính hợp lệ ======
            if (!cartItems.Any())
            {
                TempData["Error"] = "Giỏ hàng trống, không thể đặt hàng.";
                return RedirectToAction("Index");
            }

            if (string.IsNullOrWhiteSpace(HoTen) || string.IsNullOrWhiteSpace(DiaChi) || string.IsNullOrWhiteSpace(SoDienThoai))
            {
                TempData["Error"] = "Vui lòng nhập đầy đủ thông tin (Họ tên, Địa chỉ, Số điện thoại).";
                TempData["HoTen"] = HoTen;
                TempData["DiaChi"] = DiaChi;
                TempData["SoDienThoai"] = SoDienThoai;
                ViewBag.Vouchers = await _Context.GiamGias.ToListAsync();
                return View("Check_Out", cartItems);
            }

            // Nối số điện thoại vào địa chỉ
            string diaChiGiaoHang = $"{DiaChi} - SĐT: {SoDienThoai}";

            // ====== BƯỚC 3: Xử lý voucher (nếu có) ======
            double phanTramGiam = 0;
            GiamGia? voucher = null;

            if (MaGg.HasValue && MaGg.Value > 0)
            {
                voucher = await _Context.GiamGias.FindAsync(MaGg.Value);
                if (voucher != null)
                {
                    bool isValid = true;
                    if (!voucher.TrangThai) isValid = false;
                    if (voucher.NgayBatDau.HasValue && voucher.NgayBatDau.Value > DateTime.Now) isValid = false;
                    if (voucher.NgayKetThuc.HasValue && voucher.NgayKetThuc.Value < DateTime.Now) isValid = false;
                    
                    double tongTienHang = cartItems.Sum(c => c.DonGia * c.SoLuong);
                    if (voucher.GiaTriDonToiThieu.HasValue && tongTienHang < voucher.GiaTriDonToiThieu.Value) isValid = false;
                    if (voucher.SoLanSuDung.HasValue && voucher.SoLanSuDung.Value <= 0) isValid = false;

                    if (isValid)
                    {
                        phanTramGiam = voucher.PhanTramGiam;
                        if (voucher.SoLanSuDung.HasValue) voucher.SoLanSuDung -= 1;
                    }
                    else
                    {
                        TempData["Error"] = "Voucher không hợp lệ, chưa đến hạn, hết hạn hoặc không đủ điều kiện.";
                        TempData["HoTen"] = HoTen;
                        TempData["DiaChi"] = DiaChi;
                        TempData["SoDienThoai"] = SoDienThoai;
                        ViewBag.Vouchers = await _Context.GiamGias.ToListAsync();
                        return View("Check_Out", cartItems);
                    }
                }
            }

            // ====== BƯỚC 4: Tính phí vận chuyển ======
            double phiVanChuyen = shipping_method switch
            {
                "express" => 20,
                "economy" => 0,
                _ => 5  // "standard" hoặc mặc định
            };

            // ====== BƯỚC 5: Tạo Hóa Đơn ======
            var hoaDon = new HoaDon
            {
                MaKh = customerId,
                NgayDat = DateTime.Now,
                NgayCan = DateTime.Now.AddDays(3),
                NgayGiao = DateTime.Now.AddDays(10),
                HoTen = HoTen,
                DiaChi = diaChiGiaoHang,
                CachThanhToan = payment_method ?? "cod",
                CachVanChuyen = shipping_method ?? "standard",
                PhiVanChuyen = phiVanChuyen,
                MaTrangThai = 0,    // 0 = Mới đặt
                GhiChu = GhiChu
            };

            _Context.HoaDons.Add(hoaDon);
            await _Context.SaveChangesAsync(); // Sau đây hoaDon.MaHd sẽ có giá trị

            // ====== BƯỚC 7: Tạo Chi Tiết Hóa Đơn ======
            foreach (var item in cartItems)
            {
                double giamGiaMonNay = item.DonGia * (phanTramGiam / 100);

                var chiTiet = new ChiTietHd
                {
                    MaHd = hoaDon.MaHd,
                    MaHh = item.MaHh,
                    DonGia = item.DonGia,
                    SoLuong = item.SoLuong,
                    GiamGia = giamGiaMonNay,
                    MaGg = voucher != null ? MaGg : null
                };

                _Context.ChiTietHds.Add(chiTiet);
            }
            await _Context.SaveChangesAsync();

            // ====== BƯỚC 8: Xóa giỏ hàng sau khi đặt thành công ======
            if (!string.IsNullOrEmpty(customerId))
            {
                // Chỉ xóa các sản phẩm đã thanh toán
                var gioHangCanXoa = _Context.GioHangs.Where(g => g.MaKh == customerId && selected.Contains(g.MaHh));
                _Context.GioHangs.RemoveRange(gioHangCanXoa);
                await _Context.SaveChangesAsync();
            }

            // Xóa giỏ hàng trong Session
            HttpContext.Session.Remove(mySetting.ShopCart);

            // ====== BƯỚC 9: Chuyển sang trang thành công ======
            return RedirectToAction("OrderSuccess", new { id = hoaDon.MaHd });
        }

        // ============================================================
        // GET: /Cart/OrderSuccess?id=42
        // Hiển thị thông báo đặt hàng thành công
        // ============================================================
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
        public async Task<IActionResult> OrderHistory(string searchQuery, int? statusId)
        {
            var customerId = GetCustomerId();
            if (string.IsNullOrEmpty(customerId))
            {
                return RedirectToAction("Login", "Customer", new { ReturnUrl = "/Cart/OrderHistory" });
            }

            ViewBag.SearchQuery = searchQuery;
            ViewBag.StatusId = statusId;

            var query = _Context.HoaDons
                .Include(h => h.ChiTietHds)
                .ThenInclude(c => c.MaHhNavigation)
                .Where(h => h.MaKh == customerId)
                .AsQueryable();

            if (!string.IsNullOrEmpty(searchQuery))
            {
                query = query.Where(h => (h.HoTen != null && h.HoTen.Contains(searchQuery)) || 
                                         h.MaHd.ToString() == searchQuery);
            }

            if (statusId.HasValue)
            {
                query = query.Where(h => h.MaTrangThai == statusId.Value);
            }

            var dsHoaDon = await query.OrderByDescending(h => h.NgayDat).ToListAsync();
            return View(dsHoaDon);
        }

        // ============================================================
        // GET: /Cart/LookupOrder
        // ============================================================
        [HttpGet]
        public async Task<IActionResult> LookupOrder(int? orderId)
        {
            ViewBag.OrderId = orderId;
            if (orderId.HasValue)
            {
                var order = await _Context.HoaDons
                    .Include(h => h.MaKhNavigation)
                    .Include(h => h.ChiTietHds)
                    .ThenInclude(c => c.MaHhNavigation)
                    .FirstOrDefaultAsync(h => h.MaHd == orderId.Value);

                if (order == null)
                {
                    ViewBag.ErrorMessage = "Không tìm thấy đơn hàng với mã số này. Vui lòng kiểm tra lại.";
                }
                else
                {
                    return View(order);
                }
            }
            return View();
        }
        
    }
}
