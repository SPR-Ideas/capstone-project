using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Gateway.Dto
{
    public class changeBatsmen
    {
        public int inningsId {get;set;}
        public  int currentBatsmen {get;set;}
        public int newBatsmen {get;set;}
    }

    public class changeBlower{
        public  int  inningsId {get;set;}
        public int currentBlowerId {get;set;}
        public int newBlowerId {get;set;}
    }

    public class freshInnings{
        public int InningsId {get;set;}
        public int  strikerId {get;set;}
        public int nonStrikerId {get;set;}
        public int blowerId  {get;set;}
    }
}