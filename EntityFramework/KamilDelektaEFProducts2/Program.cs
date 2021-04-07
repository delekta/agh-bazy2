using System;
using System.Collections.Generic;
using System.Linq;
namespace KamilDelektaEFProducts2
{
    class Program
    {
        static void Main(string[] args)
        {
            ProductContext productContext = new ProductContext();
            // I
            ////Dodawanie dostawcy
            //Console.WriteLine("Podaj nazwe firmy:");
            //string suppName = Console.ReadLine();
            //Console.WriteLine("Podaj ulice:");
            //string suppStreet = Console.ReadLine();
            //Console.WriteLine("Podaj miasto:");
            //string suppCity = Console.ReadLine();
            //Supplier supplier = new Supplier
            //{
            //    CompanyName = suppName,
            //    City = suppCity,
            //    Street = suppStreet
            //};
            //productContext.Suppliers.Add(supplier);
            //productContext.SaveChanges();

            //// Dodawanie Produktu
            //Console.WriteLine("Podaj nazwe produktu:");
            //string prodName = Console.ReadLine();
            //Product product = new Product
            //{
            //    ProductName = prodName,
            //    UnitsOnStock = 10,
            //    Supplier = supplier
            //};
            //productContext.Products.Add(product);
            //productContext.SaveChanges();

            // Update bazy
            //using (var context = new ProductContext())
            //{
            //    var prod = context.Products.FirstOrDefault(item => item.ProductID == 2);
            //    var supp = context.Suppliers.FirstOrDefault(item => item.SupplierID == 1);
            //    // Validate entity is not null
            //    if (prod != null && supp != null)
            //    {
            //        prod.Supplier = supp;
            //        context.SaveChanges();
            //    }
            //    else if (prod == null)
            //    {
            //        Console.WriteLine("prod is null");
            //    }
            //    else if (supp == null)
            //    {
            //        Console.WriteLine("supp is null");
            //    }

            //}

            //var query = from prod in productContext.Products select prod.ProductName;
            //foreach (var pName in query)
            //{
            //    Console.WriteLine(pName);
            //}
            //Console.WriteLine("Koniec");

            // II
            //Product product1 = new Product { ProductName = "Frytki z posypka" };
            //Product product2 = new Product { ProductName = "Kebab na ostrym" };
            //productContext.Products.Add(product1);
            //productContext.Products.Add(product2);
            //var supp = productContext.Suppliers.FirstOrDefault(item => item.SupplierID == 3);
            //if (supp != null)
            //{
            //    supp.Products = new System.Collections.Generic.List<Product>();
            //    supp.Products.Add(product1);
            //    supp.Products.Add(product2);
            //    productContext.SaveChanges();
            //    Console.WriteLine("Udalo sie dodac");
            //}
            //foreach (var s in productContext.Suppliers)
            //{
            //    Console.WriteLine(s.SupplierID.ToString() + ": ");
            //    foreach (var item in s.Products)
            //    {
            //        Console.Write(item.ProductName);
            //    }
            //}
            //Console.WriteLine("Koniec");

            // III
            //Product product1 = new Product { ProductName = "Hamburger" };
            //Product product2 = new Product { ProductName = "Cheeseburger" };
            //productContext.Products.Add(product1);
            //productContext.Products.Add(product2);
            //var supp = productContext.Suppliers.FirstOrDefault(item => item.SupplierID == 2);
            //if (supp != null)
            //{
            //    supp.Products.Add(product1);
            //    supp.Products.Add(product2);
            //    productContext.SaveChanges();
            //    Console.WriteLine("Udalo sie dodac");
            //}
            //foreach (var s in productContext.Suppliers)
            //{
            //    Console.WriteLine(s.SupplierID.ToString() + ": ");
            //    foreach (var item in s.Products)
            //    {
            //        Console.Write(item.ProductName);
            //    }
            //}
            //Console.WriteLine("Koniec");

            // IV
            //Product product1 = new Product { ProductName = "Hamburger" };
            //Product product2 = new Product { ProductName = "Cheeseburger" };
            //Product product3 = new Product { ProductName = "Nuggetsy" };

            //Invoice invoice1 = new Invoice { InvoiceNumber = 1, Quantity = 2 };
            //Invoice invoice2 = new Invoice { InvoiceNumber = 2, Quantity = 3 };

            //invoice1.Products = new List<Product>();
            //invoice1.Products.Add(product1);
            //invoice1.Products.Add(product2);

            //invoice2.Products = new List<Product>();
            //invoice2.Products.Add(product1);
            //invoice2.Products.Add(product2);
            //invoice2.Products.Add(product3);

            //productContext.Products.Add(product1);
            //productContext.Products.Add(product2);
            //productContext.Products.Add(product3);

            //productContext.Invoices.Add(invoice1);
            //productContext.Invoices.Add(invoice2);

            //productContext.SaveChanges();

            //Console.WriteLine("Koniec");

            //test
            //using(var ctx = new ProductContext())
            //{
            //    foreach (var inv in ctx.Invoices)
            //    {
            //        Console.WriteLine(" Faktura " + inv.InvoiceID.ToString() + ": ");
            //        foreach (var pro in inv.Products)
            //        {
            //            Console.WriteLine("Produkt: " + pro.ProductName);
            //        }
            //    }
            //}

            // V
            //using (var context = new ProductContext())
            //{
            //    Supplier2 supp = new Supplier2()
            //    {
            //        CompanyName = "KFC",
            //        City = "Rzeszow",
            //        Street = "Wolja",
            //        ZipCode = "38-122",
            //        bankAccountNumber = "1234 5678"
            //    };

            //    Customer cust = new Customer()
            //    {
            //        CompanyName = "McDonald",
            //        City = "Krakow",
            //        Street = "Wolna",
            //        ZipCode = "31-129",
            //        Discount = 0.2F
            //    };

            //    context.Companies.Add(supp);
            //    context.Companies.Add(cust);

            //    context.SaveChanges();
            //}

            // VI
            using (var context = new ProductContext())
            {
                SupplierTypeH supp = new SupplierTypeH()
                {
                    CompanyName = "Subway",
                    Street = "Szybsza",
                    City = "Gorno",
                    ZipCode = "124-532",
                    bankAccountNumber = "1354 1244"
                };
                CustomerTypeH cust = new CustomerTypeH()
                {
                    CompanyName = "Burger King",
                    Street = "Szybka",
                    City = "Lowisko",
                    ZipCode = "123-241",
                    Discount = 0.3F
                };
                context.CompaniesTypeH.Add(supp);
                context.CompaniesTypeH.Add(cust);
                context.SaveChanges();
            }
            Console.WriteLine("Koniec");

        }
    }
}
