
namespace inventory.Models
{
    public class MatchModels
    {
        public int Id {get; set; }
        public int HostTeamId {get; set; }
        public int VistiorTeamId {get; set; }
        public int Overs {get; set; }
        public int Wickets {get; set; }
        public int VictoryTeamId {get;set;}
        public DateTime StartDate {get; set; }
        public bool IsCompleted {get; set; }
        public int ScoreCardId  {get; set; }
        public string? Result {get;set;}
    }

}