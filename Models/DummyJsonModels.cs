using System.Collections.Generic;

namespace LTWEB_QuaMonHai_CuoiKy.Models
{
    public class ProductApiResponse
    {
        public List<ApiProduct> products { get; set; }
        public int total { get; set; }
    }

    public class ApiProduct
    {
        public int id { get; set; }
        public string title { get; set; }
        public string description { get; set; }
        public double price { get; set; }
        public double discountPercentage { get; set; }
        public string category { get; set; }
        public string thumbnail { get; set; }
        public string brand { get; set; }
    }
}