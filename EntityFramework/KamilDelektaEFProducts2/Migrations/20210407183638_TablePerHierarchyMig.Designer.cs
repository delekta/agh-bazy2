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
    [Migration("20210407183638_TablePerHierarchyMig")]
    partial class TablePerHierarchyMig
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

            modelBuilder.Entity("KamilDelektaEFProducts2.Supplier", b =>
                {
                    b.Navigation("Products");
                });
#pragma warning restore 612, 618
        }
    }
}
