using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Matches.Migrations
{
    /// <inheritdoc />
    public partial class AddedCurrentState : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "IsCurrent",
                table: "BlowingInnings",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "IsCurrent",
                table: "BattingInnings",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsCurrent",
                table: "BlowingInnings");

            migrationBuilder.DropColumn(
                name: "IsCurrent",
                table: "BattingInnings");
        }
    }
}
