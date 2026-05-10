using AutoMapper;
using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class KhachHangController : Controller {
        private readonly Hshop2023Context db;
        private readonly IMapper _mapper;

        public KhachHangController(Hshop2023Context context, IMapper mapper) {
            db = context;
            _mapper = mapper;
        }

        #region Register
        [HttpGet]
        public IActionResult DangKy() {
            return View();
        }

        [HttpPost]
        public IActionResult DangKy(RegisterVM model, IFormFile? Hinh) {
            if (ModelState.IsValid) {
                try {
                    // 1. Kiểm tra tài khoản đã tồn tại chưa để tránh lỗi trùng khóa chính
                    if (db.KhachHangs.Any(kh => kh.MaKh == model.MaKh)) {
                        ModelState.AddModelError("MaKh", "Tên đăng nhập đã tồn tại. Vui lòng chọn tên khác.");
                        return View(model);
                    }

                    var khachHang = _mapper.Map<KhachHang>(model);
                    khachHang.RandomKey = MyUtil.GenerateRandomKey();
                    khachHang.MatKhau = model.MatKhau.ToMd5Hash(khachHang.RandomKey);

                    // Mặc định khi đăng ký mới tài khoản sẽ hoạt động và là quyền User
                    khachHang.HieuLuc = true;
                    khachHang.VaiTro = 0;

                    if (Hinh != null) {
                        khachHang.Hinh = MyUtil.UploadHinh(Hinh, "khachHang");
                    }
                    else {
                        khachHang.Hinh = "Photo.gif"; // Cài ảnh mặc định nếu khách không tải ảnh lên
                    }

                    db.Add(khachHang);
                    db.SaveChanges();

                    TempData["Success"] = "Đăng ký thành công! Vui lòng đăng nhập.";
                    return RedirectToAction("DangNhap", "KhachHang");
                }
                catch (Exception ex) {
                    // Hiển thị lỗi ra UI thay vì để catch trống
                    ModelState.AddModelError(string.Empty, "Đã xảy ra lỗi hệ thống: " + ex.Message);
                }
            }
            return View(model); // Trả về model để không mất dữ liệu đang nhập dở
        }
        #endregion

        #region Login in
        [HttpGet]
        public IActionResult DangNhap(string? ReturnUrl) {
            ViewBag.ReturnUrl = ReturnUrl;
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> DangNhap(LoginVM model, string? ReturnUrl) {
            ViewBag.ReturnUrl = ReturnUrl;
            if (ModelState.IsValid) 
            {
                var captchaResponse = Request.Form["g-recaptcha-response"];
                if (string.IsNullOrEmpty(captchaResponse))
                {
                    ModelState.AddModelError("loi", "Vui lòng xác nhận bạn không phải là robot.");
                    return View(model);
                }

                using (var client = new HttpClient())
                {
                    // Thay bằng Secret Key thật của bạn từ Google Admin Console
                    var secretKey = "6Le8keIsAAAAAETHXhiZSiJjEgKlxLekZwigeg57";
                    var response = await client.PostAsync($"https://www.google.com/recaptcha/api/siteverify?secret={secretKey}&response={captchaResponse}", null);
                    var jsonString = await response.Content.ReadAsStringAsync();

                    // Sử dụng thư viện Newtonsoft.Json đã cài
                    dynamic jsonData = JsonConvert.DeserializeObject(jsonString);

                    if (jsonData.success != "true")
                    {
                        ModelState.AddModelError("loi", "Xác thực robot không hợp lệ.");
                        return View(model);
                    }
                }

                var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == model.UserName);

                if (khachHang == null) {
                    ModelState.AddModelError("loi", "Tài khoản hoặc mật khẩu không đúng.");
                }
                else {
                    // 2. ĐÃ SỬA LỖI LOGIC: Kiểm tra nếu tài khoản KHÔNG có hiệu lực
                    if (!khachHang.HieuLuc) {
                        ModelState.AddModelError("loi", "Tài khoản đã bị khóa. Vui lòng liên hệ hội đồng nhóm QuaMonGroup.");
                    }
                    else {
                        if (khachHang.MatKhau != model.Password.ToMd5Hash(khachHang.RandomKey)) {
                            ModelState.AddModelError("loi", "Tài khoản hoặc mật khẩu không đúng.");
                        }
                        else {
                            // 3. TẠO SESSION ADMIN VÀ USER DỰA TRÊN DATABASE
                            string userRole = khachHang.VaiTro == 1 ? "Admin" : "Customer";

                            // Ghi nhận
                            var claims = new List<Claim>
                            {
                                new Claim(ClaimTypes.Email, khachHang.Email),
                                new Claim(ClaimTypes.Name, khachHang.HoTen),
                                new Claim("CustomerID", khachHang.MaKh),

                                // Claim - role động từ database
                                new Claim(ClaimTypes.Role, userRole)
                            };

                            var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                            var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

                            await HttpContext.SignInAsync(claimsPrincipal);

                            // Kiểm tra đường dẫn và điều hướng
                            if (Url.IsLocalUrl(ReturnUrl)) {
                                return Redirect(ReturnUrl);
                            }
                            else {
                                // Nếu bạn đã xây dựng Khu vực (Area) Admin, bạn có thể điều hướng thẳng Admin vào đó. 
                                // Ví dụ:
                                // if (userRole == "Admin") { return RedirectToAction("Index", "Home", new { area = "Admin" }); }

                                return Redirect("/"); // Chuyển về trang chủ
                            }
                        }
                    }
                }
            }
            return View(model); // Trả về model để khách không phải gõ lại tên đăng nhập
        }
        #endregion

        // GET: Hiển thị thông tin Profile
        [Authorize]
        [HttpGet]
        public IActionResult Profile() {
            // Lấy Mã khách hàng từ Session/Cookie hiện tại
            var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
            if (string.IsNullOrEmpty(customerId)) {
                return RedirectToAction("DangNhap");
            }

            // Tìm thông tin khách hàng trong Database
            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
            if (khachHang == null) {
                return NotFound();
            }

            return View(khachHang);
        }

        // POST: Xử lý khi người dùng bấm nút "Lưu thay đổi"
        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Profile(KhachHang model, IFormFile? fHinh) {
            // Đảm bảo chỉ được sửa tài khoản của chính mình
            var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
            if (customerId != model.MaKh) {
                return BadRequest("Lỗi quyền truy cập.");
            }

            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
            if (khachHang == null) {
                return NotFound();
            }

            try {
                // Cập nhật các thông tin được phép sửa
                khachHang.HoTen = model.HoTen;
                khachHang.Email = model.Email;
                khachHang.DienThoai = model.DienThoai;
                khachHang.DiaChi = model.DiaChi;
                khachHang.NgaySinh = model.NgaySinh;
                khachHang.GioiTinh = model.GioiTinh;

                // Xử lý upload ảnh đại diện (avatar) mới nếu có
                if (fHinh != null && fHinh.Length > 0) {
                    khachHang.Hinh = MyUtil.UploadHinh(fHinh, "khachHang");
                }

                db.Update(khachHang);
                db.SaveChanges();

                TempData["Success"] = "Cập nhật hồ sơ cá nhân thành công!";
                return RedirectToAction("Profile");
            }
            catch (Exception ex) {
                ModelState.AddModelError(string.Empty, "Có lỗi xảy ra: " + ex.Message);
            }

            return View(model);
        }

        [Authorize]
        public async Task<IActionResult> DangXuat() {
            await HttpContext.SignOutAsync();
            return Redirect("/");
        }
    }
}