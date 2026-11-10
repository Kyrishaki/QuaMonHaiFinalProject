using LTWEB_QuaMonHai_CuoiKy.ViewModels;

namespace LTWEB_QuaMonHai_CuoiKy.Services
{
    public interface IConsumeApi
    {
        Task<ResponseData> GetAsync(string endpoint, Dictionary<string, dynamic>? dictPars = null, string accessToken = "");
        Task<ResponseData> PostAsync(string endpoint, object? bodyData = null, string accessToken = "");
        Task<ResponseData> PostFormAsync(string endpoint, MultipartFormDataContent formContent, string accessToken = "");
        Task<ResponseData> PutAsync(string endpoint, object? bodyData = null, string accessToken = "");
        Task<ResponseData> PutFormAsync(string endpoint, MultipartFormDataContent formContent, string accessToken = "");
        Task<ResponseData> DeleteAsync(string endpoint, Dictionary<string, dynamic>? dictPars = null, string accessToken = "");
    }
}
