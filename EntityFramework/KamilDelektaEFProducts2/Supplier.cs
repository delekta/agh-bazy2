using System;
using System.Collections.Generic;
namespace KamilDelektaEFProducts2
{
    public class Supplier
    {
        public int SupplierID { get; set; }
        public string CompanyName { get; set; }
        public string Street { get; set; }
        public string City { get; set; }
        // Nedded to one-to-many relationship
        public virtual List<Product> Products { get; set; } = new System.Collections.Generic.List<Product>();
    }
}
