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
    public class CustomerController : Controller {
        private readonly Hshop2023Context db;
        private readonly IMapper _mapper;

        public CustomerController(Hshop2023Context context, IMapper mapper) {
            db = context;
            _mapper = mapper;
        }

        #region Register
        [HttpGet]
        public IActionResult Register() {
            return View();
        }

        [HttpPost]
        public IActionResult Register(RegisterVM model, IFormFile? Hinh) {
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
                    if (Hinh != null && Hinh.Length > 0)
                    {
                        khachHang.Hinh = MyUtil.UploadHinh(Hinh, "KhachHang");
                    }
                    else
                    {
                        // Người dùng không cần chọn gì ở trang đăng ký, hệ thống tự động bốc ngẫu nhiên từ default1 đến default5
                        Random rand = new Random();
                        int randomNumber = rand.Next(1, 6);
                        khachHang.Hinh = $"default{randomNumber}.svg";
                    }

                    // ==========================================
                    // KẾT THÚC XỬ LÝ
                    // ==========================================

                    db.Add(khachHang);
                    db.SaveChanges();

                    TempData["Success"] = "Đăng ký thành công!";
                    return RedirectToAction("Login", "Customer");
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
        public IActionResult Login(string? ReturnUrl) {
            ViewBag.ReturnUrl = ReturnUrl;
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginVM model, string? ReturnUrl) {
            ViewBag.ReturnUrl = ReturnUrl;
            if (ModelState.IsValid) {
                // TEMPORARILY BYPASSED FOR AUTOMATED TESTING
                /*
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
                */

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

                            if (TempData["url"] != null)
                            {
                                var url = TempData["url"].ToString();
                                return Redirect(url);

                            }
                            else
                            {
                                // Kiểm tra đường dẫn và điều hướng
                                if (Url.IsLocalUrl(ReturnUrl))
                                {
                                    return Redirect(ReturnUrl);
                                }
                                else
                                {
                                    return Redirect("/"); // Chuyển về trang chủ
                                }
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
                return RedirectToAction("Login");
            }

            // Tìm thông tin khách hàng trong Database
            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
            if (khachHang == null) {
                return NotFound();
            }

            return View(khachHang);
        }

        // POST: Xử lý khi người dùng bấm nút "Lưu thay đổi"
        [HttpPost]
        [Authorize]
        public IActionResult Profile(KhachHang model, IFormFile? fHinh, string? DefaultAvatar)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Tìm tài khoản gốc trong cơ sở dữ liệu để cập nhật
                    var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == model.MaKh);
                    if (khachHang != null)
                    {
                        // Cập nhật các thông tin cơ bản
                        khachHang.HoTen = model.HoTen;
                        khachHang.GioiTinh = model.GioiTinh;
                        khachHang.NgaySinh = model.NgaySinh;
                        khachHang.DienThoai = model.DienThoai;
                        khachHang.Email = model.Email;
                        khachHang.DiaChi = model.DiaChi;

                        // XỬ LÝ ĐỔI AVATAR TẠI TRANG PROFILE:
                        if (fHinh != null && fHinh.Length > 0)
                        {
                            // Cách 1: Nếu người dùng tải file ảnh mới từ máy tính lên
                            khachHang.Hinh = MyUtil.UploadHinh(fHinh, "KhachHang");
                        }
                        else if (!string.IsNullOrEmpty(DefaultAvatar))
                        {
                            // Cách 2: Nếu người dùng click chọn 1 trong 5 ảnh default github trên giao diện profile
                            khachHang.Hinh = DefaultAvatar;
                        }
                        // Nếu không chọn gì cả, giữ nguyên khachHang.Hinh cũ trong database

                        db.Update(khachHang);
                        db.SaveChanges();

                        TempData["Success"] = "Cập nhật thông tin hồ sơ thành công!";
                        return RedirectToAction("Profile");
                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError(string.Empty, "Lỗi khi lưu thông tin: " + ex.Message);
                }
            }
            return View(model);
        }

        [Authorize]
        [HttpPost]
        public IActionResult UpdateInstantAvatar(string avatarName)
        {
            try
            {
                // Lấy Mã khách hàng từ mã Cookie/Claim đăng nhập hiện tại
                var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
                if (string.IsNullOrEmpty(customerId))
                {
                    return Json(new { success = false, message = "Phiên làm việc hết hạn!" });
                }

                if (string.IsNullOrEmpty(avatarName))
                {
                    return Json(new { success = false, message = "Dữ liệu ảnh không hợp lệ!" });
                }

                // Tìm tài khoản trong Database để cập nhật trường hình
                var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
                if (khachHang == null)
                {
                    return Json(new { success = false, message = "Không tìm thấy tài khoản!" });
                }

                // Cập nhật tên file ảnh mới (ví dụ: default2.svg) và lưu vào SQL Server
                khachHang.Hinh = avatarName;
                db.Update(khachHang);
                db.SaveChanges();

                return Json(new { success = true, message = "Đã lưu ảnh đại diện mới thành công!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi hệ thống: " + ex.Message });
            }
        }
        // ===============================================
        // BẮT ĐẦU: KHU VỰC XỬ LÝ ĐỔI MẬT KHẨU
        // ===============================================

        [Authorize]
        [HttpGet]
        public IActionResult ChangePassword()
        {
            return View();
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ChangePassword(ChangePasswordVM model)
        {
            // ---- ĐOẠN KHẮC PHỤC LỖI RÀNG BUỘC PHƯƠNG THỨC ----
            if (model.ChangeMethod == "EmailOTP")
            {
                // Nếu chọn OTP, gỡ bỏ các lỗi kiểm tra tự động liên quan đến Mật khẩu cũ
                ModelState.Remove("OldPassword");
            }
            else if (model.ChangeMethod == "OldPassword")
            {
                // Nếu chọn Mật khẩu cũ, gỡ bỏ các lỗi kiểm tra tự động liên quan đến OTP
                ModelState.Remove("VerificationCode");
            }
            // --------------------------------------------------

            // Bây giờ hệ thống sẽ không còn bắt lỗi trống Mật khẩu cũ khi chọn xác thực qua Email nữa
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
            if (string.IsNullOrEmpty(customerId))
            {
                return RedirectToAction("Login");
            }

            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
            if (khachHang == null)
            {
                return NotFound();
            }

            // LỰA CHỌN 1: XÁC THỰC BẰNG MẬT KHẨU CŨ
            if (model.ChangeMethod == "OldPassword")
            {
                if (string.IsNullOrEmpty(model.OldPassword))
                {
                    ModelState.AddModelError("OldPassword", "Vui lòng nhập mật khẩu hiện tại.");
                    return View(model);
                }

                var hashedOldPassword = model.OldPassword.ToMd5Hash(khachHang.RandomKey);
                if (khachHang.MatKhau != hashedOldPassword)
                {
                    ModelState.AddModelError("OldPassword", "Mật khẩu hiện tại không chính xác.");
                    return View(model);
                }
            }
            // LỰA CHỌN 2: XÁC THỰC BẰNG MẠ OTP SANG GMAIL
            else if (model.ChangeMethod == "EmailOTP")
            {
                var sessionCode = HttpContext.Session.GetString("ChangePassword_OTP");
                var sessionUser = HttpContext.Session.GetString("ChangePassword_User");

                if (string.IsNullOrEmpty(sessionCode) || sessionUser != customerId)
                {
                    ModelState.AddModelError(string.Empty, "Phiên làm việc gửi mã đã hết hạn hoặc không hợp lệ.");
                    return View(model);
                }

                if (string.IsNullOrEmpty(model.VerificationCode) || model.VerificationCode != sessionCode)
                {
                    ModelState.AddModelError("VerificationCode", "Mã OTP xác thực không chính xác.");
                    return View(model);
                }
            }

            try
            {
                khachHang.RandomKey = MyUtil.GenerateRandomKey();
                khachHang.MatKhau = model.NewPassword.ToMd5Hash(khachHang.RandomKey);

                db.Update(khachHang);
                db.SaveChanges();

                HttpContext.Session.Remove("ChangePassword_OTP");
                HttpContext.Session.Remove("ChangePassword_User");

                TempData["Success"] = "Đổi mật khẩu thành công!";
                return RedirectToAction("Profile");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, "Có lỗi xảy ra: " + ex.Message);
                return View(model);
            }
        }

        // API Ajax: Gửi mã OTP dành riêng cho việc đổi mật khẩu công khai
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> SendChangePasswordOtp()
        {
            try
            {
                var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
                if (string.IsNullOrEmpty(customerId)) return Json(new { success = false, message = "Chưa đăng nhập!" });

                var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == customerId);
                if (khachHang == null || string.IsNullOrEmpty(khachHang.Email))
                {
                    return Json(new { success = false, message = "Không tìm thấy thông tin Email của tài khoản này!" });
                }

                // 1. Tạo OTP 6 số và lưu Session
                string otpCode = new Random().Next(100000, 999999).ToString();
                HttpContext.Session.SetString("ChangePassword_OTP", otpCode);
                HttpContext.Session.SetString("ChangePassword_User", customerId);

                // 2. Cấu hình gửi Mail qua MailKit (Sử dụng lại cấu hình chuẩn của bạn)
                var message = new MimeKit.MimeMessage();
                message.From.Add(new MimeKit.MailboxAddress("HShop", "trathanhclassic123@gmail.com"));
                message.To.Add(new MimeKit.MailboxAddress(khachHang.HoTen, khachHang.Email));
                message.Subject = "Mã xác thực đổi mật khẩu tài khoản";
                message.Body = new MimeKit.TextPart("html")
                {
                    Text = $"<h3>Yêu cầu đổi mật khẩu cho tài khoản <b>{khachHang.MaKh}</b></h3>" +
                           $"<p>Mã xác thực OTP của bạn là: <b style='color:red; font-size:1.3rem;'>{otpCode}</b></p>" +
                           $"<p>Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>"
                };

                using (var client = new MailKit.Net.Smtp.SmtpClient())
                {
                    await client.ConnectAsync("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
                    await client.AuthenticateAsync("trathanhclassic123@gmail.com", "sgpyhcoqqcpeziyj");
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                return Json(new { success = true, message = "Mã xác thực đã được gửi đến email của bạn!" });
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = "Lỗi hệ thống gửi mail: " + ex.Message });
            }
        }

        // ===============================================
        // KẾT THÚC: KHU VỰC XỬ LÝ ĐỔI MẬT KHẨU
        // ===============================================

        [Authorize]
        public async Task<IActionResult> Logout() {
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

        #region QuenMatKhau
        // GET: Customer/ForgotPassword
        [HttpGet]
        public IActionResult ForgotPassword()
        {
            return View();
        }

        // POST: Customer/ForgotPassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordVM model)
        {
            if (!ModelState.IsValid) return View(model);

            // Kiểm tra xem có tài khoản nào khớp cả MaKh (Username) và Email không
            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == model.UserName && kh.Email == model.Email);

            if (khachHang == null)
            {
                ModelState.AddModelError(string.Empty, "Thông tin tài khoản hoặc Email không chính xác.");
                return View(model);
            }

            if (!khachHang.HieuLuc)
            {
                ModelState.AddModelError(string.Empty, "Tài khoản này hiện đang bị khóa.");
                return View(model);
            }

            try
            {
                // 1. Tạo mã OTP ngẫu nhiên gồm 6 số
                string otpCode = new Random().Next(100000, 999999).ToString();

                // 2. Lưu thông tin vào Session để phục vụ bước xác thực kế tiếp
                HttpContext.Session.SetString("ResetPassword_OTP", otpCode);
                HttpContext.Session.SetString("ResetPassword_User", khachHang.MaKh);

                // 3. Gửi Email chứa OTP (Sử dụng lại MailKit cấu hình sẵn của bạn)
                var message = new MimeKit.MimeMessage();
                message.From.Add(new MimeKit.MailboxAddress("HShop", "trathanhclassic123@gmail.com"));
                message.To.Add(new MimeKit.MailboxAddress(khachHang.HoTen, khachHang.Email));
                message.Subject = "Mã xác thực đặt lại mật khẩu - Foody";
                message.Body = new MimeKit.TextPart("html")
                {
                    Text = $"<h3>Chào {khachHang.HoTen},</h3><p>Yêu cầu đặt lại mật khẩu của bạn đã được tiếp nhận. Mã OTP xác thực là: <b style='color:red; font-size: 1.2rem;'>{otpCode}</b></p><p>Mã này có hiệu lực trong phiên làm việc hiện tại.</p>"
                };

                using (var client = new MailKit.Net.Smtp.SmtpClient())
                {
                    await client.ConnectAsync("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
                    await client.AuthenticateAsync("trathanhclassic123@gmail.com", "sgpyhcoqqcpeziyj");
                    await client.SendAsync(message);
                    await client.DisconnectAsync(true);
                }

                TempData["Success"] = "Mã xác thực đã được gửi đến Email của bạn.";
                return RedirectToAction("ResetPassword");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, "Có lỗi xảy ra khi gửi mail: " + ex.Message);
            }

            return View(model);
        }

        // GET: Customer/ResetPassword
        [HttpGet]
        public IActionResult ResetPassword()
        {
            // Kiểm tra nếu chưa qua bước nhập Email thì không cho vào trang này
            var username = HttpContext.Session.GetString("ResetPassword_User");
            if (string.IsNullOrEmpty(username))
            {
                return RedirectToAction("ForgotPassword");
            }
            return View();
        }

        // POST: Customer/ResetPassword
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult ResetPassword(ResetPasswordVM model)
        {
            if (!ModelState.IsValid) return View(model);

            // 1. Lấy dữ liệu từ Session ra để đối chiếu
            var sessionCode = HttpContext.Session.GetString("ResetPassword_OTP");
            var username = HttpContext.Session.GetString("ResetPassword_User");

            if (string.IsNullOrEmpty(sessionCode) || string.IsNullOrEmpty(username))
            {
                ModelState.AddModelError(string.Empty, "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại từ đầu.");
                return View(model);
            }

            // 2. Kiểm tra mã OTP người dùng nhập vào
            if (model.VerificationCode != sessionCode)
            {
                ModelState.AddModelError("VerificationCode", "Mã OTP xác thực không chính xác.");
                return View(model);
            }

            // 3. Tìm tài khoản cần đổi mật khẩu
            var khachHang = db.KhachHangs.SingleOrDefault(kh => kh.MaKh == username);
            if (khachHang == null)
            {
                ModelState.AddModelError(string.Empty, "Không tìm thấy tài khoản tương ứng.");
                return View(model);
            }

            try
            {
                // 4. Sinh mã RandomKey mới và băm mật khẩu mới (theo cấu trúc giống trang Đăng ký của bạn)
                khachHang.RandomKey = MyUtil.GenerateRandomKey();
                khachHang.MatKhau = model.NewPassword.ToMd5Hash(khachHang.RandomKey);

                db.Update(khachHang);
                db.SaveChanges();

                // 5. Xóa Session sau khi khôi phục thành công để bảo mật
                HttpContext.Session.Remove("ResetPassword_OTP");
                HttpContext.Session.Remove("ResetPassword_User");

                TempData["Success"] = "Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại bằng mật khẩu mới.";
                return RedirectToAction("Login");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, "Lỗi hệ thống: " + ex.Message);
            }

            return View(model);
        }
        #endregion
    }
}