using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace KamilDelektaEFProducts2
{
    [Table("CustomeTypeH")]
    public class CustomerTypeH: CompanyTypeH
    {
        public float Discount { get; set; }
    }
}
