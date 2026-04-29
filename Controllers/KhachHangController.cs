using AutoMapper;
using LTWEB_QuaMonHai_CuoiKy.Data;
using LTWEB_QuaMonHai_CuoiKy.Helpers;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Microsoft.AspNetCore.Mvc;

namespace LTWEB_QuaMonHai_CuoiKy.Controllers
{
    public class KhachHangController : Controller
    {
        private readonly Hshop2023Context db;
        private readonly IMapper _mapper;

        public KhachHangController(Hshop2023Context context, IMapper mapper) 
        {
            db =context;
            _mapper = mapper;
        }

        [HttpGet]
        public IActionResult DangKy()
        {
            return View();
        }

        [HttpPost]
        public IActionResult DangKy(RegisterVM model)
        {
            if(ModelState.IsValid)
            {
                var khachHang = _mapper.Map<KhachHang>(model);
                khachHang.RandomKey = MyUtil.GenerateRandomKey();


            }    
            return View();
        }
    }
}
