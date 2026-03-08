using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WifeGift.Migrations.UserData
{
    /// <inheritdoc />
    public partial class InitialUserData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "user_data",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_id = table.Column<string>(type: "text", nullable: false),
                    last_login_at = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_user_data", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "preferences",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_data_id = table.Column<Guid>(type: "uuid", nullable: false),
                    adjective = table.Column<string>(type: "text", nullable: false),
                    weight = table.Column<double>(type: "double precision", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_preferences", x => x.id);
                    table.ForeignKey(
                        name: "fk_preferences_user_data_user_data_id",
                        column: x => x.user_data_id,
                        principalTable: "user_data",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_preferences_user_data_id",
                table: "preferences",
                column: "user_data_id");

            migrationBuilder.CreateIndex(
                name: "ix_user_data_user_id",
                table: "user_data",
                column: "user_id",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "preferences");

            migrationBuilder.DropTable(
                name: "user_data");
        }
    }
}
