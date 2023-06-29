
using System.Net.Cache;
using Grpc.Core;
using inventory.Core;
using inventory.Data;
using inventory.Protos;
using inventory.Models;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using AutoMapper;

namespace inventory.Services
{
    public class InventoryService : Protos.inventory.inventoryBase
    {

        private readonly UnitOfWork _unitOfWork;
        private readonly IMapper _mapper;
        public InventoryService(ApplicationDbContext context,IMapper mapper) {
            _mapper = mapper;
            _unitOfWork = new UnitOfWork(context,mapper);
        }


        public override async Task<statusResponse> createUser(userInstance request, ServerCallContext context)
        {
            bool _status = true;
            try{
                UsersModels _user  = (UsersModels)request;
                _user.Id = request.Id;

                await _unitOfWork.Users.Add(_user);
                await _unitOfWork.CompleteAsync();
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