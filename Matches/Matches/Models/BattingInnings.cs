
namespace Matches.Models
{
    public class BattingInnings
    {
        public int Id {get; set; }
        public string? DisplayName {get;set;}
        public int UserId {get; set; }
        public int Runs {get; set; }
        public int Balls {get;set;}
        public int Sixer {get; set; }
        public int Four {get;set;}
        public string? BlowedBy {get; set; }
        public string? CaughtBY {get;set;}
    }
}