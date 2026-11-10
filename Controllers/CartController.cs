using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.Services;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    [Authorize]
    public class CartController : Controller
    {
        private readonly IConsumeApi _api;

        public CartController(IConsumeApi api)
        {
            _api = api;
        }

        private string GetJwtToken()
        {
            return HttpContext.Session.GetString("JWT_TOKEN") ?? string.Empty;
        }

        // GET: Cart
        public async Task<IActionResult> Index()
        {
            var token = GetJwtToken();
            var res = await _api.GetAsync("Cart", null, token);

            var cartItems = new List<CartItem>();
            if (res.Success && res.Data != null)
            {
                if (res.Data.items != null)
                {
                    cartItems = JsonConvert.DeserializeObject<List<CartItem>>(JsonConvert.SerializeObject(res.Data.items)) ?? new List<CartItem>();
                }
            }

            return View(cartItems);
        }

        // GET: Cart/AddToCart/5
        public async Task<IActionResult> AddToCart(int id, int quantity = 1)
        {
            var token = GetJwtToken();
            var pars = new Dictionary<string, dynamic> { { "quantity", quantity } };

            var res = await _api.PostAsync($"Cart/add/{id}?quantity={quantity}", null, token);
            if (!res.Success)
            {
                TempData["Error"] = res.Message;
            }

            return RedirectToAction("Index");
        }

        // GET: Cart/Delete/5
        public async Task<IActionResult> Delete(int id)
        {
            var token = GetJwtToken();
            var res = await _api.DeleteAsync($"Cart/delete/{id}", null, token);

            if (!res.Success)
            {
                TempData["Error"] = res.Message;
            }

            return RedirectToAction("Index");
        }

        // GET: Cart/UpdateQuantity?id=5&delta=1
        public async Task<IActionResult> UpdateQuantity(int id, int delta)
        {
            var token = GetJwtToken();
            var res = await _api.PutAsync($"Cart/update-quantity/{id}?delta={delta}", null, token);

            if (!res.Success)
            {
                TempData["Error"] = res.Message;
            }

            return RedirectToAction("Index");
        }

        // GET: Cart/Checkout
        [HttpGet]
        public async Task<IActionResult> Checkout()
        {
            var token = GetJwtToken();
            var res = await _api.GetAsync("Cart/checkout", null, token);

            if (!res.Success || res.Data == null)
            {
                TempData["Error"] = res.Message ?? "Không thể lấy thông tin thanh toán.";
                return RedirectToAction("Index");
            }

            var model = new CheckoutVM();
            if (res.Data.customerInfo != null)
            {
                model.HoTen = res.Data.customerInfo.hoTen ?? "";
                model.DiaChi = res.Data.customerInfo.diaChi ?? "";
            }

            if (res.Data.cartItems != null)
            {
                var cartItems = JsonConvert.DeserializeObject<List<CartItem>>(JsonConvert.SerializeObject(res.Data.cartItems));
                ViewBag.Cart = cartItems;
            }

            ViewBag.TotalPrice = (double)(res.Data.totalPrice ?? 0);
            ViewBag.ShippingFee = (double)(res.Data.shippingFee ?? 0);
            ViewBag.FinalTotal = (double)(res.Data.finalTotal ?? 0);

            return View(model);
        }

        // POST: Cart/Checkout
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Checkout(CheckoutVM model)
        {
            var token = GetJwtToken();

            if (ModelState.IsValid)
            {
                var body = new
                {
                    HoTen = model.HoTen,
                    DiaChi = model.DiaChi,
                    GhiChu = model.GhiChu
                };

                var res = await _api.PostAsync("Cart/checkout", body, token);
                if (res.Success && res.Data != null)
                {
                    int orderId = (int)(res.Data.orderId ?? 0);
                    return RedirectToAction("Success", new { id = orderId });
                }

                ModelState.AddModelError(string.Empty, res.Message ?? "Đặt hàng thất bại.");
            }

            // Nếu thất bại thì lấy lại giỏ hàng hiển thị
            var resCart = await _api.GetAsync("Cart/checkout", null, token);
            if (resCart.Success && resCart.Data != null)
            {
                if (resCart.Data.cartItems != null)
                {
                    ViewBag.Cart = JsonConvert.DeserializeObject<List<CartItem>>(JsonConvert.SerializeObject(resCart.Data.cartItems));
                }
                ViewBag.TotalPrice = (double)(resCart.Data.totalPrice ?? 0);
                ViewBag.ShippingFee = (double)(resCart.Data.shippingFee ?? 0);
                ViewBag.FinalTotal = (double)(resCart.Data.finalTotal ?? 0);
            }

            return View(model);
        }

        // GET: Cart/Success/5
        public IActionResult Success(int id)
        {
            ViewBag.OrderId = id;
            return View();
        }
    }
}
