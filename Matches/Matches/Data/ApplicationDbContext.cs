using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Matches.Models;
using Microsoft.EntityFrameworkCore;

namespace Matches.Data
{
    public class ApplicationDbContext: DbContext
    {
        public ApplicationDbContext(DbContextOptions options): base(options){}

        public DbSet<ScoreCard>? ScoreCard { get; set; }
        public DbSet<InningsScoreCard>? InningsScoreCards { get; set;}
        public DbSet<BattingInnings>? BattingInnings { get; set;}
        public DbSet<BlowingInnings>? BlowingInnings { get; set;}
    }
}