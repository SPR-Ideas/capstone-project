using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Matches.Models
{
    public class ScoreCard
    {
        public int Id { get; set; }
        public int Overs { get; set; }
        public InningsScoreCard? HostTeamInnings { get; set; }
        public InningsScoreCard? VistorTeamInnings { get; set; }
        public bool IsHostInnings { get; set; }
    }
}