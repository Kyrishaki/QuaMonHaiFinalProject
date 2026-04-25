using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class ApiController : Controller
    {
        private readonly HttpClient _httpClient;

        public ApiController()
        {
            _httpClient = new HttpClient();
        }

        // 1. READ (Lấy danh sách)
        public async Task<IActionResult> Index()
        {
            var response = await _httpClient.GetAsync("https://dummyjson.com/products?limit=10");
            var json = await response.Content.ReadAsStringAsync();
            var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
            var data = JsonSerializer.Deserialize<ProductApiResponse>(json, options);
            return View(data.products);
        }

        // 2. CREATE (Hiển thị form & Xử lý thêm)
        public IActionResult Create() => View();

        [HttpPost]
        public async Task<IActionResult> Create(ApiProduct product)
        {
            // DummyJSON yêu cầu POST lên /add
            var response = await _httpClient.PostAsJsonAsync("https://dummyjson.com/products/add", product);
            if (response.IsSuccessStatusCode)
            {
                TempData["Message"] = "Thêm thành công (Mô phỏng)";
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // 3. UPDATE (Hiển thị form & Xử lý sửa)
        public async Task<IActionResult> Edit(int id)
        {
            var product = await _httpClient.GetFromJsonAsync<ApiProduct>($"https://dummyjson.com/products/{id}");
            return View(product);
        }

        [HttpPost]
        public async Task<IActionResult> Edit(int id, ApiProduct product)
        {
            // DummyJSON yêu cầu PUT hoặc PATCH
            var response = await _httpClient.PutAsJsonAsync($"https://dummyjson.com/products/{id}", product);
            if (response.IsSuccessStatusCode)
            {
                TempData["Message"] = "Cập nhật thành công (Mô phỏng)";
                return RedirectToAction("Index");
            }
            return View(product);
        }

        // 4. DELETE (Xóa)
        public async Task<IActionResult> Delete(int id)
        {
            var response = await _httpClient.DeleteAsync($"https://dummyjson.com/products/{id}");
            if (response.IsSuccessStatusCode)
            {
                TempData["Message"] = "Xóa thành công (Mô phỏng)";
            }
            return RedirectToAction("Index");
        }
    }
}