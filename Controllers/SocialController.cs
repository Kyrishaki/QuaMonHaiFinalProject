using LTWEB_QuaMonHai_CuoiKy.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class SocialController : Controller
    {
        private readonly Hshop2023Context _context;

        public SocialController(Hshop2023Context context)
        {
            _context = context;
        }

        public async Task<IActionResult> Facebook()
        {
            var products = await _context.HangHoas.Where(h => h.HieuLuc).Take(3).ToListAsync();
            return View(products);
        }

        public async Task<IActionResult> X()
        {
            var products = await _context.HangHoas.Where(h => h.HieuLuc).Take(3).ToListAsync();
            return View(products);
        }

        public async Task<IActionResult> Instagram()
        {
            var products = await _context.HangHoas.Where(h => h.HieuLuc).Take(9).ToListAsync();
            return View(products);
        }

        public async Task<IActionResult> LinkedIn()
        {
            var products = await _context.HangHoas.Where(h => h.HieuLuc).Take(3).ToListAsync();
            return View(products);
        }
    }
}
