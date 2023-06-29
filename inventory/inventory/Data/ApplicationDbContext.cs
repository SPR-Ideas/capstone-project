using Microsoft.EntityFrameworkCore;
using inventory.Models;

namespace inventory.Data
{
    public class ApplicationDbContext :DbContext
    {
        public ApplicationDbContext(DbContextOptions options) : base(options){

        }

        public DbSet<UsersModels>? Users { get; set; }
        public DbSet<TeamModel>? Teams { get; set; }
        public DbSet<TeamMemberModel>? TeamMembers { get; set; }
        public DbSet<LeaderboardModel>? LeaderBoard { get; set; }


    }
}
