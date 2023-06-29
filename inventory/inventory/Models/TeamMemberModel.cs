using System.ComponentModel.DataAnnotations;

namespace inventory.Models
{
    public class TeamMemberModel
    {
        [Key]
        public int Id { get; set; }
        // public UsersModels? user { get; set; }
        public int userId { get; set; }
        public bool IsCaptain { get; set; }
        public bool IsPlaying { get; set; }
        // public TeamModel? Team { get; internal set; }
    }
}