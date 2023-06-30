using Grpc.Core;
using Grpc.Net.Client;
using inventory.Data;
using inventory.Protos;
using inventory.Models;
using AuthService = Auth.Protos.authService;
using AuthProto = Auth.Protos;



using AutoMapper;

namespace inventory.Services
{
    public class InventoryService : Protos.inventory.inventoryBase
    {

        private  readonly UnitOfWork _unitOfWork;
        private  readonly IMapper _mapper;
        private  readonly AuthService.authServiceClient _authClient;

        public InventoryService(
            ApplicationDbContext context
            ,IMapper mapper,
            AuthService.authServiceClient authClient
            ) {
            _mapper = mapper;
            _unitOfWork = new UnitOfWork(context,mapper);
            _authClient = authClient;
        }


        public override async Task<statusResponse> createUser(userInstance request, ServerCallContext context)
        {
            bool _status = true;
            try{
                UsersModels _user  = (UsersModels)request;
                _user.Id = request.Id;

                var response = await _authClient.addCredentialsAsync(
                    new AuthProto.userCredentials{
                        UserName =request.UserName,
                        Password = request.Password,
                        IsExternal = request.IsExternal
                        }
                );

                if(response.Status == true){
                    await _unitOfWork.Users.Add(_user);
                    await _unitOfWork.CompleteAsync();
                }
                else{throw new Exception();}
            }
            catch (Exception){
                _status = false;
            }
            return new statusResponse { Status = _status};
        }


        public override async Task<inventoryData> getInventory(userInstance request, ServerCallContext context)
        {
            userInstance _user = _mapper.Map<userInstance>( await _unitOfWork.Users.GetById(request.Id));
            var temp = await _unitOfWork.Users.GetUserTeams(request.Id);

            List<teamInstanceWithUser>teams = await _unitOfWork.Team.ReturnTeamsWithPlayerInstance(temp.ToList());

            inventoryData response = new inventoryData(){User = _user};
            response.Teams.Add(teams);

            return response;
        }


        public override async Task<statusResponse> updateUser(userInstance request, ServerCallContext context)
        {
            bool _status = true;
            try{
                UsersModels _user  = (UsersModels)request;
                _user.Id = request.Id;

                await _unitOfWork.Users.Update(_user);
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception e ){
                Console.WriteLine(e);
                _status = false;
            }
            return new statusResponse{Status = _status};
        }


        public override async Task<teamInstance> createTeam(teamInstance request, ServerCallContext context)
        {
            try{
                TeamModel _team  = (TeamModel)request;
                _team.Id = request.Id;

                await _unitOfWork.Team.Add(_team);
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception){
                return new teamInstance();
            }
            return request;
        }


        public override async Task<statusResponse> updateTeam(teamInstance request, ServerCallContext context)
        {
            bool _status = true;

            try{
                 TeamModel _team  = (TeamModel)request;
                _team.Id = request.Id;

                await _unitOfWork.Team.Update(_team);
                if(request.Count > request.Members.Count){
                    await _unitOfWork.Team.RemovePlayes(request.Id, request.Members.Select(m=>m.Id).ToList());
                }
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception e){
                Console.WriteLine(e);
                _status= false;
            }
            return new statusResponse{Status = _status};
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
    }

}