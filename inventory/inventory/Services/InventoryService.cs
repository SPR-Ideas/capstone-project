
using Grpc.Core;
using inventory.Core;
using inventory.Data;
using inventory.Protos;
using inventory.Models;

namespace inventory.Services
{
    public class InventoryService : Protos.inventory.inventoryBase
    {

        private readonly UnitOfWork _unitOfWork;
        public InventoryService(ApplicationDbContext context) {

            _unitOfWork = new UnitOfWork(context);
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
            // userInstance _user = (userInstance) await _unitOfWork.Users.GetById(request.Id);


            ICollection<teamInstance> _teams = (ICollection<teamInstance>) await _unitOfWork.Users.GetUserTeams(request.Id);
            inventoryData response = new inventoryData();
            response.Teams.Add(_teams);

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
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception){
                _status= false;
            }
            return new statusResponse{Status = _status};
        }
    }

}