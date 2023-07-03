using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Models;
using inventory.Protos;

namespace inventory.Core
{
    public interface IMatchRepository :IGenericRepository<MatchModels>
    {
         Task<bool> MatchCompleted (completMatachRequest matchId);
        Task<List<int>> GetUserMatchHistory(int userId);
        Task< List<MatchInstanceResponse>> getMatchHistory(int userId);
    }
}