
using inventory.Data;
using inventory.Models;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class LeaderBoardRepository : GenericReposistory<LeaderboardModel>,ILeaderBoardRespository
    {
        // private readonly ApplicationDbContext _context;
        public LeaderBoardRepository(ApplicationDbContext context):base(context){
            // _context = context;
           this._dbset =  context.Set<LeaderboardModel>();
        }

        public override async Task<LeaderboardModel?> Update(LeaderboardModel entity)
        {
            this._dbset.Include(board=>board.User);
            this._dbset.Update(entity);
            return await Task.FromResult(entity);
        }
    }
}