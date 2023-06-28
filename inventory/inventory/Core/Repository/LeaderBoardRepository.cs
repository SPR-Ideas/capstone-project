
using inventory.Data;
using inventory.Models;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class LeaderBoardRepository : GenericReposistory<LeaderboardModel>,ILeaderBoardRespository
    {

        public LeaderBoardRepository(ApplicationDbContext context):base(context){
            this._dbset =  context.Set<LeaderboardModel>();
        }

        public override LeaderboardModel Update(LeaderboardModel entity)
        {
            this._dbset.Include(LB=>LB.User);
            this._dbset.Update(entity);
            return entity;
        }
    }
}