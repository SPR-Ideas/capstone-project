
using inventory.Models;
using inventory.Protos;

namespace inventory.Core
{
    public interface IUserRepository : IGenericRepository<UsersModels>
    {
        Task<List<userInstance>?> SearchByNameOrUserName(string SearchString);
        Task<ICollection<TeamModel>?> GetUserTeams(int Id);

    }
}