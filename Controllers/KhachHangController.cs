using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.Services;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class KhachHangController : Controller
    {
        private readonly IConsumeApi _api;

        public KhachHangController(IConsumeApi api)
        {
            _api = api;
        }

        private string GetJwtToken()
        {
            return HttpContext.Session.GetString("JWT_TOKEN") ?? string.Empty;
        }

        #region Register
        [HttpGet]
        public IActionResult DangKy()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> DangKy(RegisterVM model, IFormFile? Hinh)
        {
            if (ModelState.IsValid)
            {
                using var form = new MultipartFormDataContent();
                form.Add(new StringContent(model.MaKh ?? ""), "MaKh");
                form.Add(new StringContent(model.MatKhau ?? ""), "MatKhau");
                form.Add(new StringContent(model.HoTen ?? ""), "HoTen");
                form.Add(new StringContent(model.GioiTinh.ToString()), "GioiTinh");
                form.Add(new StringContent(model.NgaySinh?.ToString("o") ?? DateTime.Now.ToString("o")), "NgaySinh");
                if (!string.IsNullOrEmpty(model.DiaChi)) form.Add(new StringContent(model.DiaChi), "DiaChi");
                if (!string.IsNullOrEmpty(model.DienThoai)) form.Add(new StringContent(model.DienThoai), "DienThoai");
                form.Add(new StringContent(model.Email ?? ""), "Email");

                if (Hinh != null && Hinh.Length > 0)
                {
                    var fileContent = new StreamContent(Hinh.OpenReadStream());
                    fileContent.Headers.ContentType = new MediaTypeHeaderValue(Hinh.ContentType);
                    form.Add(fileContent, "Hinh", Hinh.FileName);
                }

                var res = await _api.PostFormAsync("KhachHang/dang-ky", form);
                if (res.Success)
                {
                    TempData["Success"] = "Đăng ký thành công! Vui lòng đăng nhập.";
                    return RedirectToAction("DangNhap", "KhachHang");
                }

                ModelState.AddModelError(string.Empty, res.Message);
            }
            return View(model);
        }
        #endregion

        #region Login
        [HttpGet]
        public IActionResult DangNhap(string? ReturnUrl)
        {
            ViewBag.ReturnUrl = ReturnUrl;
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> DangNhap(LoginVM model, string? ReturnUrl)
        {
            ViewBag.ReturnUrl = ReturnUrl;
            if (ModelState.IsValid)
            {
                var loginData = new { UserName = model.UserName, Password = model.Password };
                var res = await _api.PostAsync("KhachHang/dang-nhap", loginData);

                if (res.Success && res.Data != null)
                {
                    string token = res.Data.token ?? "";
                    string role = res.Data.role ?? "Customer";
                    string hoTen = res.Data.hoTen ?? model.UserName;
                    string email = res.Data.email ?? "";
                    string maKh = res.Data.maKh ?? model.UserName;

                    // Lưu JWT Token vào Session để gọi các API bảo mật tiếp theo
                    HttpContext.Session.SetString("JWT_TOKEN", token);

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Email, email),
                        new Claim(ClaimTypes.Name, hoTen),
                        new Claim("CustomerID", maKh),
                        new Claim(ClaimTypes.Role, role)
                    };

                    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

                    await HttpContext.SignInAsync(claimsPrincipal);

                    if (!string.IsNullOrEmpty(ReturnUrl) && Url.IsLocalUrl(ReturnUrl))
                    {
                        return Redirect(ReturnUrl);
                    }
                    return Redirect("/");
                }

                ModelState.AddModelError("loi", res.Message);
            }
            return View(model);
        }
        #endregion

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> Profile()
        {
            var token = GetJwtToken();
            var res = await _api.GetAsync("KhachHang/profile", null, token);

            if (!res.Success || res.Data == null)
            {
                return RedirectToAction("DangNhap");
            }

            var khachHang = JsonConvert.DeserializeObject<KhachHang>(JsonConvert.SerializeObject(res.Data));
            return View(khachHang);
        }

        [Authorize]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Profile(KhachHang model, IFormFile? fHinh)
        {
            using var form = new MultipartFormDataContent();
            form.Add(new StringContent(model.HoTen ?? ""), "HoTen");
            form.Add(new StringContent(model.Email ?? ""), "Email");
            if (!string.IsNullOrEmpty(model.DienThoai)) form.Add(new StringContent(model.DienThoai), "DienThoai");
            if (!string.IsNullOrEmpty(model.DiaChi)) form.Add(new StringContent(model.DiaChi), "DiaChi");
            form.Add(new StringContent(model.NgaySinh.ToString("o")), "NgaySinh");
            form.Add(new StringContent(model.GioiTinh.ToString()), "GioiTinh");

            if (fHinh != null && fHinh.Length > 0)
            {
                var fileContent = new StreamContent(fHinh.OpenReadStream());
                fileContent.Headers.ContentType = new MediaTypeHeaderValue(fHinh.ContentType);
                form.Add(fileContent, "FHinh", fHinh.FileName);
            }

            var token = GetJwtToken();
            var res = await _api.PutFormAsync("KhachHang/profile", form, token);

            if (res.Success)
            {
                TempData["Success"] = "Cập nhật hồ sơ cá nhân thành công!";
                return RedirectToAction("Profile");
            }

            ModelState.AddModelError(string.Empty, res.Message);
            return View(model);
        }

        [Authorize]
        public async Task<IActionResult> DangXuat()
        {
            var token = GetJwtToken();
            await _api.PostAsync("KhachHang/dang-xuat", null, token);

            HttpContext.Session.Remove("JWT_TOKEN");
            await HttpContext.SignOutAsync();
            return Redirect("/");
        }
    }
}
