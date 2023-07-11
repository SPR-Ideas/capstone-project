using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Matches.Migrations
{
    /// <inheritdoc />
    public partial class fixedTypoErrors : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Sore",
                table: "InningsScoreCards",
                newName: "Score");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Score",
                table: "InningsScoreCards",
                newName: "Sore");
        }
    }
}
