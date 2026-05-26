using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.AspNetCore.Authorization; // THÊM THƯ VIỆN NÀY DÙNG CHO BẢO MẬT
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using LTWEB_QuaMonHai_CuoiKy.Helpers;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers {
    public class HangHoasController : Controller {
        private readonly Hshop2023Context _context;

        public HangHoasController(Hshop2023Context context) {
            _context = context;
        }

        // GET: HangHoas (Mở cho tất cả mọi người xem danh sách)
        public async Task<IActionResult> Index(int? loaiId, string searchQuery, string priceRange, string sortBy, int page = 1, bool manage = false) {
            var items = await ProductQueryHelper.GetFilteredProductsAsync(
                _context, User, ViewBag, loaiId, searchQuery, priceRange, sortBy, page, manage);

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

            // Lấy danh sách ID sản phẩm yêu thích của người dùng hiện tại
            var favoriteProductIds = new List<int>();
            int maxReviews = 0;
            int writtenReviews = 0;

            if (User.Identity?.IsAuthenticated == true) {
                var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
                if (!string.IsNullOrEmpty(customerId)) {
                    favoriteProductIds = await _context.YeuThiches
                        .Where(y => y.MaKh == customerId && y.MaHh.HasValue)
                        .Select(y => y.MaHh ?? 0)
                        .ToListAsync();

                    // Tính tổng số lượng hàng hóa này đã mua thành công (các hóa đơn có MaTrangThai != -1)
                    maxReviews = await _context.ChiTietHds
                        .Where(ct => ct.MaHdNavigation.MaKh == customerId && ct.MaHh == id && ct.MaHdNavigation.MaTrangThai != -1)
                        .SumAsync(ct => ct.SoLuong);

                    // Tính số lượng bình luận đã viết cho sản phẩm này
                    writtenReviews = await _context.BinhLuans
                        .CountAsync(bl => bl.MaKh == customerId && bl.MaHh == id);
                }
            }
            ViewBag.FavoriteProductIds = favoriteProductIds;
            ViewBag.MaxReviews = maxReviews;
            ViewBag.WrittenReviews = writtenReviews;

            // Lấy danh sách đánh giá của sản phẩm này
            var reviews = await _context.BinhLuans
                .Include(b => b.MaKhNavigation)
                .Where(b => b.MaHh == id)
                .OrderByDescending(b => b.Ngay)
                .ToListAsync();
            ViewBag.Reviews = reviews;

            // Tính điểm đánh giá trung bình
            double avgStars = reviews.Any() ? Math.Round(reviews.Average(r => r.Sao), 1) : 5.0;
            ViewBag.AvgStars = avgStars;
            ViewBag.TotalReviews = reviews.Count;

            // Tính tổng số lượng đã bán (các hóa đơn có MaTrangThai != -1)
            int totalSold = await _context.ChiTietHds
                .Where(ct => ct.MaHh == id && ct.MaHdNavigation.MaTrangThai != -1)
                .SumAsync(ct => ct.SoLuong);
            ViewBag.TotalSold = totalSold;

            // Lấy danh sách sản phẩm liên quan (cùng danh mục MaLoai, loại trừ sản phẩm hiện tại, lấy tối đa 4)
            var relatedProducts = await _context.HangHoas
                .Where(h => h.MaLoai == hangHoa.MaLoai && h.MaHh != id)
                .Take(4)
                .ToListAsync();
            ViewBag.RelatedProducts = relatedProducts;

            // Truy xuất lượng đã bán cho cả sản phẩm chính và sản phẩm liên quan
            var relatedProductIds = relatedProducts.Select(i => i.MaHh).ToList();
            var allProductIds = new List<int> { hangHoa.MaHh };
            allProductIds.AddRange(relatedProductIds);

            var detailsSoldCounts = await _context.ChiTietHds
                .Where(ct => allProductIds.Contains(ct.MaHh) && ct.MaHdNavigation.MaTrangThai != -1)
                .GroupBy(ct => ct.MaHh)
                .Select(g => new { MaHh = g.Key, TotalSold = g.Sum(ct => ct.SoLuong) })
                .ToDictionaryAsync(x => x.MaHh, x => x.TotalSold);
            ViewBag.SoldCounts = detailsSoldCounts;

            // Lấy danh sách mã giảm giá đang hoạt động
            var activeVouchers = await _context.GiamGias
                .Where(v => v.TrangThai == true && v.NgayBatDau <= DateTime.Now && v.NgayKetThuc >= DateTime.Now)
                .Take(3)
                .ToListAsync();
            ViewBag.ActiveVouchers = activeVouchers;

            return View(hangHoa);
        }

        // POST: HangHoas/SendReview (Đăng đánh giá sản phẩm qua AJAX)
        [HttpPost]
        public async Task<IActionResult> SendReview(int maHh, int sao, string noiDung) {
            if (User.Identity?.IsAuthenticated != true) {
                return Json(new { success = false, redirectTo = Url.Action("Login", "Customer"), message = "Vui lòng đăng nhập để đánh giá sản phẩm!" });
            }

            var customerId = User.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
            if (string.IsNullOrEmpty(customerId)) {
                return Json(new { success = false, message = "Không tìm thấy thông tin khách hàng!" });
            }

            if (sao < 1 || sao > 5) {
                return Json(new { success = false, message = "Số sao đánh giá không hợp lệ (1-5)!" });
            }

            var productExists = await _context.HangHoas.AnyAsync(h => h.MaHh == maHh);
            if (!productExists) {
                return Json(new { success = false, message = "Sản phẩm không tồn tại!" });
            }

            // Kiểm tra số lượt đã mua thành công và số lượt đã đánh giá
            var maxReviews = await _context.ChiTietHds
                .Where(ct => ct.MaHdNavigation.MaKh == customerId && ct.MaHh == maHh && ct.MaHdNavigation.MaTrangThai != -1)
                .SumAsync(ct => ct.SoLuong);

            var writtenReviews = await _context.BinhLuans
                .CountAsync(bl => bl.MaKh == customerId && bl.MaHh == maHh);

            if (maxReviews == 0) {
                return Json(new { success = false, message = "Bạn phải mua sản phẩm này trước khi có thể đánh giá!" });
            }

            if (writtenReviews >= maxReviews) {
                return Json(new { success = false, message = $"Bạn đã đánh giá hết số lượng đã mua ({maxReviews} lượt)!" });
            }

            var review = new BinhLuan {
                MaHh = maHh,
                MaKh = customerId,
                Sao = sao,
                NoiDung = noiDung,
                Ngay = DateTime.Now
            };

            _context.BinhLuans.Add(review);
            await _context.SaveChangesAsync();

            var newWrittenReviews = writtenReviews + 1;
            var remainingReviews = maxReviews - newWrittenReviews;

            var khachHang = await _context.KhachHangs.FirstOrDefaultAsync(k => k.MaKh == customerId);

            var avatarUrl = "";
            if (khachHang != null) {
                if (khachHang.Hinh != null && khachHang.Hinh.StartsWith("[API]:")) {
                    string apiName = khachHang.Hinh.Replace("[API]:", "");
                    avatarUrl = Url.Content($"~/api/Avatar/generate?name={Uri.EscapeDataString(apiName)}");
                } else if (!string.IsNullOrEmpty(khachHang.Hinh) && khachHang.Hinh != "default-avatar.jpg" && khachHang.Hinh != "avatar.jpg") {
                    avatarUrl = Url.Content("~/img/Hinh/KhachHang/" + khachHang.Hinh);
                } else {
                    avatarUrl = Url.Content($"~/api/Avatar/generate?name={Uri.EscapeDataString(khachHang.HoTen ?? "User")}");
                }
            } else {
                avatarUrl = Url.Content("~/api/Avatar/generate?name=User");
            }

            return Json(new {
                success = true,
                message = "Đăng đánh giá thành công!",
                remainingReviews = remainingReviews,
                newWrittenReviews = newWrittenReviews,
                maxReviews = maxReviews,
                review = new {
                    tenKh = khachHang?.HoTen ?? "Người dùng",
                    sao = sao,
                    noiDung = noiDung,
                    ngay = review.Ngay.ToString("dd/MM/yyyy HH:mm"),
                    avatarUrl = avatarUrl
                }
            });
        }


        // ================= KHU VỰC BẢO MẬT: CHỈ ADMIN MỚI ĐƯỢC VÀO =================

        // GET: HangHoas/Create
        [Authorize(Roles = "Admin,Staff")]
        public IActionResult Create() {
            ViewData["MaLoai"] = new SelectList(_context.Loais, "MaLoai", "TenLoai");
            ViewData["MaNcc"] = new SelectList(_context.NhaCungCaps, "MaNcc", "TenCongTy");
            return View();
        }

        // POST: HangHoas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin,Staff")]
        public async Task<IActionResult> Create([Bind("MaHh,TenHh,TenAlias,MaLoai,MoTaDonVi,DonGia,Hinh,NgaySx,GiamGia,SoLanXem,MoTa,MaNcc,HieuLuc")] HangHoa hangHoa, IFormFile? fHinh) {
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
            var directoryPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "img", "Hinh", "HangHoa");
            if (!Directory.Exists(directoryPath)) {
                Directory.CreateDirectory(directoryPath);
            }
            var path = Path.Combine(directoryPath, fileName);

            using (var stream = new FileStream(path, FileMode.Create)) {
                await file.CopyToAsync(stream);
            }
            return fileName;
        }

        // GET: HangHoas/Edit/5
        [Authorize(Roles = "Admin,Staff")]
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
        [Authorize(Roles = "Admin,Staff")]
        public async Task<IActionResult> Edit(int id, [Bind("MaHh,TenHh,TenAlias,MaLoai,MoTaDonVi,DonGia,Hinh,NgaySx,GiamGia,SoLanXem,MoTa,MaNcc,SoLuong,HieuLuc")] HangHoa hangHoa, IFormFile? fHinh) {
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
                hangHoa.HieuLuc = false;
                hangHoa.SoLuong = 0; // Đặt số lượng về 0 (Hết hàng)
                _context.Update(hangHoa);
                TempData["Success"] = "Đã ngưng hoạt động sản phẩm và chuyển thành Hết hàng!";
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index), new { manage = true });
        }

        // POST: HangHoas/Reactivate/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Roles = "Admin,Staff")]
        public async Task<IActionResult> Reactivate(int id) {
            var hangHoa = await _context.HangHoas.FindAsync(id);
            if (hangHoa != null) {
                hangHoa.HieuLuc = true;
                if (hangHoa.SoLuong <= 0) {
                    hangHoa.SoLuong = 10; // Đặt lại số lượng mặc định là 10
                }
                _context.Update(hangHoa);
                TempData["Success"] = "Đã kích hoạt lại sản phẩm!";
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Index), new { manage = true });
        }

        private bool HangHoaExists(int id) {
            return _context.HangHoas.Any(e => e.MaHh == id);
        }
    }
}
