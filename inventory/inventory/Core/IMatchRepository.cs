using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Models;

namespace inventory.Core
{
    public interface IMatchRepository :IGenericRepository<MatchModels>
    {
         Task<bool> MatchCompleted (int matchId);
        Task<List<int>> GetUserMatchHistory(int userId);
    }
}