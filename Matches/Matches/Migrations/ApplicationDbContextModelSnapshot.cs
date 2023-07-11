﻿// <auto-generated />
using System;
using Matches.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace Matches.Migrations
{
    [DbContext(typeof(ApplicationDbContext))]
    partial class ApplicationDbContextModelSnapshot : ModelSnapshot
    {
        protected override void BuildModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.8")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("Matches.Models.BattingInnings", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("Balls")
                        .HasColumnType("int");

                    b.Property<string>("BlowedBy")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("CaughtBY")
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("DisplayName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("Four")
                        .HasColumnType("int");

                    b.Property<int?>("InningsScoreCardId")
                        .HasColumnType("int");

                    b.Property<int>("IsCurrent")
                        .HasColumnType("int");

                    b.Property<int>("Runs")
                        .HasColumnType("int");

                    b.Property<int>("Sixer")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("InningsScoreCardId");

                    b.ToTable("BattingInnings");
                });

            modelBuilder.Entity("Matches.Models.BlowingInnings", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("BallsBlowed")
                        .HasColumnType("int");

                    b.Property<string>("DisplayNames")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("InningsScoreCardId")
                        .HasColumnType("int");

                    b.Property<int>("IsCurrent")
                        .HasColumnType("int");

                    b.Property<int>("Runs")
                        .HasColumnType("int");

                    b.Property<int>("UserId")
                        .HasColumnType("int");

                    b.Property<int>("Wickets")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("InningsScoreCardId");

                    b.ToTable("BlowingInnings");
                });

            modelBuilder.Entity("Matches.Models.InningsScoreCard", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int>("Balls")
                        .HasColumnType("int");

                    b.Property<bool>("IsInningsCompleted")
                        .HasColumnType("bit");

                    b.Property<int>("Score")
                        .HasColumnType("int");

                    b.Property<int>("TotalOver")
                        .HasColumnType("int");

                    b.Property<int>("TotalWicktes")
                        .HasColumnType("int");

                    b.Property<int>("Wickets")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.ToTable("InningsScoreCards");
                });

            modelBuilder.Entity("Matches.Models.ScoreCard", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));

                    b.Property<int?>("HostTeamId")
                        .HasColumnType("int");

                    b.Property<int?>("HostTeamInningsId")
                        .HasColumnType("int");

                    b.Property<string>("HostTeamName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("IsHostInnings")
                        .HasColumnType("bit");

                    b.Property<int>("Overs")
                        .HasColumnType("int");

                    b.Property<int?>("VisitorTeamInningsId")
                        .HasColumnType("int");

                    b.Property<string>("VisitorTeamName")
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("VistorTeamId")
                        .HasColumnType("int");

                    b.HasKey("Id");

                    b.HasIndex("HostTeamInningsId");

                    b.HasIndex("VisitorTeamInningsId");

                    b.ToTable("ScoreCard");
                });

            modelBuilder.Entity("Matches.Models.BattingInnings", b =>
                {
                    b.HasOne("Matches.Models.InningsScoreCard", null)
                        .WithMany("BattingStats")
                        .HasForeignKey("InningsScoreCardId");
                });

            modelBuilder.Entity("Matches.Models.BlowingInnings", b =>
                {
                    b.HasOne("Matches.Models.InningsScoreCard", null)
                        .WithMany("BlowingStats")
                        .HasForeignKey("InningsScoreCardId");
                });

            modelBuilder.Entity("Matches.Models.ScoreCard", b =>
                {
                    b.HasOne("Matches.Models.InningsScoreCard", "HostTeamInnings")
                        .WithMany()
                        .HasForeignKey("HostTeamInningsId");

                    b.HasOne("Matches.Models.InningsScoreCard", "VisitorTeamInnings")
                        .WithMany()
                        .HasForeignKey("VisitorTeamInningsId");

                    b.Navigation("HostTeamInnings");

                    b.Navigation("VisitorTeamInnings");
                });

            modelBuilder.Entity("Matches.Models.InningsScoreCard", b =>
                {
                    b.Navigation("BattingStats");

                    b.Navigation("BlowingStats");
                });
#pragma warning restore 612, 618
        }
    }
}
