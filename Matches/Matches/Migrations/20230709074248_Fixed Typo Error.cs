using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Matches.Migrations
{
    /// <inheritdoc />
    public partial class FixedTypoError : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ScoreCard_InningsScoreCards_VistorTeamInningsId",
                table: "ScoreCard");

            migrationBuilder.RenameColumn(
                name: "VistorTeamInningsId",
                table: "ScoreCard",
                newName: "VisitorTeamInningsId");

            migrationBuilder.RenameIndex(
                name: "IX_ScoreCard_VistorTeamInningsId",
                table: "ScoreCard",
                newName: "IX_ScoreCard_VisitorTeamInningsId");

            migrationBuilder.AddForeignKey(
                name: "FK_ScoreCard_InningsScoreCards_VisitorTeamInningsId",
                table: "ScoreCard",
                column: "VisitorTeamInningsId",
                principalTable: "InningsScoreCards",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ScoreCard_InningsScoreCards_VisitorTeamInningsId",
                table: "ScoreCard");

            migrationBuilder.RenameColumn(
                name: "VisitorTeamInningsId",
                table: "ScoreCard",
                newName: "VistorTeamInningsId");

            migrationBuilder.RenameIndex(
                name: "IX_ScoreCard_VisitorTeamInningsId",
                table: "ScoreCard",
                newName: "IX_ScoreCard_VistorTeamInningsId");

            migrationBuilder.AddForeignKey(
                name: "FK_ScoreCard_InningsScoreCards_VistorTeamInningsId",
                table: "ScoreCard",
                column: "VistorTeamInningsId",
                principalTable: "InningsScoreCards",
                principalColumn: "Id");
        }
    }
}
