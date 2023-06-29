using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Protos;
using inventory.Models;
namespace inventory.Core
{
    public interface ITeamRepository : IGenericRepository<TeamModel>
    {
       Task<bool> MakeTeamCaptain(int Id,int user);
       Task<bool> RemovePlayes(int Id, List<int> playerShouldBeRetained);

        Task<List<teamInstanceWithUser>> ReturnTeamsWithPlayerInstance(List<TeamModel> teams);
        Task<List<UsersModels>?> GetUserRangeById(List<int> Ids);

    }
}