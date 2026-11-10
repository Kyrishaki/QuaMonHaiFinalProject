namespace LTWEB_QuaMonHai_CuoiKy.ViewModels
{
    public class ResponseData
    {
        public bool Success { get; set; }
        public string Message { get; set; } = string.Empty;
        public dynamic? Data { get; set; }
        public long Time { get; set; }
        public string Error { get; set; } = string.Empty;

        public ResponseData()
        {
            Success = true;
            Message = "ResponseData is Ok";
            Time = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            Data = null;
        }

        public ResponseData(bool success, string message, dynamic? data = null, string error = "")
        {
            Success = success;
            Message = message;
            Data = data;
            Time = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            Error = error;
        }
    }
}
