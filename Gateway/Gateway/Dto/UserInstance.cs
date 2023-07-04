using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gateway.Dto
{
    public class UserInstance
    {
        public int Id {get; set; }
        public string? UserName {get; set; }
        public string? Password {get; set; }
        public string? Name {get; set; }
        public int Age {get; set; }
        public string? Role {get; set; }
        public string? BattingStyle {get; set; }
        public string? BlowingStyle {get; set; }
        public bool IsExternal {get; set; }
        public int Runs { get; set; }
        public int Wickets { get; set;}
        public int Matches { get; set; }

    }
}