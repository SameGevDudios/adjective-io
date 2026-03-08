using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WifeGift.Migrations.UserData
{
    /// <inheritdoc />
    public partial class AddPrefixes : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "prefixes",
                columns: table => new
                {
                    id = table.Column<Guid>(type: "uuid", nullable: false),
                    user_data_id = table.Column<Guid>(type: "uuid", nullable: false),
                    title = table.Column<string>(type: "text", nullable: false),
                    subtitle = table.Column<string>(type: "text", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("pk_prefixes", x => x.id);
                    table.ForeignKey(
                        name: "fk_prefixes_user_data_user_data_id",
                        column: x => x.user_data_id,
                        principalTable: "user_data",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "ix_prefixes_user_data_id",
                table: "prefixes",
                column: "user_data_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "prefixes");
        }
    }
}
