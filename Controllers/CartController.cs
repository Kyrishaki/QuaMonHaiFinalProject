using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class CartController : Controller
    {
        #region 1. Khởi tạo & Helpers

        // Khởi tạo Database Context
        private readonly Hshop2023Context _Context;

        // Lấy giỏ hàng từ Session. Nếu chưa có thì khởi tạo một List<CartItem> mới rỗng.
        private List<CartItem> ShopCart => HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart) ?? new List<CartItem>();

        public CartController(Hshop2023Context context)
        {
            _Context = context;
        }

        // Hàm hỗ trợ: Lấy ID của khách hàng đang đăng nhập từ hệ thống Claims
        private string GetCustomerId()
        {
            var claim = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")
                     ?? User.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier);

            return claim?.Value ?? string.Empty;
        }

        private async Task MergeSessionCartToDatabase(string customerId)
        {
            var sessionCart = ShopCart;
            if (!sessionCart.Any())
            {
                return;
            }

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

        private async Task<List<GioHang>> GetDatabaseCartItems(string customerId)
        {
            return await _Context.GioHangs
                .Include(g => g.MaHhNavigation)
                .Where(g => g.MaKh == customerId)
                .ToListAsync();
        }

        private static List<CartItem> MapCartItems(IEnumerable<GioHang> gioHangDb)
        {
            return gioHangDb.Select(g => new CartItem
            {
                MaHh = g.MaHh,
                TenHh = g.MaHhNavigation.TenHh,
                DonGia = (double)g.MaHhNavigation.GiaSauGiam,
                Hinh = g.MaHhNavigation.Hinh ?? string.Empty,
                SoLuong = g.SoLuong
            }).ToList();
        }

        #endregion

        #region 2. Hiển thị Giỏ Hàng

        public async Task<IActionResult> Index()
        {
            var customerId = GetCustomerId();

            // Xử lý khi người dùng chưa đăng nhập: Trả về trực tiếp giỏ hàng đang lưu trong Session
            if (string.IsNullOrEmpty(customerId))
            {
                return View(ShopCart);
            }

            // Xử lý khi người dùng đã đăng nhập: Đồng bộ (gộp) dữ liệu từ Session vào Database
            await MergeSessionCartToDatabase(customerId);

            // Truy vấn lấy toàn bộ giỏ hàng của user từ Database (đã bao gồm dữ liệu vừa gộp từ Session)
            var gioHangDb = await GetDatabaseCartItems(customerId);
            var cartItems = MapCartItems(gioHangDb);

            return View(cartItems);
        }

        #endregion

        #region 3. Thao tác Giỏ Hàng (AJAX)

        // Thêm sản phẩm vào giỏ hàng bằng AJAX
        [HttpPost]
        public async Task<IActionResult> AddToCartAjax(int id, int quantity = 1)
        {
            var customerId = GetCustomerId();
            bool success = true;
            string message = "";

            // Kiểm tra sản phẩm có tồn tại trong hệ thống không
            var hh = await _Context.HangHoas.SingleOrDefaultAsync(p => p.MaHh == id);
            if (hh == null) return Json(new { success = false, message = "Sản phẩm không tồn tại" });

            // Kiểm tra số lượng tồn kho của sản phẩm
            if (hh.SoLuong <= 0)
            {
                return Json(new { success = false, message = $"Sản phẩm '{hh.TenHh}' đã hết hàng!" });
            }

            try
            {
                // Xử lý giỏ hàng trên Session (Khi chưa đăng nhập)
                if (string.IsNullOrEmpty(customerId))
                {
                    var carlist = ShopCart;
                    var item = carlist.SingleOrDefault(p => p.MaHh == id);

                    var currentQty = item != null ? item.SoLuong : 0;
                    // Kiểm tra xem tổng số lượng sau khi thêm có vượt quá tồn kho không
                    if (currentQty + quantity > hh.SoLuong)
                    {
                        return Json(new { success = false, message = $"Sản phẩm '{hh.TenHh}' chỉ còn {hh.SoLuong} sản phẩm trong kho. Bạn đang có {currentQty} trong giỏ hàng!" });
                    }

                    if (item == null)
                    {
                        // Thêm mới vào Session
                        carlist.Add(new CartItem
                        {
                            MaHh = id,
                            TenHh = hh.TenHh,
                            DonGia = (double)hh.GiaSauGiam,
                            Hinh = hh.Hinh ?? string.Empty,
                            SoLuong = quantity
                        });
                    }
                    else
                    {
                        // Cộng dồn nếu đã có trong Session
                        item.SoLuong += quantity;
                    }
                    // Cập nhật lại Session
                    HttpContext.Session.Set(mySetting.ShopCart, carlist);
                }
                // Xử lý giỏ hàng trên Database (Khi đã đăng nhập)
                else
                {
                    var cartItem = await _Context.GioHangs
                        .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);

                    var currentQty = cartItem != null ? cartItem.SoLuong : 0;
                    // Kiểm tra tồn kho trước khi lưu DB
                    if (currentQty + quantity > hh.SoLuong)
                    {
                        return Json(new { success = false, message = $"Sản phẩm '{hh.TenHh}' chỉ còn {hh.SoLuong} sản phẩm trong kho. Bạn đang có {currentQty} trong giỏ hàng!" });
                    }

                    if (cartItem == null)
                    {
                        // Thêm mới bản ghi vào DB
                        _Context.GioHangs.Add(new GioHang
                        {
                            MaKh = customerId,
                            MaHh = id,
                            SoLuong = quantity
                        });
                    }
                    else
                    {
                        // Cập nhật số lượng trong DB
                        cartItem.SoLuong += quantity;
                    }
                    await _Context.SaveChangesAsync();
                }
            }
            catch (Exception ex)
            {
                success = false;
                message = ex.Message;
            }

            // Lấy lại tổng số lượng giỏ hàng để cập nhật hiển thị (ví dụ: icon giỏ hàng trên header)
            int count = await GetCartTotalQuantity(customerId);
            return Json(new { success, count, message });
        }

        // Xóa một sản phẩm khỏi giỏ hàng bằng AJAX
        [HttpPost]
        public async Task<IActionResult> DeleteAjax(int id)
        {
            var customerId = GetCustomerId();

            // Xóa khỏi Session (chưa đăng nhập)
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = ShopCart;
                var item = carlist.SingleOrDefault(p => p.MaHh == id);
                if (item != null)
                {
                    carlist.Remove(item);
                    HttpContext.Session.Set(mySetting.ShopCart, carlist);
                }
            }
            // Xóa khỏi Database (đã đăng nhập)
            else
            {
                var itemToRemove = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);
                if (itemToRemove != null)
                {
                    _Context.GioHangs.Remove(itemToRemove);
                    await _Context.SaveChangesAsync();
                }
            }

            int count = await GetCartTotalQuantity(customerId);
            return Json(new { success = true, count = count });
        }

        // Làm sạch toàn bộ giỏ hàng bằng AJAX
        [HttpPost]
        public async Task<IActionResult> ClearCartAjax()
        {
            var customerId = GetCustomerId();

            // Xóa Session
            if (string.IsNullOrEmpty(customerId))
            {
                HttpContext.Session.Remove(mySetting.ShopCart);
            }
            // Xóa Database
            else
            {
                var items = _Context.GioHangs.Where(g => g.MaKh == customerId);
                _Context.GioHangs.RemoveRange(items);
                await _Context.SaveChangesAsync();
            }

            return Json(new { success = true, count = 0 });
        }

        // Cập nhật số lượng (+ hoặc -) của một sản phẩm trong giỏ hàng
        [HttpGet]
        public async Task<IActionResult> UpdateQuantityAjax(int id, int delta)
        {
            var customerId = GetCustomerId();
            int newQty = 0;
            double lineTotal = 0;
            bool success = true;
            string message = "";

            var hh = await _Context.HangHoas.SingleOrDefaultAsync(h => h.MaHh == id);
            if (hh == null) return Json(new { success = false, message = "Sản phẩm không tồn tại!" });

            // Xử lý cập nhật trên Session
            if (string.IsNullOrEmpty(customerId))
            {
                var carlist = ShopCart;
                var updateItem = carlist.SingleOrDefault(p => p.MaHh == id);
                if (updateItem != null)
                {
                    var targetQty = updateItem.SoLuong + delta;
                    if (targetQty < 1) targetQty = 1; // Đảm bảo số lượng tối thiểu là 1

                    if (targetQty > hh.SoLuong)
                    {
                        success = false;
                        message = $"Không thể tăng thêm. Sản phẩm '{hh.TenHh}' chỉ còn {hh.SoLuong} sản phẩm trong kho.";
                        // Giữ nguyên số lượng cũ nếu vượt tồn kho
                        newQty = updateItem.SoLuong;
                        updateItem.DonGia = (double)hh.GiaSauGiam;
                        lineTotal = updateItem.DonGia * newQty;
                    }
                    else
                    {
                        // Cập nhật số lượng mới và lưu Session
                        updateItem.SoLuong = targetQty;
                        newQty = updateItem.SoLuong;
                        updateItem.DonGia = (double)hh.GiaSauGiam;
                        lineTotal = updateItem.DonGia * newQty;
                        HttpContext.Session.Set(mySetting.ShopCart, carlist);
                    }
                }
            }
            // Xử lý cập nhật trên Database
            else
            {
                var item = await _Context.GioHangs
                    .SingleOrDefaultAsync(g => g.MaKh == customerId && g.MaHh == id);
                if (item != null)
                {
                    var targetQty = item.SoLuong + delta;
                    if (targetQty < 1) targetQty = 1; // Đảm bảo số lượng tối thiểu là 1

                    if (targetQty > hh.SoLuong)
                    {
                        success = false;
                        message = $"Không thể tăng thêm. Sản phẩm '{hh.TenHh}' chỉ còn {hh.SoLuong} sản phẩm trong kho.";
                        // Giữ nguyên số lượng cũ nếu vượt tồn kho
                        newQty = item.SoLuong;
                        lineTotal = (double)hh.GiaSauGiam * newQty;
                    }
                    else
                    {
                        // Cập nhật số lượng mới và lưu DB
                        item.SoLuong = targetQty;
                        await _Context.SaveChangesAsync();
                        newQty = item.SoLuong;
                        lineTotal = (double)hh.GiaSauGiam * newQty;
                    }
                }
            }

            // Trả về JSON chứa thông tin tính toán lại để Front-end tự render lại giá
            int count = await GetCartTotalQuantity(customerId);
            return Json(new { success, message, quantity = newQty, lineTotal, count });
        }

        // Hàm hỗ trợ nội bộ: Tính tổng số lượng dựa trên việc đang dùng Session hay Database
        private async Task<int> GetCartTotalQuantity(string customerId)
        {
            if (string.IsNullOrEmpty(customerId))
            {
                var cartSession = HttpContext.Session.Get<List<CartItem>>(mySetting.ShopCart);
                return cartSession != null ? cartSession.Sum(c => c.SoLuong) : 0;
            }

            return await _Context.GioHangs
                .Where(g => g.MaKh == customerId)
                .SumAsync(g => (int?)g.SoLuong) ?? 0;
        }

        #endregion

        #region 4. Thanh Toán (Check_Out & PlaceOrder)

        // Hiển thị trang thanh toán và danh sách sản phẩm chuẩn bị mua
        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> Check_Out(List<int> selectedIds)
        {
            selectedIds ??= new List<int>();
            var customerId = GetCustomerId();

            // Yêu cầu đăng nhập trước khi tiến hành thanh toán
            if (string.IsNullOrEmpty(customerId))
            {
                TempData["url"] = "/Cart/Check_Out";
                // Lưu lại các sản phẩm khách đã tick chọn để sau khi đăng nhập xong không bị mất
                if (selectedIds.Any())
                {
                    TempData["SavedItems"] = string.Join(",", selectedIds);
                }
                return RedirectToAction("Login", "Customer", new { ReturnUrl = "/Cart/Check_Out" });
            }

            // Tiến hành gộp Session vào Database nếu có (đảm bảo dữ liệu giỏ hàng chuẩn nhất)
            await MergeSessionCartToDatabase(customerId);

            // Lấy toàn bộ dữ liệu giỏ hàng từ DB
            var gioHangDb = await GetDatabaseCartItems(customerId);

            // Phục hồi lại các item đã tick chọn nếu người dùng vừa bị redirect đi đăng nhập và quay lại
            if ((!selectedIds.Any()) && TempData["SavedItems"] != null)
            {
                var savedString = TempData["SavedItems"] as string;
                if (!string.IsNullOrEmpty(savedString))
                    selectedIds = savedString.Split(',').Select(int.Parse).ToList();
            }

            // Lọc ra đúng các sản phẩm mà người dùng tick chọn mua
            if (selectedIds.Any())
            {
                gioHangDb = gioHangDb.Where(g => selectedIds.Contains(g.MaHh)).ToList();
            }
            else
            {
                // Nếu truy cập thẳng trang Check_Out mà không chọn gì thì đuổi về trang Index
                return RedirectToAction("Index");
            }

            // Map qua DTO hiển thị
            var cartItems = MapCartItems(gioHangDb);

            // Tính tổng tiền và tìm các Voucher thỏa mãn điều kiện áp dụng
            var subtotal = cartItems.Sum(item => item.DonGia * item.SoLuong);
            var now = DateTime.Now;
            ViewBag.Vouchers = await _Context.GiamGias
                .Where(v => v.TrangThai
                    && (v.NgayBatDau <= now)
                    && (v.NgayKetThuc >= now)
                    && (subtotal >= v.GiaTriDonToiThieu))
                .ToListAsync();

            // Lấy thông tin khách hàng để tự động điền sẵn form thanh toán (Tên, SDT, Địa chỉ)
            var customer = await _Context.KhachHangs.SingleOrDefaultAsync(kh => kh.MaKh == customerId);
            ViewBag.Customer = customer;

            return View(cartItems);
        }

        // Xử lý lưu đơn hàng vào hệ thống
        [HttpPost]
        public async Task<IActionResult> PlaceOrder(
            string HoTen, string DiaChi, string SoDienThoai, string? GhiChu,
            string shipping_method, string payment_method, int? MaGg, List<int>? selectedIds)
        {
            var customerId = GetCustomerId();
            // Xác thực trạng thái đăng nhập lần cuối
            if (string.IsNullOrEmpty(customerId))
            {
                TempData["Error"] = "Vui lòng đăng nhập để đặt hàng.";
                return RedirectToAction("Login", "Customer", new { ReturnUrl = "/Cart/Check_Out" });
            }

            selectedIds ??= new List<int>();
            if (!selectedIds.Any())
            {
                TempData["Error"] = "Vui lòng chọn sản phẩm để đặt hàng";
                return RedirectToAction("Index");
            }

            // Lưu dự phòng danh sách đang chọn
            TempData["SavedItems"] = string.Join(",", selectedIds);

            // Kiểm tra tính hợp lệ của Form thông tin giao hàng
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

            // Lấy các mặt hàng cần thanh toán từ database để đảm bảo tính toàn vẹn (không tin tưởng hoàn toàn dữ liệu từ client)
            var gioHangDb = await _Context.GioHangs
                .Where(g => g.MaKh == customerId && selectedIds.Contains(g.MaHh))
                .Include(g => g.MaHhNavigation)
                .ToListAsync();

            if (!gioHangDb.Any())
            {
                TempData["Error"] = "Giỏ hàng rỗng";
                return RedirectToAction("Check_Out");
            }

            // Kiểm tra xem số lượng ID submit lên có khớp với số bản ghi truy vấn ra được không (tránh ID rác)
            if (gioHangDb.Count != selectedIds.Distinct().Count())
            {
                TempData["Error"] = "Giỏ hàng có sản phẩm không hợp lệ";
                return RedirectToAction("Check_Out");
            }

            // Kéo kiểm tra lại tồn kho ngay trước lúc chốt đơn
            foreach (var item in gioHangDb)
            {
                if (item.SoLuong > item.MaHhNavigation.SoLuong)
                {
                    TempData["Error"] = $"Sản phẩm '{item.MaHhNavigation.TenHh}' chỉ còn {item.MaHhNavigation.SoLuong} sản phẩm trong kho. Vui lòng cập nhật lại giỏ hàng!";
                    return RedirectToAction("Check_Out");
                }
            }

            var subtotal = gioHangDb.Sum(g => (double)g.MaHhNavigation.GiaSauGiam * g.SoLuong);
            GiamGia? voucher = null;

            // Xử lý xác thực Mã Giảm Giá
            if (MaGg.HasValue)
            {
                voucher = await _Context.GiamGias.SingleOrDefaultAsync(x => x.MaGg == MaGg.Value);
                if (voucher == null)
                {
                    TempData["Error"] = "Mã giảm giá không tồn tại";
                    return RedirectToAction("Check_Out");
                }

                var now = DateTime.Now;
                if (!voucher.TrangThai|| (voucher.NgayBatDau > now)|| (voucher.NgayKetThuc < now))
                {
                    TempData["Error"] = "Mã giảm giá đã hết hạn hoặc chưa được kích hoạt";
                    return RedirectToAction("Check_Out");
                }

                if (subtotal < voucher.GiaTriDonToiThieu)
                {
                    TempData["Error"] = "Đơn hàng chưa đạt giá trị tối thiểu để dùng mã giảm giá";
                    return RedirectToAction("Check_Out");
                }
            }

            // Tính toán chi phí vận chuyển
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

            // Kiểm tra phương thức thanh toán
            if (payment_method != "cod")
            {
                TempData["Error"] = "Phương thức thanh toán không hợp lệ";
                return RedirectToAction("Check_Out");
            }

            // Tiến hành khởi tạo Đối tượng Hóa Đơn (Order)
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
                MaTrangThai = 0,
                GhiChu = GhiChu,
                // Tạo chi tiết Hóa đơn (Order Details) đi kèm
                ChiTietHds = gioHangDb.Select(g =>
                {
                    var lineTotal = (double)g.MaHhNavigation.GiaSauGiam * g.SoLuong;
                    return new ChiTietHd
                    {
                        MaHh = g.MaHh,
                        SoLuong = g.SoLuong,
                        DonGia = (double)g.MaHhNavigation.GiaSauGiam,
                        // Áp dụng tính phần giảm giá cho từng mặt hàng (nếu có voucher)
                        GiamGia = voucher == null ? 0 : lineTotal * voucher.PhanTramGiam / 100,
                        MaGg = voucher?.MaGg
                    };
                }).ToList()
            };

            // Trừ số lượng tồn kho trong database
            foreach (var item in gioHangDb)
            {
                item.MaHhNavigation.SoLuong -= item.SoLuong;
                _Context.HangHoas.Update(item.MaHhNavigation);
            }
            // Cập nhật số lần sử dụng của voucher (nếu có)
            if (voucher != null)
            {
                voucher.SoLanSuDung -= 1;

                if (voucher.SoLanSuDung <= 0)
                {
                    voucher.SoLanSuDung = 0;
                    voucher.TrangThai = false;
                }
            }

            // Lưu Hóa Đơn và Xóa các sản phẩm đã mua khỏi giỏ hàng DB
            _Context.HoaDons.Add(hoaDon);
            _Context.GioHangs.RemoveRange(gioHangDb);
            await _Context.SaveChangesAsync();

            // Hủy trạng thái lưu chọn các mặt hàng vừa thanh toán thành công
            TempData.Remove("SavedItems");

            return RedirectToAction("OrderSuccess", new { id = hoaDon.MaHd });
        }

        #endregion

        #region 5. Quản Lý Đơn Hàng

        // Trang thông báo đặt hàng thành công
        public async Task<IActionResult> OrderSuccess(int id)
        {
            var customerId = GetCustomerId();
            // Lấy thông tin hóa đơn vừa tạo để hiển thị tóm tắt lại cho khách
            var hoaDon = await _Context.HoaDons
                .Include(h => h.ChiTietHds)
                .ThenInclude(c => c.MaHhNavigation)
                .SingleOrDefaultAsync(h => h.MaHd == id && h.MaKh == customerId);

            if (hoaDon == null) return NotFound();

            return View(hoaDon);
        }

        // Lịch sử mua hàng của khách hàng
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

            // Tìm kiếm đơn hàng theo mã đơn hoặc tên người nhận
            if (!string.IsNullOrEmpty(searchQuery))
            {
                query = query.Where(h => (h.HoTen != null && h.HoTen.Contains(searchQuery)) ||
                                         h.MaHd.ToString() == searchQuery);
            }

            // Lọc theo trạng thái của đơn hàng
            if (statusId.HasValue)
            {
                query = query.Where(h => h.MaTrangThai == statusId.Value);
            }

            // Sắp xếp đơn hàng mới nhất lên trên
            var dsHoaDon = await query.OrderByDescending(h => h.NgayDat).ToListAsync();
            return View(dsHoaDon);
        }

        #endregion
    }
}
