
using inventory.Models;
namespace inventory.Core
{
    public interface IUserRepository : IGenericRepository<UsersModels>
    {
        Task<ICollection<UsersModels>?> SearchByNameOrUserName(string SearchString);
        Task<ICollection<TeamModel>?> GetUserTeams(int Id);

    }
}