using inventory.Core;
using inventory.Core.Repository;

namespace inventory.Data
{
    public class UnitOfWork : IUnitOfWork , IDisposable
    {
        public IUserRepository Users {get; private set; }

        public ILeaderBoardRespository LeaderBoard {get; private set; }

        public ITeamRepository Team {get; private set; }

        private readonly ApplicationDbContext _context;


        public UnitOfWork(ApplicationDbContext context){
            _context = context;
            Users = new UserRepository(_context);
            Team = new TeamRepository(_context);
            LeaderBoard = new LeaderBoardRepository(_context);
        }

        public async Task CompleteAsync()
        {
            await _context.SaveChangesAsync();
        }


        public void  Dispose(){
            _context.Dispose();
        }
    }
}