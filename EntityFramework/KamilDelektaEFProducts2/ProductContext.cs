using System;
using Microsoft.EntityFrameworkCore;
namespace KamilDelektaEFProducts2
{
    public class ProductContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Supplier> Suppliers { get; set; }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<Company> Companies { get; set; }
        public DbSet<CompanyTypeH> CompaniesTypeH { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            optionsBuilder.UseSqlite("Datasource=ProductDatabase");
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<SupplierTypeH>();
            builder.Entity<CustomerTypeH>();

            builder.Entity<Supplier2>();
            builder.Entity<Customer>();


            base.OnModelCreating(builder);
        }
    }
}
