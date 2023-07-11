using System.ComponentModel.DataAnnotations;
using Matches.Models;
using Matches.Data;
using Matches.Protos;
using Microsoft.EntityFrameworkCore;
using InvetoryService = inventory.Protos.inventory;

namespace Matches.Core.Repository
{
    public class ScoreCardRepository : IScoreCardRepository
    {
        private readonly ApplicationDbContext _context;
        private readonly InvetoryService.inventoryClient _inventoryService;
        public ScoreCardRepository(ApplicationDbContext context,InvetoryService.inventoryClient inventoryService){
            _context = context;
            _inventoryService = inventoryService;
        }


        public async Task<ScoreCard> GetById(int Id){
            return await _context.ScoreCard!
            .Include(x => x.HostTeamInnings)
                .ThenInclude(x => x!.BattingStats)
            .Include(x => x.HostTeamInnings)
                .ThenInclude(x => x!.BlowingStats)
            .Include(x => x.VisitorTeamInnings)
                .ThenInclude(x => x!.BattingStats)
            .Include(x => x.VisitorTeamInnings)
                .ThenInclude(x => x!.BlowingStats)
            .FirstAsync(x => x.Id == Id);

        }

        public async Task<List<ScoreCard>> GetByIds(List<int> Ids){
            var t =  await _context.ScoreCard!
            .Include(x => x.HostTeamInnings)
                .ThenInclude(x => x!.BattingStats)
            .Include(x => x.HostTeamInnings)
                .ThenInclude(x => x!.BlowingStats)
            .Include(x => x.VisitorTeamInnings)
                .ThenInclude(x => x!.BattingStats)
            .Include(x => x.VisitorTeamInnings)
                .ThenInclude(x => x!.BlowingStats)
            .Where(x=>Ids.Contains(x.Id)).ToListAsync();
            return t;
        }

        public InningsScoreCard createInningWithTeam(teamInstanceWithUser team,int wickets,int overs)
        {
            InningsScoreCard _inningsCard =  new InningsScoreCard();
            _inningsCard.TotalOver = overs;
            _inningsCard.TotalWicktes = wickets;
            _inningsCard.IsInningsCompleted = false;

            List<BattingInnings> _battingStats = new List<BattingInnings>();
            List<BlowingInnings> _blowingStats = new List<BlowingInnings>();

            foreach(var member in team.Members){
                var _battingStat = new BattingInnings();
                var _blowingStat = new BlowingInnings();

                _battingStat.DisplayName = member.User.Name;
                _battingStat.UserId = member.User.Id;

                _blowingStat.UserId = member.User.Id;
                _blowingStat.DisplayNames = member.User.Name;

                _battingStats.Add(_battingStat);
                _blowingStats.Add(_blowingStat);
            }

            _inningsCard.BattingStats = _battingStats;
            _inningsCard.BlowingStats = _blowingStats;

            return _inningsCard;
        }


        public ScoreCard?  createScoreCard(ScoreCardCreateRequest scoreCard)
        {
            try{
                ScoreCard _scoreCard = new ScoreCard();
                _scoreCard.Overs = scoreCard.Overs;
                _scoreCard.IsHostInnings = scoreCard.IsHostInnings;
                _scoreCard.HostTeamId = scoreCard.HostTeam.Id;
                _scoreCard.HostTeamName = scoreCard.HostTeam.Name;
                _scoreCard.VistorTeamId = scoreCard.VisitorTeam.Id;
                _scoreCard.VisitorTeamName = scoreCard.VisitorTeam.Name;
                _scoreCard.HostTeamInnings = createInningWithTeam(
                                                            scoreCard.HostTeam,
                                                            scoreCard.Wickets,
                                                            scoreCard.Overs);
                _scoreCard.VisitorTeamInnings = createInningWithTeam(
                                                            scoreCard.VisitorTeam,
                                                            scoreCard.Wickets,
                                                            scoreCard.Overs);
                _context.ScoreCard!.Add(_scoreCard);
                return _scoreCard;
            }catch (Exception){return null;}

        }


        public InningsScoreCard  UpdateInnings(InningsScoreCard innings,InningsScoreCard inningsTemp,EachBallRequest request){
            List<string> options = new List<string>(){"WD","NB",};
            var batsmam =  innings.BattingStats!.FirstOrDefault(user=> user.UserId==request.BatsmanId);
            var blower =   inningsTemp.BlowingStats!.FirstOrDefault(user=> user.UserId==request.BlowerId);

            if(options.Contains(request.Options)){

                innings.Score++;  // Penalty runs for wide and NoBall.
                blower!.Runs++;
            }

            // Runs Scored by Batsment
            innings.Score += request.Runs;
            if(request.Options == ""||request.Options=="NB"){
                batsmam!.Runs +=request.Runs;
                if(request.Options == "NB"){ batsmam.Balls++;}
            }
            if(request.Options=="WK"){
                batsmam!.BlowedBy = request.BlowerName;
                innings.Wickets ++;
                blower!.Wickets++;
            }

            blower!.Runs +=request.Runs;
            if(request.Runs==6){batsmam!.Sixer++;}
            if(request.Runs==4){batsmam!.Four++;}


            if(!options.Contains(request.Options)){
                innings.Balls++;
                blower!.BallsBlowed++;
                batsmam!.Balls++;
            }

            if(innings.Balls/6 == innings.TotalOver|| innings.TotalWicktes == innings.Wickets ){
                innings.IsInningsCompleted = true;
            }
            if(inningsTemp.IsInningsCompleted && inningsTemp.Score<innings.Score){
                innings.IsInningsCompleted=true;
            }

            return innings;

        }

