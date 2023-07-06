using System.Security.Claims;
using System.Text.RegularExpressions;
using Grpc.Core;
using Grpc.Net.Client;
using inventory.Data;
using inventory.Protos;
using inventory.Models;
using AuthService = Auth.Protos.authService;
using MatchService = Matches.Protos.Matches;
using MatchProto = Matches.Protos;
using AuthProto = Auth.Protos;


using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;

namespace inventory.Services
{
    public class InventoryService : Protos.inventory.inventoryBase
    {

        private  readonly UnitOfWork _unitOfWork;
        private  readonly IMapper _mapper;
        private  readonly AuthService.authServiceClient _authClient;
        private  readonly MatchService.MatchesClient _matchService;

        public InventoryService(ApplicationDbContext context,IMapper mapper,
                                AuthService.authServiceClient authClient,
                                MatchService.MatchesClient matchService
                                ) {
            _mapper = mapper;
            _unitOfWork = new UnitOfWork(context,mapper,matchService);
            _authClient = authClient;
            _matchService = matchService;
        }


        public override async Task<statusResponse> createUser(userInstance request, ServerCallContext context)
        {
            try{
                UsersModels _user  = (UsersModels)request;
                _user.Id = request.Id;

                if(!request.IsExternal)
                    _user.DisplayImage = "https://th.bing.com/th/id/OIP.PlUghRkXvx9eqZvManVhsgHaIS?w=170&h=190&c=7&r=0&o=5&dpr=1.9&pid=1.7";

                // Communicating with auth Authorization Server
                var response = await _authClient.addCredentialsAsync(
                    new AuthProto.userCredentials{
                        UserName =request.UserName,
                        Password = request.Password,
                        IsExternal = request.IsExternal
                        }
                );

                // Based on the status we gonna add the user model.
                if(response.Status){
                    _user.Id = response.Id;
                    // await _unitOfWork.LeaderBoard.Add((LeaderboardModel)request);
                    await _unitOfWork.Users.Add(_user);
                    await _unitOfWork.CompleteAsync();
                }
                else{throw new Exception();}
                return new statusResponse{Status=true};
            }
            catch (Exception){
                return new statusResponse { Status = false};
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        public override async Task<inventoryData> getInventory(emptyRequest request, ServerCallContext context)
        {
            int UserId = Convert.ToInt32(context.GetHttpContext().User.Claims.FirstOrDefault(c=>c.Type == ClaimTypes.Sid)!.Value);
            userInstance _user = _mapper.Map<userInstance>( await _unitOfWork.Users.GetById(UserId));
            var temp = await _unitOfWork.Users.GetUserTeams(UserId);

            List<teamInstanceWithUser>teams = await _unitOfWork.Team.ReturnTeamsWithPlayerInstance(temp!.ToList());

            inventoryData response = new inventoryData(){User = _user};
            response.Teams.Add(teams);

            response.Matches.Add(await _unitOfWork.Match.getMatchHistory(UserId ));
            return response; // returns invetory data.
        }


        public override async Task<statusResponse> updateUser(userInstance request, ServerCallContext context){
            try{
                UsersModels _user  = (UsersModels)request;
                _user.Id = request.Id;

                await _unitOfWork.Users.Update(_user);
                await _unitOfWork.CompleteAsync();
                return new statusResponse{Status = true};
            }
            catch(Exception ){
                return new statusResponse{Status = false};
            }
        }

        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        public override async Task<teamInstance> createTeam(teamInstance request, ServerCallContext context)
        {
            try{
                int captainId = Convert.ToInt32(context.GetHttpContext().User.Claims.FirstOrDefault(c=>c.Type == ClaimTypes.Sid)!.Value) ;
                TeamModel _team  = (TeamModel)request;
                _team.Id = request.Id;

                await _unitOfWork.Team.Add(_team,captainId);
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception){
                return new teamInstance();
            }
            return request;
        }


        public override async Task<statusResponse> updateTeam(teamInstance request, ServerCallContext context){
            try{
                 TeamModel _team  = (TeamModel)request;
                _team.Id = request.Id;
                await _unitOfWork.Team.Update(_team);

                if(request.Count > request.Members.Count)
                    await _unitOfWork.Team.RemovePlayes(request.Id, request.Members.Select(m=>m.Id).ToList());

                await _unitOfWork.CompleteAsync();
                return new statusResponse{Status= true};
            }
            catch(Exception ){
                return new statusResponse{Status = false};
            }
        }


        public override async Task<statusResponse> makeCaptain(makeCaptainInstance request, ServerCallContext context)
        {
            try{
                await _unitOfWork.Team.MakeTeamCaptain(request.TeamId,request.UserId );
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception){
                return new statusResponse{Status = false};
            }
            return new statusResponse{Status = true};
        }

        public override async Task<statusResponse> updateUserPerformances(ListOfUser request, ServerCallContext context)
        {
            try{
                foreach(var user in request.Users){
               await _unitOfWork.LeaderBoard.UpdateUsersHistory(user.Id, user.Runs,user.Wickets);
            }
            await _unitOfWork.CompleteAsync();
            return new statusResponse{Status=true};
            }catch(Exception){return new statusResponse{Status=false};}
        }

        public override async Task<ListOfUser> getLeaderBoard(LeaderBoardRequest request, ServerCallContext context)
        {
            ListOfUser response = new ListOfUser();
            if(request.SearchString!=""){
                response.Users.Add(await _unitOfWork.Users.SearchByNameOrUserName(request.SearchString));
                return response;
            }
            response.Users.Add(
                request.Mode? // If Mode is ture returns leaderboard based on user with higesh runs.
                await _unitOfWork.LeaderBoard.GetLeaderboard((request.Page==0)?1:request.Page):
                await _unitOfWork.LeaderBoard.GetLeaderboardWithWicktes((request.Page==0)?1:request.Page));
            return response;
        }

        public override async Task<statusResponse> completeMatch(completMatachRequest request, ServerCallContext context)
        {
            try{
                await _unitOfWork.Match.MatchCompleted(request);
                await _unitOfWork.CompleteAsync();

                return new statusResponse{Status = true};
            }catch(Exception){
                return new statusResponse{Status=false};
            }
        }

        public override async Task<statusResponse> createMatch(MatchInstance request, ServerCallContext context)
        {
            try{
                MatchProto.teamInstanceWithUser val = _mapper.Map<MatchProto.teamInstanceWithUser>((await _unitOfWork.Team.ReturnTeamsWithPlayerInstance(new List<TeamModel>() { await _unitOfWork.Team.GetById(request.VisitorTeamId) }))[0]);
                // Create a ScoreCard Instance via Grpc
               var response = await _matchService.CreateScoreCardAsync(new MatchProto.ScoreCardCreateRequest{
                   VisitorTeam = _mapper.Map<MatchProto.teamInstanceWithUser>((await _unitOfWork.Team.ReturnTeamsWithPlayerInstance(new List<TeamModel>() { await _unitOfWork.Team.GetById(request.VisitorTeamId) }))[0]),
                            HostTeam = _mapper.Map<MatchProto.teamInstanceWithUser>((await _unitOfWork.Team.ReturnTeamsWithPlayerInstance(new List<TeamModel>() { await _unitOfWork.Team.GetById(request.HostTeamId)}))[0]),
                            IsHostInnings = request.IsHostInnings,
                            Overs = request.Overs,
                            Wickets = request.Wickets
                        });

                var matchtInstance = _mapper.Map<MatchModels>(request);
                matchtInstance.ScoreCardId = response.ScoreCardId; // updateing MatchInstance.

                await _unitOfWork.Match.Add(matchtInstance);
                await _unitOfWork.CompleteAsync();
                return new statusResponse{Status = true};
            }catch(Exception e) {
                Console.WriteLine(e);
                return new statusResponse{Status=false};}
        }
    }
}
