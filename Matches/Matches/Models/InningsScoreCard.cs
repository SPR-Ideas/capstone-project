using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Matches.Models
{
    public class InningsScoreCard
    {
        public int Id { get; set;}
        public int Wickets { get; set;}
        public int Balls { get; set;}
        public int Score {get;set;}
        public int TotalOver { get; set;}
        public int TotalWicktes { get; set;}
        public bool IsInningsCompleted { get; set;}
        public ICollection<BattingInnings>? BattingStats { get; set;}
        public ICollection<BlowingInnings>? BlowingStats { get; set;}

    }
}