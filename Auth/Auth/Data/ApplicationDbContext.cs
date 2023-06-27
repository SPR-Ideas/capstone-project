using Microsoft.EntityFrameworkCore;
using Auth.Models;
namespace Auth.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions options) : base(options){
        }
        public DbSet<CredentialsModel> cred {get;set;}

        void OnModelCreating(ModelBuilder builder){
            builder.Entity<CredentialsModel>().
                HasIndex(p => p.Username).IsUnique();
        }

    }
}