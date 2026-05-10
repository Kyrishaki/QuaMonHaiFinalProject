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
using System.Net;
using System.Net.Mail;
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
            // 1. Lấy mã thực tế đã gửi từ Session
            var sessionCode = HttpContext.Session.GetString("EmailVerifyCode");

            // 2. So sánh mã người dùng nhập với mã trong Session
            if (string.IsNullOrEmpty(sessionCode) || model.VerificationCode != sessionCode) {
                // Thêm lỗi vào ModelState để hiển thị ra View
                ModelState.AddModelError("VerificationCode", "Mã xác thực không chính xác hoặc đã hết hạn.");
            }

            // 3. Chỉ khi mọi thứ hợp lệ (bao gồm cả mã OTP) thì mới lưu vào DB
            if (ModelState.IsValid) {
                try {
                    // Kiểm tra trùng MaKh
                    if (db.KhachHangs.Any(kh => kh.MaKh == model.MaKh)) {
                        ModelState.AddModelError("MaKh", "Tên đăng nhập đã tồn tại.");
                        return View(model);
                    }

                    // Tiến hành Map các thông tin cơ bản từ View Model sang Entity
                    var khachHang = _mapper.Map<KhachHang>(model);

                    // ==========================================
                    // BẮT ĐẦU: XỬ LÝ MẬT KHẨU, HÌNH ẢNH & KÍCH HOẠT
                    // ==========================================

                    // 1. Tạo RandomKey (Mã bảo vệ phụ)
                    khachHang.RandomKey = MyUtil.GenerateRandomKey();

                    // 2. Mã hóa mật khẩu người dùng nhập vào kết hợp với RandomKey
                    khachHang.MatKhau = model.MatKhau.ToMd5Hash(khachHang.RandomKey);

                    // 3. Gán các giá trị mặc định hệ thống
                    khachHang.HieuLuc = true; // Kích hoạt tài khoản ngay lập tức
                    khachHang.VaiTro = 0;     // Phân quyền mặc định là Khách hàng (0: Khách, 1: Admin)

                    // 4. Xử lý upload ảnh đại diện (nếu có)
                    if (Hinh != null && Hinh.Length > 0) {
                        khachHang.Hinh = MyUtil.UploadHinh(Hinh, "KhachHang");
                    }
                    else {
                        // Gán một ảnh avatar mặc định nếu người dùng không tải ảnh lên
                        khachHang.Hinh = "default-avatar.jpg";
                    }

                    // ==========================================
                    // KẾT THÚC XỬ LÝ
                    // ==========================================

                    db.Add(khachHang);
                    db.SaveChanges();

                    TempData["Success"] = "Đăng ký thành công!";
                    return RedirectToAction("DangNhap", "KhachHang");
                }
                catch (Exception ex) {
                    ModelState.AddModelError(string.Empty, "Lỗi hệ thống: " + ex.Message);
                }
            }

            // Nếu có lỗi (sai OTP hoặc thiếu dữ liệu), trả về View cùng model để hiện thông báo lỗi
            return View(model);
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
            if (ModelState.IsValid) {
                var captchaResponse = Request.Form["g-recaptcha-response"];
                if (string.IsNullOrEmpty(captchaResponse)) {
                    ModelState.AddModelError("loi", "Vui lòng xác nhận bạn không phải là robot.");
                    return View(model);
                }

                using (var client = new HttpClient()) {
                    // Thay bằng Secret Key thật của bạn từ Google Admin Console
                    var secretKey = "6Le0Z-MsAAAAABmtR4FCdgxg4GekC-nY9L_4Tdob";
                    var response = await client.PostAsync($"https://www.google.com/recaptcha/api/siteverify?secret={secretKey}&response={captchaResponse}", null);
                    var jsonString = await response.Content.ReadAsStringAsync();

                    // Sử dụng thư viện Newtonsoft.Json đã cài
                    dynamic jsonData = JsonConvert.DeserializeObject(jsonString);

                    if (jsonData.success != "true") {
                        ModelState.AddModelError("loi", "Xác thực robot không hợp lệ.");
                        return View(model);
                    }
                }

                var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == model.UserName);

                if (khachHang == null) {
                    ModelState.AddModelError("loi", "Tài khoản hoặc mật khẩu không đúng.");
                }
                else {
                    // Kiểm tra nếu tài khoản KHÔNG có hiệu lực
                    if (!khachHang.HieuLuc) {
                        ModelState.AddModelError("loi", "Tài khoản đã bị khóa. Vui lòng liên hệ hội đồng nhóm QuaMonGroup.");
                    }
                    else {
                        if (khachHang.MatKhau != model.Password.ToMd5Hash(khachHang.RandomKey)) {
                            ModelState.AddModelError("loi", "Tài khoản hoặc mật khẩu không đúng.");
                        }
                        else {
                            // TẠO SESSION ADMIN VÀ USER DỰA TRÊN DATABASE
                            string userRole = khachHang.VaiTro == 1 ? "Admin" : "Customer";

                            // Ghi nhận
                            var claims = new List<Claim>
                            {
                                new Claim(ClaimTypes.Email, khachHang.Email ?? ""),
                                new Claim(ClaimTypes.Name, khachHang.HoTen ?? ""),
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
                    khachHang.Hinh = MyUtil.UploadHinh(fHinh, "KhachHang");
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

        // ===============================================
        // BẮT ĐẦU: KHU VỰC XỬ LÝ ĐỔI MẬT KHẨU
        // ===============================================

        [Authorize]
        [HttpGet]
        public IActionResult DoiMatKhau() {
            return View();
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult DoiMatKhau(ChangePasswordVM model) {
            if (!ModelState.IsValid) {
                return View(model);
            }

            var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
            if (string.IsNullOrEmpty(customerId)) {
                return RedirectToAction("DangNhap");
            }

            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
            if (khachHang == null) {
                return NotFound();
            }

            // Kiểm tra mật khẩu hiện tại
            var hashedOldPassword = model.OldPassword.ToMd5Hash(khachHang.RandomKey);
            if (khachHang.MatKhau != hashedOldPassword) {
                ModelState.AddModelError("OldPassword", "Mật khẩu hiện tại không chính xác.");
                return View(model);
            }

            // Kiểm tra xem mật khẩu mới có trùng với mật khẩu cũ không
            if (model.OldPassword == model.NewPassword) {
                ModelState.AddModelError("NewPassword", "Mật khẩu mới không được trùng với mật khẩu hiện tại.");
                return View(model);
            }

            try {
                // Mã hóa mật khẩu mới và lưu lại
                khachHang.MatKhau = model.NewPassword.ToMd5Hash(khachHang.RandomKey);

                db.Update(khachHang);
                db.SaveChanges();

                TempData["Success"] = "Đổi mật khẩu thành công!";
                return RedirectToAction("Profile");
            }
            catch (Exception ex) {
                ModelState.AddModelError(string.Empty, "Có lỗi xảy ra trong quá trình đổi mật khẩu: " + ex.Message);
                return View(model);
            }
        }

        // ===============================================
        // KẾT THÚC: KHU VỰC XỬ LÝ ĐỔI MẬT KHẨU
        // ===============================================

        [Authorize]
        public async Task<IActionResult> DangXuat() {
            await HttpContext.SignOutAsync();
            return Redirect("/");
        }

        [HttpPost]
        public async Task<IActionResult> SendVerificationCode(string email) {
            try {
                if (string.IsNullOrEmpty(email)) return Json(new { success = false, message = "Email trống!" });

                // 1. Tạo mã xác nhận và lưu vào Session
                string otpCode = new Random().Next(100000, 999999).ToString();
                HttpContext.Session.SetString("EmailVerifyCode", otpCode);

                // 2. Tạo đối tượng MimeMessage (Để sửa lỗi 'string to MimeMessage')
                var message = new MimeKit.MimeMessage();
                message.From.Add(new MimeKit.MailboxAddress("HShop", "trathanhclassic123@gmail.com"));
                message.To.Add(new MimeKit.MailboxAddress("", email));
                message.Subject = "Mã xác thực đăng ký tài khoản";

                // Nội dung Email
                message.Body = new MimeKit.TextPart("html") {
                    Text = $"<h3>Mã xác thực của bạn là: <b style='color:red'>{otpCode}</b></h3>"
                };

                // 3. Gửi Mail bằng SmtpClient của MailKit
                using (var client = new MailKit.Net.Smtp.SmtpClient()) {
                    // 1. Kết nối với TLS bảo mật
                    await client.ConnectAsync("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);

                    // 2. Đăng nhập bằng App Password (16 ký tự viết liền)
                    // THAY EMAIL VÀ MẬT KHẨU THẬT CỦA BẠN VÀO ĐÂY
                    await client.AuthenticateAsync("trathanhclassic123@gmail.com", "sgpyhcoqqcpeziyj");

                    // 3. Gửi đối tượng message (đảm bảo message.From cũng là email trên)
                    await client.SendAsync(message);

                    await client.DisconnectAsync(true);
                }

                return Json(new { success = true });
            }
            catch (Exception ex) {
                // Trả về lỗi để JavaScript biết và nhả nút bấm
                return Json(new { success = false, message = "Lỗi gửi mail: " + ex.Message });
            }
        }

        private async Task<int> SendMail(string toMail, string subject, string message) {
            try {
                // Dùng tên đầy đủ để tránh lỗi Ambiguous reference
                using (var smtpClient = new System.Net.Mail.SmtpClient("smtp.gmail.com")) {
                    smtpClient.Port = 587;
                    smtpClient.EnableSsl = true;
                    smtpClient.Credentials = new NetworkCredential("bkc@gmail.com", "naslhfkxujtcezfa");

                    var mail = new System.Net.Mail.MailMessage();
                    mail.From = new MailAddress("bkc@gmail.com", "BKC EDU");
                    mail.To.Add(toMail);
                    mail.Subject = subject;
                    mail.Body = message;
                    mail.IsBodyHtml = true;

                    await smtpClient.SendMailAsync(mail);
                }
                return 1;
            }
            catch { return 0; }
        }
    }
}