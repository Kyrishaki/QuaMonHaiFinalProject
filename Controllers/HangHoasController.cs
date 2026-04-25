using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using System.Text.Json;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class HangHoasController : Controller
    {
        private readonly Hshop2023Context _context;

        public HangHoasController(Hshop2023Context context)
        {
            _context = context;
        }

        // 1. LIỆT KÊ: Đọc từ SQL Server
        public async Task<IActionResult> Index(int page = 1)
        {
            int pageSize = 9;
            var query = _context.HangHoas.Include(h => h.MaLoaiNavigation).OrderByDescending(h => h.MaHh);

            int totalItems = await query.CountAsync();
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var items = await query.Skip((page - 1) * pageSize).Take(pageSize).ToListAsync();
            return View(items);
        }

        // 2. ĐỒNG BỘ: Kéo từ API về SQL Server (Chìa khóa để lưu dữ liệu)
        public async Task<IActionResult> SyncFromApi()
        {
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync("https://dummyjson.com/products?limit=30");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    var apiData = JsonSerializer.Deserialize<ProductApiResponse>(json, options);

                    foreach (var item in apiData.products)
                    {
                        if (!_context.HangHoas.Any(h => h.TenHh == item.title))
                        {
                            _context.HangHoas.Add(new HangHoa
                            {
                                TenHh = item.title,
                                DonGia = item.price,
                                Hinh = item.thumbnail, // Lưu URL trực tiếp
                                MaLoai = 1, // Gán loại mặc định
                                MoTa = item.description,
                                NgaySx = DateTime.Now
                            });
                        }
                    }
                    await _context.SaveChangesAsync(); // LƯU VĨNH VIỄN VÀO SQL
                }
            }
            return RedirectToAction(nameof(Index));
        }

        // 3. EDIT: Sửa và ghi đè vào SQL Server
        public async Task<IActionResult> Edit(int? id)
        {
            var hh = await _context.HangHoas.FindAsync(id);
            if (hh == null) return NotFound();
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai", hh.MaLoai);
            return View(hh);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, HangHoa hh)
        {
            if (ModelState.IsValid)
            {
                _context.Update(hh);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(hh);
        }

        // 4. DELETE: Xóa vĩnh viễn khỏi SQL
        public async Task<IActionResult> Delete(int id)
        {
            var hh = await _context.HangHoas.FindAsync(id);
            if (hh != null)
            {
                _context.HangHoas.Remove(hh);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Index));
        }

        // 5. CREATE & DETAILS (Cơ bản)
        public IActionResult Create()
        {
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(HangHoa hh)
        {
            if (ModelState.IsValid)
            {
                _context.Add(hh);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(hh);
        }

        public async Task<IActionResult> Details(int? id)
        {
            var hh = await _context.HangHoas.Include(h => h.MaLoaiNavigation).FirstOrDefaultAsync(m => m.MaHh == id);
            return View(hh);
        }
    }
}