using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Matches.Migrations
{
    /// <inheritdoc />
    public partial class ModifiedInningsScoreCard : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "InningsScoreCards",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Wickets = table.Column<int>(type: "int", nullable: false),
                    Balls = table.Column<int>(type: "int", nullable: false),
                    Sore = table.Column<int>(type: "int", nullable: false),
                    TotalOver = table.Column<int>(type: "int", nullable: false),
                    TotalWicktes = table.Column<int>(type: "int", nullable: false),
                    IsInningsCompleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InningsScoreCards", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "BattingInnings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DisplayName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Runs = table.Column<int>(type: "int", nullable: false),
                    Balls = table.Column<int>(type: "int", nullable: false),
                    Sixer = table.Column<int>(type: "int", nullable: false),
                    Four = table.Column<int>(type: "int", nullable: false),
                    BlowedBy = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CaughtBY = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    InningsScoreCardId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BattingInnings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BattingInnings_InningsScoreCards_InningsScoreCardId",
                        column: x => x.InningsScoreCardId,
                        principalTable: "InningsScoreCards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "BlowingInnings",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    DisplayNames = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Runs = table.Column<int>(type: "int", nullable: false),
                    Wickets = table.Column<int>(type: "int", nullable: false),
                    BallsBlowed = table.Column<int>(type: "int", nullable: false),
                    InningsScoreCardId = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BlowingInnings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_BlowingInnings_InningsScoreCards_InningsScoreCardId",
                        column: x => x.InningsScoreCardId,
                        principalTable: "InningsScoreCards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "ScoreCard",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Overs = table.Column<int>(type: "int", nullable: false),
                    HostTeamInningsId = table.Column<int>(type: "int", nullable: true),
                    VistorTeamInningsId = table.Column<int>(type: "int", nullable: true),
                    IsHostInnings = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ScoreCard", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ScoreCard_InningsScoreCards_HostTeamInningsId",
                        column: x => x.HostTeamInningsId,
                        principalTable: "InningsScoreCards",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_ScoreCard_InningsScoreCards_VistorTeamInningsId",
                        column: x => x.VistorTeamInningsId,
                        principalTable: "InningsScoreCards",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_BattingInnings_InningsScoreCardId",
                table: "BattingInnings",
                column: "InningsScoreCardId");

            migrationBuilder.CreateIndex(
                name: "IX_BlowingInnings_InningsScoreCardId",
                table: "BlowingInnings",
                column: "InningsScoreCardId");

            migrationBuilder.CreateIndex(
                name: "IX_ScoreCard_HostTeamInningsId",
                table: "ScoreCard",
                column: "HostTeamInningsId");

            migrationBuilder.CreateIndex(
                name: "IX_ScoreCard_VistorTeamInningsId",
                table: "ScoreCard",
                column: "VistorTeamInningsId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "BattingInnings");

            migrationBuilder.DropTable(
                name: "BlowingInnings");

            migrationBuilder.DropTable(
                name: "ScoreCard");

            migrationBuilder.DropTable(
                name: "InningsScoreCards");
        }
    }
}
