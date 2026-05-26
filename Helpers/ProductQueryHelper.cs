using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Models;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace LTWEB_QuaMonHai_CuoiKy.Helpers
{
    public static class ProductQueryHelper
    {
        public static async Task<List<HangHoa>> GetFilteredProductsAsync(
            Hshop2023Context context,
            ClaimsPrincipal user,
            dynamic viewBag,
            int? loaiId,
            string searchQuery,
            string priceRange,
            string sortBy,
            int page,
            bool manage = false)
        {
            int pageSize = 9;

            var favoriteProductIds = new List<int>();
            if (user.Identity?.IsAuthenticated == true) {
                var customerId = user.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value;
                if (!string.IsNullOrEmpty(customerId)) {
                    favoriteProductIds = await context.YeuThiches
                        .Where(y => y.MaKh == customerId && y.MaHh.HasValue)
                        .Select(y => y.MaHh ?? 0)
                        .ToListAsync();
                }
            }
            viewBag.FavoriteProductIds = favoriteProductIds;

            viewBag.DanhMucs = await context.Loais.Include(l => l.HangHoas).AsNoTracking().ToListAsync();
            viewBag.TotalProductCount = await context.HangHoas.CountAsync();
            viewBag.CurrentLoai = loaiId;
            viewBag.CurrentSort = sortBy;

            var query = context.HangHoas
                                .Include(h => h.MaLoaiNavigation)
                                .AsNoTracking()
                                .AsQueryable();

            bool isManager = user.IsInRole("Admin") || user.IsInRole("Staff");
            if (manage && isManager) {
                viewBag.ManageMode = true;
            } else {
                query = query.Where(h => h.HieuLuc && h.SoLuong > 0);
                viewBag.ManageMode = false;
            }

            if (loaiId.HasValue) {
                query = query.Where(h => h.MaLoai == loaiId.Value);
            }

            if (!string.IsNullOrEmpty(searchQuery)) {
                query = query.Where(h => h.TenHh.Contains(searchQuery));
            }

            if (!string.IsNullOrEmpty(priceRange)) {
                if (decimal.TryParse(priceRange, out decimal maxVal)) {
                    query = query.Where(h => h.GiaSauGiam <= maxVal);
                } else {
                    switch (priceRange) {
                        case "under50":
                            query = query.Where(h => h.GiaSauGiam < 50);
                            break;
                        case "50to100":
                            query = query.Where(h => h.GiaSauGiam >= 50 && h.GiaSauGiam <= 100);
                            break;
                        case "over100":
                            query = query.Where(h => h.GiaSauGiam > 100);
                            break;
                    }
                }
            }

            if (sortBy == "price_asc") {
                query = query.OrderBy(h => h.GiaSauGiam);
            } else if (sortBy == "price_desc") {
                query = query.OrderByDescending(h => h.GiaSauGiam);
            }

            int totalItems = await query.CountAsync();
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            var items = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            var productIds = items.Select(i => i.MaHh).ToList();
            var soldCounts = await context.ChiTietHds
                .Where(ct => productIds.Contains(ct.MaHh) && ct.MaHdNavigation.MaTrangThai != -1)
                .GroupBy(ct => ct.MaHh)
                .Select(g => new { MaHh = g.Key, TotalSold = g.Sum(ct => ct.SoLuong) })
                .ToDictionaryAsync(x => x.MaHh, x => x.TotalSold);
            viewBag.SoldCounts = soldCounts;

            viewBag.CurrentPage = page;
            viewBag.TotalPages = totalPages;

            return items;
        }
    }
}
