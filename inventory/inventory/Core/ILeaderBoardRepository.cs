using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Models;
using inventory.Protos;

namespace inventory.Core
{
    public interface ILeaderBoardRespository
    {
        Task<List<userInstance>> GetLeaderboard(int page=1);
        Task<bool> UpdateUsersHistory( int userId , int runs,int wickets );

        Task<List<userInstance>> GetLeaderboardWithWicktes(int page=1);
    }
}