        public  ScoreCard MatchEngine(ScoreCard _scoreCard,EachBallRequest request){

            if(_scoreCard.IsHostInnings){
                _scoreCard.HostTeamInnings = UpdateInnings(_scoreCard.HostTeamInnings!,_scoreCard.VisitorTeamInnings!,request);
                if(_scoreCard.HostTeamInnings.IsInningsCompleted){
                     _scoreCard.IsHostInnings=!_scoreCard.IsHostInnings;}
            }else{
                _scoreCard.VisitorTeamInnings = UpdateInnings(_scoreCard.VisitorTeamInnings!,_scoreCard.HostTeamInnings!,request);
                if(_scoreCard.VisitorTeamInnings!.IsInningsCompleted){
                     _scoreCard.IsHostInnings=!_scoreCard.IsHostInnings;}
            }
            return _scoreCard;
        }


        public async Task<bool> updateScoreCard(EachBallRequest request){

                ScoreCard _scoreCard = await GetById(request.ScoreCardID);
                _scoreCard = MatchEngine(_scoreCard,request);

                if( _scoreCard.HostTeamInnings!.IsInningsCompleted &&
                    _scoreCard.VisitorTeamInnings!.IsInningsCompleted)
                {
                    //Sending A singal to Inventory Microservice -> Match Completed.
                   var response =  await _inventoryService.completeMatchAsync(concludeMatch(_scoreCard));
                   if(!response.Status ){Console.WriteLine("Issues with Updating complete Match."); throw new Exception();}

                    response = await _inventoryService.updateUserPerformancesAsync(MakeUserPerfomance(_scoreCard));
                    if(!response.Status ){Console.WriteLine("Issues with Updating User Performance"); throw new Exception();}

                }

                return true;
        }

        public inventory.Protos.completMatachRequest concludeMatch(ScoreCard scoreCard){
            string result = "";
            int? VTeamId = (scoreCard.HostTeamInnings!.Score > scoreCard.VisitorTeamInnings!.Score)?
                                        scoreCard.HostTeamId: scoreCard.VistorTeamId;

            int VictoryTeamId = (VTeamId == null)?0:(int) VTeamId;

            if( scoreCard.HostTeamId == VictoryTeamId){
                if(!scoreCard.IsHostInnings ){
                    result = scoreCard.HostTeamName
                         + " Won By " +(scoreCard.HostTeamInnings.TotalWicktes - scoreCard.HostTeamInnings.Wickets)
                         + " Wickets ";
                }
                else {
                    result = scoreCard.HostTeamName
                            + " Won By " + (scoreCard.HostTeamInnings.Score - scoreCard.VisitorTeamInnings.Score)
                            + " Runs.";
                }
            }
            else{
                if(scoreCard.IsHostInnings ){
                    result = scoreCard.VisitorTeamName
                         + " Won By " +(scoreCard.VisitorTeamInnings.TotalWicktes - scoreCard.VisitorTeamInnings.Wickets)
                         + " Wickets ";
                }
                else {
                    result = scoreCard.HostTeamName
                            + " Won By " + (scoreCard.VisitorTeamInnings.Score - scoreCard.HostTeamInnings.Score)
                            + " Runs.";
                }
            }

            return new inventory.Protos.completMatachRequest{
                        ScoreCardId = scoreCard.Id,
                        VictoryTeamId = VictoryTeamId,
                        Result = result
                        };
        }


        public inventory.Protos.ListOfUser MakeUserPerfomance(ScoreCard _scorecard){
            Dictionary<int,inventory.Protos.userInstance> userMap = new Dictionary<int,inventory.Protos.userInstance>();
            foreach(var _user in _scorecard.HostTeamInnings!.BattingStats!){
                userMap.Add(_user.UserId , new inventory.Protos.userInstance{
                    Id = _user.UserId,
                    Runs = _user.Runs,
                });
            }
            foreach(var _user in _scorecard.VisitorTeamInnings!.BattingStats!){
                var flag = userMap.GetValueOrDefault(_user.UserId);
                if(flag ==null){
                    userMap.Add(_user.UserId , new inventory.Protos.userInstance{
                    Id = _user.UserId,
                    Runs = _user.Runs,
                });
                }

            }
            foreach(var _user in _scorecard.VisitorTeamInnings!.BlowingStats!){
                inventory.Protos.userInstance? u =  userMap.GetValueOrDefault(_user.UserId);
                u!.Wickets = _user.Wickets;
            }
            foreach(var _user in _scorecard.HostTeamInnings!.BlowingStats!){
                inventory.Protos.userInstance? u =  userMap.GetValueOrDefault(_user.UserId);
                u!.Wickets = _user.Wickets;
            }
            var response = new inventory.Protos.ListOfUser();
            response.Users.Add( userMap.Values.ToList());
            return response;
        }
    }
}