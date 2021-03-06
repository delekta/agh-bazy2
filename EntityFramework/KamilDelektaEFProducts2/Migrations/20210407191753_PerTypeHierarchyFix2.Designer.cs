// <auto-generated />
using System;
using KamilDelektaEFProducts2;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace KamilDelektaEFProducts2.Migrations
{
    [DbContext(typeof(ProductContext))]
    [Migration("20210407191753_PerTypeHierarchyFix2")]
    partial class PerTypeHierarchyFix2
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "5.0.5");

            modelBuilder.Entity("InvoiceProduct", b =>
                {
                    b.Property<int>("InvoicesInvoiceID")
                        .HasColumnType("INTEGER");

                    b.Property<int>("ProductsProductID")
                        .HasColumnType("INTEGER");

                    b.HasKey("InvoicesInvoiceID", "ProductsProductID");

                    b.HasIndex("ProductsProductID");

                    b.ToTable("InvoiceProduct");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Company", b =>
                {
                    b.Property<int>("CompanyID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("City")
                        .HasColumnType("TEXT");

                    b.Property<string>("CompanyName")
                        .HasColumnType("TEXT");

                    b.Property<string>("Discriminator")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .HasColumnType("TEXT");

                    b.Property<string>("ZipCode")
                        .HasColumnType("TEXT");

                    b.HasKey("CompanyID");

                    b.ToTable("Companies");

                    b.HasDiscriminator<string>("Discriminator").HasValue("Company");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.CompanyTypeH", b =>
                {
                    b.Property<int>("CompanyTypeHID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("City")
                        .HasColumnType("TEXT");

                    b.Property<string>("CompanyName")
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .HasColumnType("TEXT");

                    b.Property<string>("ZipCode")
                        .HasColumnType("TEXT");

                    b.HasKey("CompanyTypeHID");

                    b.ToTable("CompaniesTypeH");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Invoice", b =>
                {
                    b.Property<int>("InvoiceID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<int>("InvoiceNumber")
                        .HasColumnType("INTEGER");

                    b.Property<int>("Quantity")
                        .HasColumnType("INTEGER");

                    b.HasKey("InvoiceID");

                    b.ToTable("Invoices");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Product", b =>
                {
                    b.Property<int>("ProductID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("ProductName")
                        .HasColumnType("TEXT");

                    b.Property<int?>("SupplierID")
                        .HasColumnType("INTEGER");

                    b.Property<int>("UnitsOnStock")
                        .HasColumnType("INTEGER");

                    b.HasKey("ProductID");

                    b.HasIndex("SupplierID");

                    b.ToTable("Products");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Supplier", b =>
                {
                    b.Property<int>("SupplierID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("City")
                        .HasColumnType("TEXT");

                    b.Property<string>("CompanyName")
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .HasColumnType("TEXT");

                    b.HasKey("SupplierID");

                    b.ToTable("Suppliers");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Customer", b =>
                {
                    b.HasBaseType("KamilDelektaEFProducts2.Company");

                    b.Property<float>("Discount")
                        .HasColumnType("REAL");

                    b.HasDiscriminator().HasValue("Customer");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Supplier2", b =>
                {
                    b.HasBaseType("KamilDelektaEFProducts2.Company");

                    b.Property<string>("bankAccountNumber")
                        .HasColumnType("TEXT");

                    b.HasDiscriminator().HasValue("Supplier2");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.CustomerTypeH", b =>
                {
                    b.HasBaseType("KamilDelektaEFProducts2.CompanyTypeH");

                    b.Property<float>("Discount")
                        .HasColumnType("REAL");

                    b.ToTable("CustomeTypeH");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.SupplierTypeH", b =>
                {
                    b.HasBaseType("KamilDelektaEFProducts2.CompanyTypeH");

                    b.Property<string>("bankAccountNumber")
                        .HasColumnType("TEXT");

                    b.ToTable("SupplierTypeH");
                });

            modelBuilder.Entity("InvoiceProduct", b =>
                {
                    b.HasOne("KamilDelektaEFProducts2.Invoice", null)
                        .WithMany()
                        .HasForeignKey("InvoicesInvoiceID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("KamilDelektaEFProducts2.Product", null)
                        .WithMany()
                        .HasForeignKey("ProductsProductID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Product", b =>
                {
                    b.HasOne("KamilDelektaEFProducts2.Supplier", "Supplier")
                        .WithMany("Products")
                        .HasForeignKey("SupplierID");

                    b.Navigation("Supplier");
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.CustomerTypeH", b =>
                {
                    b.HasOne("KamilDelektaEFProducts2.CompanyTypeH", null)
                        .WithOne()
                        .HasForeignKey("KamilDelektaEFProducts2.CustomerTypeH", "CompanyTypeHID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.SupplierTypeH", b =>
                {
                    b.HasOne("KamilDelektaEFProducts2.CompanyTypeH", null)
                        .WithOne()
                        .HasForeignKey("KamilDelektaEFProducts2.SupplierTypeH", "CompanyTypeHID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("KamilDelektaEFProducts2.Supplier", b =>
                {
                    b.Navigation("Products");
                });
#pragma warning restore 612, 618
        }
    }
}
