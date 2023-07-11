using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Matches.Models
{
    public class BlowingInnings
    {
        public int Id { get; set; }
        public string? DisplayNames {get; set;}
        public int UserId {get;set;}
        public int Runs {get;set;}
        public int Wickets {get;set;}
        public int BallsBlowed {get;set;}

        public int IsCurrent {get;set;}

    }
}