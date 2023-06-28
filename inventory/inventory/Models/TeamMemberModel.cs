using System.ComponentModel.DataAnnotations;

namespace inventory.Models
{
    public class TeamMemberModel
    {
        [Key]
        public int Id { get; set; }
        public UsersModels? user { get; set; }
        public bool IsCaptain { get; set; }
        public bool IsPlaying { get; set; }
    }
}