using Microsoft.EntityFrameworkCore.Migrations;

namespace KamilDelektaEFProducts2.Migrations
{
    public partial class PerTypeHierarchyFix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CompaniesTypeH",
                columns: table => new
                {
                    CompanyTypeHID = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    CompanyName = table.Column<string>(type: "TEXT", nullable: true),
                    Street = table.Column<string>(type: "TEXT", nullable: true),
                    City = table.Column<string>(type: "TEXT", nullable: true),
                    ZipCode = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompaniesTypeH", x => x.CompanyTypeHID);
                });

            migrationBuilder.CreateTable(
                name: "CustomeTypeH",
                columns: table => new
                {
                    CompanyTypeHID = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    Discount = table.Column<float>(type: "REAL", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomeTypeH", x => x.CompanyTypeHID);
                    table.ForeignKey(
                        name: "FK_CustomeTypeH_CompaniesTypeH_CompanyTypeHID",
                        column: x => x.CompanyTypeHID,
                        principalTable: "CompaniesTypeH",
                        principalColumn: "CompanyTypeHID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "SupplierTypeH",
                columns: table => new
                {
                    CompanyTypeHID = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    bankAccountNumber = table.Column<string>(type: "TEXT", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SupplierTypeH", x => x.CompanyTypeHID);
                    table.ForeignKey(
                        name: "FK_SupplierTypeH_CompaniesTypeH_CompanyTypeHID",
                        column: x => x.CompanyTypeHID,
                        principalTable: "CompaniesTypeH",
                        principalColumn: "CompanyTypeHID",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CustomeTypeH");

            migrationBuilder.DropTable(
                name: "SupplierTypeH");

            migrationBuilder.DropTable(
                name: "CompaniesTypeH");
        }
    }
}
