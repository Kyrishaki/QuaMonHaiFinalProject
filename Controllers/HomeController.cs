using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.Services;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Diagnostics;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IConsumeApi _api;

        public HomeController(ILogger<HomeController> logger, IConsumeApi api)
        {
            _logger = logger;
            _api = api;
        }

        public IActionResult Home()
        {
            return View();
        }

        // GET: Index (Gọi API /api/HangHoas và /api/HangHoas/danh-muc)
        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, int page = 1)
        {
            int pageSize = 9;

            // 1. Lấy danh mục từ API
            var resDanhMuc = await _api.GetAsync("HangHoas/danh-muc");
            if (resDanhMuc.Success && resDanhMuc.Data != null)
            {
                var listLoai = JsonConvert.DeserializeObject<List<Loai>>(JsonConvert.SerializeObject(resDanhMuc.Data));
                ViewBag.DanhMucs = listLoai;
            }
            else
            {
                ViewBag.DanhMucs = new List<Loai>();
            }

            ViewBag.CurrentLoai = loaiId;

            // 2. Lấy danh sách hàng hóa có lọc & phân trang từ API
            var pars = new Dictionary<string, dynamic>
            {
                { "page", page },
                { "pageSize", pageSize }
            };

            if (loaiId.HasValue) pars.Add("loaiId", loaiId.Value);
            if (!string.IsNullOrEmpty(searchQuery)) pars.Add("searchQuery", searchQuery);
            if (!string.IsNullOrEmpty(priceRange)) pars.Add("priceRange", priceRange);

            var resHangHoa = await _api.GetAsync("HangHoas", pars);
            var items = new List<HangHoa>();

            if (resHangHoa.Success && resHangHoa.Data != null)
            {
                var pagedData = resHangHoa.Data;
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

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
