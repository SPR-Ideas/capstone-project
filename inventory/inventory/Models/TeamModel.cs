using System.ComponentModel.DataAnnotations;
using inventory.Protos;
using Google.Protobuf.Collections;
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
            TeamModel team = new TeamModel(){

                Name = v.Name,
                Members = convertTeamMembersModel(v.Members)
            };

            return team;
        }

        public static List<TeamMemberModel>? convertTeamMembersModel(RepeatedField<teamMemberInstance> Players){

            List<TeamMemberModel> _players = new List<TeamMemberModel>();
            foreach(var player in Players) {
                _players.Add(new TeamMemberModel{
                    Id = player.Id,
                    user = (UsersModels) player.User,
                    IsCaptain = player.IsCaptain,
                });
            }
            return _players;
        }
    }
}