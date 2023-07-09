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
        public int? HostTeamId { get; set;}
        public int? VistorTeamId { get; set;}
        public string? HostTeamName {get;set;}
        public string? VisitorTeamName {get;set;}

        public InningsScoreCard? HostTeamInnings { get; set; }
        public InningsScoreCard? VisitorTeamInnings { get; set; }
        public bool IsHostInnings { get; set; }
    }
}