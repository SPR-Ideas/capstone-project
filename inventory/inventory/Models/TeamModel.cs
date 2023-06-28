using System.ComponentModel.DataAnnotations;
using inventory.Protos;

namespace inventory.Models
{
    public class TeamModel
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public List<TeamMemberModel>? Members { get; set; }

        public static explicit operator TeamModel(teamInstance v)
        {
            throw new NotImplementedException();
        }
    }
}