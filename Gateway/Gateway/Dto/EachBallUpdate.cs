using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gateway.Dto
{
    public class EachBallUpdate
    {
        public int ScoreCardID { get; set; }
        public int Runs { get; set; }
        public string? Options { get; set; }
        public int BatsmanId { get; set; }
        public int BlowerId { get; set; }
        public string? BlowerName { get; set; }
    }
}