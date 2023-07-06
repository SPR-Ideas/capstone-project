using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Data;
using inventory.Models;
using inventory.Protos;
using MatchProto = Matches.Protos;
using MatchService = Matches.Protos.Matches;
using Microsoft.EntityFrameworkCore;
using AutoMapper;

namespace inventory.Core.Repository
{
    public class MatchRepository : GenericReposistory<MatchModels>,IMatchRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly IMapper _mapper;
        private readonly MatchService.MatchesClient _matchService;

        public MatchRepository(ApplicationDbContext context,IMapper mapper,MatchService.MatchesClient matchService) : base(context){
            _context = context;
            _mapper = mapper;
            _matchService  = matchService;
        }

        public async Task<bool> MatchCompleted (completMatachRequest request){
            //  Gives the match is completed flag.
            MatchModels? match = await _context.Matches!.FirstAsync(x => x.ScoreCardId==request.ScoreCardId);
            try{
                 match!.IsCompleted = true;
                 match!.Result = request.Result;
                 match!.VictoryTeamId = request.VictoryTeamId;
                await Update(match);
                return true;
            }catch(Exception ){return false;}
        }

        public async Task<List<int>> GetUserMatchHistory(int userId){

            var _userRepo = new UserRepository(_context,_mapper);
            ICollection<TeamModel>? _teams = await _userRepo.GetUserTeams(userId); // give user Team list
            List<int> team_ids = _teams!.Select(team=>team.Id).ToList();

            // Returns the ScoreCard Ids of the userTeam Matches.
            return _context.Matches!.Where(
                team=>
                team_ids.Contains(team.VistiorTeamId)||
                team_ids.Contains(team.HostTeamId)).
                Select(x=>x.ScoreCardId).ToList();
        }

        public async Task<List<MatchModels>> getMatchesByIds(List<int> Ids){
           return await _context.Matches!.Where(x=> Ids.Contains(x.Id)).ToListAsync();
        }

        public async Task< List<MatchInstanceResponse>> getMatchHistory(int userId){
            List<MatchInstanceResponse> response = new List<MatchInstanceResponse>();

            MatchProto.listOfScoreCard listOfScoreCardId = new MatchProto.listOfScoreCard();
            List<int> mathches = await GetUserMatchHistory(userId);

            listOfScoreCardId.ScoreCard.Add(mathches.Select(x=>new MatchProto.scoreCardRequest{Id=x}));
            var scoreCards = await _matchService.getScoreCardsByIdsAsync(listOfScoreCardId);
            Dictionary<int,MatchProto.scoreCardRequest> scoreCardMap =  new Dictionary<int,MatchProto.scoreCardRequest>();
            foreach (var scoreCard in scoreCards.ScoreCard){
                scoreCardMap.Add(scoreCard.Id, scoreCard);
            }

            List<MatchModels> matches = await getMatchesByIds(mathches);
            foreach (var _match in matches) {
                MatchInstanceResponse match = _mapper.Map<MatchInstanceResponse>(_match);
                match.ScoreCard = _mapper.Map<scoreCardRequest>(scoreCardMap.GetValueOrDefault(_match.ScoreCardId));
                response.Add(match);
            }
            return response;
        }
    }
}