using System.Reflection.Metadata;
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
        public int Count { get; set; }

        public static explicit operator TeamModel(teamInstance v)
        {
            TeamModel team = new TeamModel(){
                Name = v.Name,
                Id = (v.Id ==0)?0:v.Id,
                Members = convertTeamMembersModel(v.Members),
                Count =v.Members.Count
            };

            return team;
        }

        public static List<TeamMemberModel>? convertTeamMembersModel(RepeatedField<teamMemberInstance> Players){

            List<TeamMemberModel> _players = new List<TeamMemberModel>();
            foreach(var player in Players) {
                TeamMemberModel team = new TeamMemberModel{
                    Id = player.Id,
                    userId =  player.UserId,
                    IsCaptain = player.IsCaptain,
                    IsPlaying = player.IsPlaying,
                };

                _players.Add(team);
            }
            return _players;
        }
    }
}