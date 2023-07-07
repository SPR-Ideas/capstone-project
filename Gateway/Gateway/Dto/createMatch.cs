using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gateway.Dto
{
    public class createMatch
    {

        public int HostTeam_id  {get; set; }
        public int VisitorTeam_id  {get; set; }
        public int Overs  {get; set; }
        public int Wickets  {get; set; }
        public bool IsHostInnings {get; set; }

    }
}