using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Matches.Migrations
{
    /// <inheritdoc />
    public partial class InsertedTeamNameinScoreCardFeild : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "HostTeamId",
                table: "ScoreCard",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "HostTeamName",
                table: "ScoreCard",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VisitorTeamName",
                table: "ScoreCard",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "VistorTeamId",
                table: "ScoreCard",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "HostTeamId",
                table: "ScoreCard");

            migrationBuilder.DropColumn(
                name: "HostTeamName",
                table: "ScoreCard");

            migrationBuilder.DropColumn(
                name: "VisitorTeamName",
                table: "ScoreCard");

            migrationBuilder.DropColumn(
                name: "VistorTeamId",
                table: "ScoreCard");
        }
    }
}
