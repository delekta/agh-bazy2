using System;
namespace KamilDelektaEFProducts2
{
    public abstract class CompanyTypeH
    {
        public int CompanyTypeHID { get; set; }
        public string CompanyName { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
    }
}
