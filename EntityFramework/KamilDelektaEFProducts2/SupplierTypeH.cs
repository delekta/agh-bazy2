using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace KamilDelektaEFProducts2
{
    [Table("SupplierTypeH")]
    public class SupplierTypeH: CompanyTypeH
    {
        public string bankAccountNumber { get; set; }
    }
}
