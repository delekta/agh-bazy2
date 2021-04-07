using System;
using System.Collections.Generic;
namespace KamilDelektaEFProducts2
{
    public class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int UnitsOnStock { get; set; }
        // Nedded to one-to-many relationship
        public Supplier Supplier { get; set; }

        public virtual ICollection<Invoice> Invoices { get; set; }
    }
}
