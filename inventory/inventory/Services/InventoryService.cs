
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
        public InventoryService(UnitOfWork unitOfWork) {
            Console.WriteLine("\nconstructor");
            _unitOfWork = unitOfWork;
        }

        public override async Task<statusResponse> createUser(userInstanceRequest request, ServerCallContext context)
        {
            Console.WriteLine(request.UserName);
            UsersModels user = new UsersModels(){
                UserName = request.UserName,
                Age = request.Age,
                Name = request.Name,
                Role = request.Role,
                BlowingStyles = request.BlowingStyle,
                BattingStyles = request.BattingStyle,
            };

            // bool _status = await _unitOfWork.Users.Add(user);
            // await _unitOfWork.CompleteAsync();
            return new statusResponse { Status = true };
        }

        public override async Task<inventoryData> getInventory(userInstance request, ServerCallContext context)
        {
            userInstance _user = (userInstance) await _unitOfWork.Users.GetById(request.Id);
            ICollection<teamInstance> _teams = (ICollection<teamInstance>) await _unitOfWork.Users.GetUserTeams(request.Id);

            inventoryData response = new inventoryData(){User = _user};
            response.Teams.Add(_teams);

            return response;
        }

        public override async Task<statusResponse> updateUser(userInstance request, ServerCallContext context)
        {
            bool _status = true;

            try{
                _unitOfWork.Users.Update((UsersModels)request);
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception ){_status = false;}

            return new statusResponse{Status = _status};
        }

        public override async Task<teamInstance> createTeam(teamInstance request, ServerCallContext context)
        {
            try{
                await _unitOfWork.Team.Add((TeamModel) request);
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
                _unitOfWork.Team.Update((TeamModel)request);
                await _unitOfWork.CompleteAsync();
            }
            catch(Exception){
                _status= false;
            }
            return new statusResponse{Status = _status};
        }
    }

}