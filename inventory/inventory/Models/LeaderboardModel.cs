using System.ComponentModel.DataAnnotations;
namespace inventory.Models
{
    public class LeaderboardModel
    {
        [Key]
        public int Id { get; set; }
        public UsersModels? User { get; set; }
        public int Runs { get; set; }
        public int Wickets { get; set; }

    }
}