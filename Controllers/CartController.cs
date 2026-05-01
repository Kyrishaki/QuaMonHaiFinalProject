using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using Microsoft.AspNetCore.Mvc;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class CartController : Controller
    {
        readonly Hshop2023Context _Context;
        public CartController(Hshop2023Context context)
        {
            _Context = context;
        }
        public List<CartItem> cart()
        {
            return HttpContext.Session.Get<List<CartItem>>("cart") ?? new List<CartItem>();
        }
        public IActionResult Index()
        {
            return View(cart());
        }

        public IActionResult AddToCart(int id, int quantity = 1) // chưa xử lý được thêm số lượng ở trang chi tiết sản phẩm
        {
            var giohang = cart();
            var product = giohang.SingleOrDefault(p => p.MaHh == id);
            if (product == null)
            {
                var hanghoa = _Context.HangHoas.SingleOrDefault(p => p.MaHh == id);
                if (hanghoa == null)
                {
                    return NotFound();
                }
                product = new CartItem
                {
                    MaHh = hanghoa.MaHh,
                    TenHh = hanghoa.TenHh,
                    DonGia = hanghoa.DonGia ??0,
                    Hinh = hanghoa.Hinh,
                    SoLuong = quantity
                };
                giohang.Add(product);
            }
            else
            {
                product.SoLuong += quantity;
            }
            HttpContext.Session.Set("cart", giohang);
            return RedirectToAction("Index");
        }
        public IActionResult Delete(int id )
        {
            var giohang = cart();
            var itemToRemove = giohang.SingleOrDefault(x => x.MaHh == id);
            if (itemToRemove != null)
            {
                giohang.Remove(itemToRemove);
                HttpContext.Session.Set("cart", giohang);
            }
            return RedirectToAction("Index");

        }
    }
}
