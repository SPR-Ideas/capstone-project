using Microsoft.EntityFrameworkCore;
using inventory.Models;
using Microsoft.EntityFrameworkCore.Metadata;

namespace inventory.Data
{
    public class ApplicationDbContext :DbContext
    {
        public ApplicationDbContext(DbContextOptions options) : base(options){

        }

        public DbSet<UsersModels>? Users { get; set; }
        public DbSet<TeamModel>? Teams { get; set; }
        public DbSet<TeamMemberModel>? TeamMembers { get; set; }
        public DbSet<MatchModels>? Matches { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UsersModels>()
                .Property(e => e.Id)
                .ValueGeneratedNever(); // Disable auto-increment

            // modelBuilder.Entity<UsersModels>()
            //     .Property(e => e.Id)
            //     .Metadata.SetAfterSaveBehavior(PropertySaveBehavior.Ignore); // Enable explicit value insertion

            // Other configurations

            base.OnModelCreating(modelBuilder);
        }
    }
}
