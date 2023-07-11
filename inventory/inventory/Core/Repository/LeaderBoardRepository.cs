
using AutoMapper;
using inventory.Data;
using inventory.Models;
using inventory.Protos;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class LeaderBoardRepository : ILeaderBoardRespository

    {
        private readonly ApplicationDbContext  _context;
        private readonly IMapper _mapper;
        public LeaderBoardRepository(ApplicationDbContext  context,IMapper mapper){
            _context   = context;
            _mapper = mapper;
        }


        public async Task<List<userInstance>> GetLeaderboard(int page){
            // Return the list of users with respect to their most runs scored.
             return  await _context.Users!
                    .OrderByDescending(u => u.Runs) // Sort users by Runs in descending order
                    .ThenBy(u => u.Id)
                    .Skip((page - 1) * 20)
                    .Take(20).Select(u=> _mapper.Map<userInstance>(u)).ToListAsync();
        }


        public async Task<List<userInstance>> GetLeaderboardWithWicktes(int page){
            page = page==0?1:page;
            // Returns the list of UsersModels with respect to thier most wickets taken
            return await _context.Users!
                    .OrderByDescending(u => u.Wickets)
                    .ThenBy(u => u.Id)
                    .Skip((page - 1) * 20)
                    .Take(20)
                    .Select(u=> _mapper.Map<userInstance>(u)).ToListAsync();
        }


        public async Task<bool> UpdateUsersHistory( int userId , int runs,int wickets ){
            // It Adds the User Socre to each and every matche to their profile.
            try{
                UsersModels? user  = await _context.Users!.FindAsync(userId);
                user!.Runs += runs;
                user.Wickets += wickets;
                user.Matches ++;
                _context.Users.Update(user);
            }catch(Exception ){return false;}
            return true;
        }

    }
}