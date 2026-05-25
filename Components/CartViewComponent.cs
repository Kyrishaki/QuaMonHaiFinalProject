using System.Security.Claims;
using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LTWEB_QuaMonHai_CuoiKy.Components
{
    public class CartViewComponent : ViewComponent
    {
        private readonly Hshop2023Context _context;

        public CartViewComponent(Hshop2023Context context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            var customerId = UserClaimsPrincipal.Claims.SingleOrDefault(c => c.Type == "CustomerID")?.Value
                ?? UserClaimsPrincipal.Claims.SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;

            var sessionQuantity = HttpContext.Session
                .Get<List<CartItem>>(mySetting.ShopCart)?
                .Sum(item => item.SoLuong) ?? 0;

            if (string.IsNullOrEmpty(customerId))
            {
                return View("Default", sessionQuantity);
            }

            var databaseQuantity = await _context.GioHangs
                .Where(item => item.MaKh == customerId)
                .SumAsync(item => (int?)item.SoLuong) ?? 0;

            return View("Default", databaseQuantity + sessionQuantity);
        }
    }
}
