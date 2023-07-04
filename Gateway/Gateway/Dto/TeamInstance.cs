
namespace Gateway.Dto
{
    public class TeamInstance
    {
        public int Id { get; set; }
        public string? Name { get; set; }
        public List<TeamMemberInstance>? Members { get; set; }
        public int Count { get; set; }

    }

    public class TeamMemberInstance
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public bool IsCaptain { get; set; }
        public bool IsPlaying { get; set; }
    }
}