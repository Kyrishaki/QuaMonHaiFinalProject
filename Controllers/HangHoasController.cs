using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Authorization; // THÊM THƯ VIỆN NÀY DÙNG CHO BẢO MẬT
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class HangHoasController : Controller {
        private readonly Hshop2023Context _context;

        public HangHoasController(Hshop2023Context context) {
            _context = context;
        }

        // GET: HangHoas (Mở cho tất cả mọi người xem danh sách)
        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, int page = 1) {
            int pageSize = 9;

            ViewBag.DanhMucs = await _context.Loais.AsNoTracking().ToListAsync();
            ViewBag.CurrentLoai = loaiId;

            var query = _context.HangHoas
                                .Include(h => h.MaLoaiNavigation)
                                .AsNoTracking()
                                .AsQueryable();

            if (loaiId.HasValue) {
                query = query.Where(h => h.MaLoai == loaiId.Value);
            }

            if (!string.IsNullOrEmpty(searchQuery)) {
                query = query.Where(h => h.TenHh.Contains(searchQuery));
            }

            if (!string.IsNullOrEmpty(priceRange)) {
                switch (priceRange) {
                    case "under50":
                        query = query.Where(h => h.DonGia < 50);
                        break;
                    case "50to100":
                        query = query.Where(h => h.DonGia >= 50 && h.DonGia <= 100);
                        break;
                    case "over100":
                        query = query.Where(h => h.DonGia > 100);
                        break;
                }
            }

            int totalItems = await query.CountAsync();
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            var items = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(items);
        }

        // GET: HangHoas/Details/5 (Mở cho tất cả mọi người xem chi tiết)
        public async Task<IActionResult> Details(int? id) {
            if (id == null) {
                return NotFound();
            }

            var hangHoa = await _context.HangHoas
                .Include(h => h.MaLoaiNavigation)
                .Include(h => h.MaNccNavigation)
                .FirstOrDefaultAsync(m => m.MaHh == id);
            if (hangHoa == null) {
                return NotFound();
            }

            return View(hangHoa);
        }

        // ================= KHU VỰC BẢO MẬT: CHỈ ADMIN MỚI ĐƯỢC VÀO =================

        // GET: HangHoas/Create
        [Authorize(Roles = "Admin")]
        public IActionResult Create() {
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai");
            ViewData["MaNcc"] = new SelectList(_context.NhaCungCaps, "MaNcc", "TenCongTy");
            return View();
        }

        // POST: HangHoas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Create([Bind("MaHh,TenHh,TenAlias,MaLoai,MoTaDonVi,DonGia,Hinh,NgaySx,GiamGia,SoLanXem,MoTa,MaNcc")] HangHoa hangHoa, IFormFile? fHinh) {
            ModelState.Remove("MaLoaiNavigation");
            ModelState.Remove("MaNccNavigation");
            ModelState.Remove("fHinh");

            if (ModelState.IsValid) {
                if (fHinh != null && fHinh.Length > 0) {
                    hangHoa.Hinh = await LuuFileHinh(fHinh);
                }
                else {
                    hangHoa.Hinh = "no-image.jpg";
                }

                _context.Add(hangHoa);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Thêm mới sản phẩm thành công!";
                return RedirectToAction(nameof(Index));
            }
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai", hangHoa.MaLoai);
            ViewData["MaNcc"] = new SelectList(_context.NhaCungCaps, "MaNcc", "TenCongTy", hangHoa.MaNcc);
            return View(hangHoa);
        }

        private async Task<string> LuuFileHinh(IFormFile file) {
            var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
            var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "Hinh", "HangHoa", fileName);

            using (var stream = new FileStream(path, FileMode.Create)) {
                await file.CopyToAsync(stream);
            }
            return fileName;
        }

        // GET: HangHoas/Edit/5
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit(int? id) {
            if (id == null) {
                return NotFound();
            }

            var hangHoa = await _context.HangHoas.FindAsync(id);
            if (hangHoa == null) {
                return NotFound();
            }
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai", hangHoa.MaLoai);
            ViewData["MaNcc"] = new SelectList(_context.NhaCungCaps, "MaNcc", "TenCongTy", hangHoa.MaNcc);
            return View(hangHoa);
        }

        // POST: HangHoas/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Edit(int id, [Bind("MaHh,TenHh,TenAlias,MaLoai,MoTaDonVi,DonGia,Hinh,NgaySx,GiamGia,SoLanXem,MoTa,MaNcc")] HangHoa hangHoa, IFormFile? fHinh) {
            if (id != hangHoa.MaHh) {
                return NotFound();
            }

            ModelState.Remove("MaLoaiNavigation");
            ModelState.Remove("MaNccNavigation");
            ModelState.Remove("fHinh");

            if (ModelState.IsValid) {
                try {
                    if (fHinh != null && fHinh.Length > 0) {
                        hangHoa.Hinh = await LuuFileHinh(fHinh);
                    }

                    _context.Update(hangHoa);
                    await _context.SaveChangesAsync();
                    TempData["Success"] = "Cập nhật sản phẩm thành công!";
                }
                catch (DbUpdateConcurrencyException) {
                    if (!HangHoaExists(hangHoa.MaHh)) {
                        return NotFound();
                    }
                    else {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai", hangHoa.MaLoai);
            ViewData["MaNcc"] = new SelectList(_context.NhaCungCaps, "MaNcc", "TenCongTy", hangHoa.MaNcc);
            return View(hangHoa);
        }

        // GET: HangHoas/Delete/5
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> Delete(int? id) {
            if (id == null) {
                return NotFound();
            }

            var hangHoa = await _context.HangHoas
                .Include(h => h.MaLoaiNavigation)
                .Include(h => h.MaNccNavigation)
                .FirstOrDefaultAsync(m => m.MaHh == id);
            if (hangHoa == null) {
                return NotFound();
            }

            return View(hangHoa);
        }

        // POST: HangHoas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteConfirmed(int id) {
            var hangHoa = await _context.HangHoas.FindAsync(id);
            if (hangHoa != null) {
                _context.HangHoas.Remove(hangHoa);
                TempData["Success"] = "Đã xóa sản phẩm!";
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool HangHoaExists(int id) {
            return _context.HangHoas.Any(e => e.MaHh == id);
        }
    }
}