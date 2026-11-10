using LTWEB_QuaMonHai_CuoiKy.ViewModels;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

namespace LTWEB_QuaMonHai_CuoiKy.Services
{
    public class ConsumeApi : IConsumeApi
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _configuration;
        private readonly Uri _baseAddress;

        public ConsumeApi(IConfiguration configuration, IHttpClientFactory clientFactory)
        {
            _configuration = configuration;
            string urlApi = _configuration["ApiSettings:UrlApi"] ?? "https://localhost:7224/api/";
            _baseAddress = new Uri(urlApi);
            _httpClient = clientFactory.CreateClient("ApiClient");
        }

        public async Task<ResponseData> GetAsync(string endpoint, Dictionary<string, dynamic>? dictPars = null, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            if (dictPars != null && dictPars.Any())
            {
                string parameters = "?";
                int i = 0;
                foreach (KeyValuePair<string, dynamic> item in dictPars)
                {
                    if (item.Value != null)
                    {
                        parameters += (i == 0 ? "" : "&") + $"{item.Key}={Uri.EscapeDataString(item.Value.ToString())}";
                        i++;
                    }
                }
                uriApi += parameters;
            }

            using var request = new HttpRequestMessage(HttpMethod.Get, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }

        public async Task<ResponseData> PostAsync(string endpoint, object? bodyData = null, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            using var request = new HttpRequestMessage(HttpMethod.Post, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }

            if (bodyData != null)
            {
                string jsonBody = JsonConvert.SerializeObject(bodyData);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
            }

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }

        public async Task<ResponseData> PostFormAsync(string endpoint, MultipartFormDataContent formContent, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            using var request = new HttpRequestMessage(HttpMethod.Post, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }
            request.Content = formContent;

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }

        public async Task<ResponseData> PutAsync(string endpoint, object? bodyData = null, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            using var request = new HttpRequestMessage(HttpMethod.Put, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }

            if (bodyData != null)
            {
                string jsonBody = JsonConvert.SerializeObject(bodyData);
                request.Content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
            }

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }

        public async Task<ResponseData> PutFormAsync(string endpoint, MultipartFormDataContent formContent, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            using var request = new HttpRequestMessage(HttpMethod.Put, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }
            request.Content = formContent;

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }

        public async Task<ResponseData> DeleteAsync(string endpoint, Dictionary<string, dynamic>? dictPars = null, string accessToken = "")
        {
            ResponseData res = new ResponseData();
            string uriApi = _baseAddress.ToString() + endpoint;

            if (dictPars != null && dictPars.Any())
            {
                string parameters = "?";
                int i = 0;
                foreach (KeyValuePair<string, dynamic> item in dictPars)
                {
                    if (item.Value != null)
                    {
                        parameters += (i == 0 ? "" : "&") + $"{item.Key}={Uri.EscapeDataString(item.Value.ToString())}";
                        i++;
                    }
                }
                uriApi += parameters;
            }

            using var request = new HttpRequestMessage(HttpMethod.Delete, uriApi);
            if (!string.IsNullOrEmpty(accessToken))
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);
            }

            try
            {
                HttpResponseMessage response = await _httpClient.SendAsync(request);
                var content = await response.Content.ReadAsStringAsync();
                if (!string.IsNullOrEmpty(content))
                {
                    res = JsonConvert.DeserializeObject<ResponseData>(content) ?? new ResponseData();
                }
                else
                {
                    res.Success = response.IsSuccessStatusCode;
                    res.Message = response.ReasonPhrase ?? "";
                }
            }
            catch (Exception ex)
            {
                res.Success = false;
                res.Message = "Lỗi kết nối tới API: " + ex.Message;
                res.Error = ex.ToString();
            }

            return res;
        }
    }
}
