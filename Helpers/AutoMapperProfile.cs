using AutoMapper;
using LTWEB_QuaMonHai_CuoiKy.Models;
using LTWEB_QuaMonHai_CuoiKy.ViewModels;
namespace LTWEB_QuaMonHai_CuoiKy.Helpers
{
    public class AutoMapperProfile : Profile
    {
        public AutoMapperProfile() 
        {
            CreateMap<RegisterVM, KhachHang>();
                //.ForMember(kh => kh.HoTen, option => option.MapFrom(RegisterVM => 
                //  RegisterVM.HoTen))
                //.ReverseMap();
        }
    }
}
