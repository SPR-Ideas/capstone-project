using inventory.Core;
using inventory.Core.Repository;
using AutoMapper;
using MatchService = Matches.Protos.Matches;
namespace inventory.Data
{
    public class UnitOfWork : IUnitOfWork , IDisposable
    {
        public IUserRepository Users {get; private set; }

        public ILeaderBoardRespository LeaderBoard {get; private set; }

        public ITeamRepository Team {get; private set; }
        public IMatchRepository Match {get; private set; }

        private readonly ApplicationDbContext _context;


        public UnitOfWork(ApplicationDbContext context,IMapper mapper,MatchService.MatchesClient matchclient){
            _context = context;
            Users = new UserRepository(_context,mapper);
            Team = new TeamRepository(_context,mapper);
            LeaderBoard = new LeaderBoardRepository(_context,mapper);
            Match = new MatchRepository(_context,mapper,matchclient);
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