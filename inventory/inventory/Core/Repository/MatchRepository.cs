using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Data;
using inventory.Models;


namespace inventory.Core.Repository
{
    public class MatchRepository : GenericReposistory<MatchModels>,IMatchRepository
    {
        private readonly ApplicationDbContext _context;
        public MatchRepository(ApplicationDbContext context) : base(context){
            _context = context;
        }

        public async Task<bool> MatchCompleted (int matchId){
            //  Gives the match is completed flag.
            MatchModels?  match = await GetById(matchId);
            try{
                 match!.IsCompleted = true;
                await Update(match);
                return true;
            }catch(Exception ){return false;}
        }

        public async Task<List<int>> GetUserMatchHistory(int userId){

            var _userRepo = new UserRepository(_context);
            ICollection<TeamModel>? _teams = await _userRepo.GetUserTeams(userId); // give user Team list
            List<int> team_ids = _teams!.Select(team=>team.Id).ToList();

            // Returns the ScoreCard Ids of the userTeam Matches.
            return _context.Matches!.Where(
                team=>
                team_ids.Contains(team.VistiorTeamId)||
                team_ids.Contains(team.HostTeamId)).
                Select(x=>x.ScoreCardId).ToList();
        }

    }
}