using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gateway.Dto
{
    public class UserCredentials
    {
        public string? Username { get; set; }
        public string? Password { get; set; }
        public bool IsExternal{get;set;}
    }
}