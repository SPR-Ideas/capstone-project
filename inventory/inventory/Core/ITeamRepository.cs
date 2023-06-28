using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Models;
namespace inventory.Core
{
    public interface ITeamRepository : IGenericRepository<TeamModel>
    {
       Task<bool> MakeTeamCaptain(int Id,UsersModels user);

    }
}