using AutoMapper;
using inventory.Data;
using inventory.Models;
using inventory.Protos;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class UserRepository : GenericReposistory<UsersModels>,IUserRepository
    {
        private readonly IMapper _mapper;

        public UserRepository(ApplicationDbContext context,IMapper mapper):base(context){

            this._dbset = _context.Set<UsersModels>();
            _mapper = mapper;
        }

        public async Task<List<userInstance>?> SearchByNameOrUserName(string searchString)
        {
            return await this._dbset.Where(user => user.UserName!.StartsWith(searchString)|| user.Name!.Contains(searchString))
            .Select(u=> _mapper.Map<userInstance>(u)).ToListAsync();

        }

        public async Task<ICollection<TeamModel>?> GetUserTeams(int Id){

            return await _context.Teams!.Include(t=>t.Members).
                    Where(team => team.Members!.Any(
                        member => member.userId == Id
                    )).ToListAsync();
        }

    }
}