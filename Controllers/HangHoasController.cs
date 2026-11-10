using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.Services;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Newtonsoft.Json;
using System.Net.Http.Headers;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class HangHoasController : Controller
    {
        private readonly IConsumeApi _api;

        public HangHoasController(IConsumeApi api)
        {
            _api = api;
        }

        private string GetJwtToken()
        {
            return HttpContext.Session.GetString("JWT_TOKEN") ?? string.Empty;
        }

        // GET: HangHoas
        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, int page = 1)
        {
            int pageSize = 9;

            var resDanhMuc = await _api.GetAsync("HangHoas/danh-muc");
            if (resDanhMuc.Success && resDanhMuc.Data != null)
            {
                ViewBag.DanhMucs = JsonConvert.DeserializeObject<List<Loai>>(JsonConvert.SerializeObject(resDanhMuc.Data));
            }
            else
            {
                ViewBag.DanhMucs = new List<Loai>();
            }

            ViewBag.CurrentLoai = loaiId;

            var pars = new Dictionary<string, dynamic>
            {
                { "page", page },
                { "pageSize", pageSize }
            };

            if (loaiId.HasValue) pars.Add("loaiId", loaiId.Value);
            if (!string.IsNullOrEmpty(searchQuery)) pars.Add("searchQuery", searchQuery);
            if (!string.IsNullOrEmpty(priceRange)) pars.Add("priceRange", priceRange);

            var res = await _api.GetAsync("HangHoas", pars);
            var items = new List<HangHoa>();

            if (res.Success && res.Data != null)
            {
                var pagedData = res.Data;
                ViewBag.CurrentPage = (int)(pagedData.currentPage ?? 1);
                ViewBag.TotalPages = (int)(pagedData.totalPages ?? 1);

                if (pagedData.items != null)
                {
                    items = JsonConvert.DeserializeObject<List<HangHoa>>(JsonConvert.SerializeObject(pagedData.items)) ?? new List<HangHoa>();
                }
            }
            else
            {
                ViewBag.CurrentPage = 1;
                ViewBag.TotalPages = 1;
            }

            return View(items);
        }

        // GET: HangHoas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null) return NotFound();

            var res = await _api.GetAsync($"HangHoas/{id}");
            if (!res.Success || res.Data == null) return NotFound();

            var hangHoa = JsonConvert.DeserializeObject<HangHoa>(JsonConvert.SerializeObject(res.Data));
            return View(hangHoa);
        }

        // ================= KHU VỰC BẢO MẬT: CHỈ ADMIN MỚI ĐƯỢC VÀO =================

        // GET: HangHoas/Create
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Create()
        {
            var resDanhMuc = await _api.GetAsync("HangHoas/danh-muc");
            var listLoai = resDanhMuc.Success && resDanhMuc.Data != null
                ? JsonConvert.DeserializeObject<List<Loai>>(JsonConvert.SerializeObject(resDanhMuc.Data))
                : new List<Loai>();

            ViewData["MaLoai"] = new SelectList(listLoai, "MaLoai", "TenLoai");
            return View();
        }

        // POST: HangHoas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Create(HangHoa hangHoa, IFormFile? fHinh)
        {
            using var form = new MultipartFormDataContent();
            form.Add(new StringContent(hangHoa.TenHh ?? ""), "TenHh");
            if (!string.IsNullOrEmpty(hangHoa.TenAlias)) form.Add(new StringContent(hangHoa.TenAlias), "TenAlias");
            form.Add(new StringContent(hangHoa.MaLoai.ToString()), "MaLoai");
            if (!string.IsNullOrEmpty(hangHoa.MoTaDonVi)) form.Add(new StringContent(hangHoa.MoTaDonVi), "MoTaDonVi");
            form.Add(new StringContent((hangHoa.DonGia ?? 0).ToString()), "DonGia");
            form.Add(new StringContent(hangHoa.NgaySx.ToString("o")), "NgaySx");
            form.Add(new StringContent(hangHoa.GiamGia.ToString()), "GiamGia");
            if (!string.IsNullOrEmpty(hangHoa.MoTa)) form.Add(new StringContent(hangHoa.MoTa), "MoTa");
            form.Add(new StringContent(hangHoa.MaNcc ?? "NK"), "MaNcc");

            if (fHinh != null && fHinh.Length > 0)
            {
                var fileStream = fHinh.OpenReadStream();
                var fileContent = new StreamContent(fileStream);
                fileContent.Headers.ContentType = new MediaTypeHeaderValue(fHinh.ContentType);
                form.Add(fileContent, "FHinh", fHinh.FileName);
            }

            var token = GetJwtToken();
            var res = await _api.PostFormAsync("HangHoas", form, token);

            if (res.Success)
            {
                TempData["Success"] = "Thêm mới sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }

            ModelState.AddModelError(string.Empty, res.Message);
            return View(hangHoa);
        }

        // GET: HangHoas/Edit/5
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null) return NotFound();

            var res = await _api.GetAsync($"HangHoas/{id}");
            if (!res.Success || res.Data == null) return NotFound();

            var hangHoa = JsonConvert.DeserializeObject<HangHoa>(JsonConvert.SerializeObject(res.Data));

            var resDanhMuc = await _api.GetAsync("HangHoas/danh-muc");
            var listLoai = resDanhMuc.Success && resDanhMuc.Data != null
                ? JsonConvert.DeserializeObject<List<Loai>>(JsonConvert.SerializeObject(resDanhMuc.Data))
                : new List<Loai>();

            ViewData["MaLoai"] = new SelectList(listLoai, "MaLoai", "TenLoai", hangHoa?.MaLoai);
            return View(hangHoa);
        }

        // POST: HangHoas/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit(int id, HangHoa hangHoa, IFormFile? fHinh)
        {
            using var form = new MultipartFormDataContent();
            form.Add(new StringContent(hangHoa.TenHh ?? ""), "TenHh");
            if (!string.IsNullOrEmpty(hangHoa.TenAlias)) form.Add(new StringContent(hangHoa.TenAlias), "TenAlias");
            form.Add(new StringContent(hangHoa.MaLoai.ToString()), "MaLoai");
            if (!string.IsNullOrEmpty(hangHoa.MoTaDonVi)) form.Add(new StringContent(hangHoa.MoTaDonVi), "MoTaDonVi");
            form.Add(new StringContent((hangHoa.DonGia ?? 0).ToString()), "DonGia");
            form.Add(new StringContent(hangHoa.NgaySx.ToString("o")), "NgaySx");
            form.Add(new StringContent(hangHoa.GiamGia.ToString()), "GiamGia");
            if (!string.IsNullOrEmpty(hangHoa.MoTa)) form.Add(new StringContent(hangHoa.MoTa), "MoTa");
            form.Add(new StringContent(hangHoa.MaNcc ?? "NK"), "MaNcc");

            if (fHinh != null && fHinh.Length > 0)
            {
                var fileStream = fHinh.OpenReadStream();
                var fileContent = new StreamContent(fileStream);
                fileContent.Headers.ContentType = new MediaTypeHeaderValue(fHinh.ContentType);
                form.Add(fileContent, "FHinh", fHinh.FileName);
            }

            var token = GetJwtToken();
            var res = await _api.PutFormAsync($"HangHoas/{id}", form, token);

            if (res.Success)
            {
                TempData["Success"] = "Cập nhật sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }

            ModelState.AddModelError(string.Empty, res.Message);
            return View(hangHoa);
        }

        // GET: HangHoas/Delete/5
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null) return NotFound();

            var res = await _api.GetAsync($"HangHoas/{id}");
            if (!res.Success || res.Data == null) return NotFound();

            var hangHoa = JsonConvert.DeserializeObject<HangHoa>(JsonConvert.SerializeObject(res.Data));
            return View(hangHoa);
        }

        // POST: HangHoas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var token = GetJwtToken();
            var res = await _api.DeleteAsync($"HangHoas/{id}", null, token);

            if (res.Success)
            {
                TempData["Success"] = "Đã xóa sản phẩm!";
            }
            else
            {
                TempData["Error"] = res.Message;
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
