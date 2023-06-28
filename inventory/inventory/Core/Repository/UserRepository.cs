using inventory.Data;
using inventory.Models;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class UserRepository : GenericReposistory<UsersModels>,IUserRepository
    {

        public UserRepository(ApplicationDbContext context):base(context){

            this._dbset = _context.Set<UsersModels>();
        }

        public async Task<ICollection<UsersModels>?> SearchByNameOrUserName(string searchString)
        {
            return  await this._dbset.Where(user => user.UserName!.StartsWith(searchString)).ToListAsync();
        }

        public async Task<ICollection<TeamModel>?> GetUserTeams(int Id){
            return await _context.Teams!.
                    Where(team => team.Members!.Any(
                        member => member.user!.Id == Id
                    )).ToListAsync();
        }
    }
}