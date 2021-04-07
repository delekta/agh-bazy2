using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
namespace KamilDelektaEFProducts2
{
    public class Invoice
    {
        public int InvoiceID { get; set; }
        public int InvoiceNumber { get; set; }
        public int Quantity { get; set; }
        public virtual ICollection<Product> Products { get; set; }
    }
}
