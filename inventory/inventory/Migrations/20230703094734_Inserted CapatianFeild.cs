using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace inventory.Migrations
{
    /// <inheritdoc />
    public partial class InsertedCapatianFeild : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "CaptainId",
                table: "Teams",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Result",
                table: "Matches",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CaptainId",
                table: "Teams");

            migrationBuilder.DropColumn(
                name: "Result",
                table: "Matches");
        }
    }
}
