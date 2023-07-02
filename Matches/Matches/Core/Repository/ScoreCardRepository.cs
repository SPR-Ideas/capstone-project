using System.ComponentModel.DataAnnotations;
using Matches.Models;
using Matches.Data;
using Matches.Protos;
using Microsoft.EntityFrameworkCore;

namespace Matches.Core.Repository
{
    public class ScoreCardRepository : IScoreCardRepository
    {
        private readonly ApplicationDbContext _context;

        public ScoreCardRepository(ApplicationDbContext context){
            _context = context;
        }


        public InningsScoreCard createInningWithTeam(teamInstanceWithUser team)
        {
            InningsScoreCard _inningsCard =  new InningsScoreCard();
            List<BattingInnings> _battingStats = new List<BattingInnings>();
            List<BlowingInnings> _blowingStats = new List<BlowingInnings>();

            foreach(var member in team.Members){
                var _battingStat = new BattingInnings();
                var _blowingStat = new BlowingInnings();

                _battingStat.DisplayName = member.User.Name;
                _battingStat.UserId = member.User.Id;

                _blowingStat.UserId = member.Id;
                _blowingStat.DisplayNames = member.User.Name;

                _battingStats.Add(_battingStat);
                _blowingStats.Add(_blowingStat);
            }

            _inningsCard.BattingStats = _battingStats;
            _inningsCard.BlowingStats = _blowingStats;

            return _inningsCard;
        }


        public bool createScoreCard(ScoreCardCreateRequest scoreCard)
        {
            try{
                ScoreCard _scoreCard = new ScoreCard();
                _scoreCard.Overs = scoreCard.Overs;
                _scoreCard.IsHostInnings = scoreCard.IsHostInnings;
                _scoreCard.HostTeamInnings = createInningWithTeam(scoreCard.HostTeam);
                _scoreCard.VistorTeamInnings = createInningWithTeam(scoreCard.VisitorTeam);
                _context.ScoreCard!.Add(_scoreCard);
                return true;
            }catch (Exception){return false;}

        }

        public InningsScoreCard  UpdateInnings(InningsScoreCard innings,EachBallRequest request){
            List<string> options = new List<string>(){"WD","NB",};
            var batsmam =  innings.BattingStats!.FirstOrDefault(user=> user.UserId==request.BatsmanId);
            var blower =   innings.BlowingStats!.FirstOrDefault(user=> user.UserId==request.BlowerId);

            innings.Sore += request.Runs;
            batsmam!.Runs +=request.Runs;

            if(!options.Contains(request.Options))
                innings.Balls++;
                blower!.BallsBlowed++;
            return innings;

        }

        public  ScoreCard MatchEngine(ScoreCard _scoreCard,EachBallRequest request){
            if(_scoreCard.IsHostInnings){
                _scoreCard.HostTeamInnings = UpdateInnings(_scoreCard.HostTeamInnings!,request);
            }else{
                _scoreCard.VistorTeamInnings = UpdateInnings(_scoreCard.VistorTeamInnings!,request);
            }
            return _scoreCard;
        }


        public async Task<bool> updateScoreCard(EachBallRequest request){

            ScoreCard _scoreCard = await _context.ScoreCard!
                        .Include(x => x.HostTeamInnings)
                            .ThenInclude(x => x!.BattingStats)
                        .Include(x => x.HostTeamInnings)
                            .ThenInclude(x => x!.BlowingStats)
                        .Include(x => x.VistorTeamInnings)
                            .ThenInclude(x => x!.BattingStats)
                        .Include(x => x.VistorTeamInnings)
                            .ThenInclude(x => x!.BlowingStats)
                        .FirstAsync(x => x.Id == request.ScoreCardID);

                _scoreCard = MatchEngine(_scoreCard,request);
                return true;
        }
    }
}