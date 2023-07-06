using System.Runtime.CompilerServices;
using System.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using System.Threading.Tasks;
using inventory.Data;
using inventory.Models;
using Microsoft.EntityFrameworkCore;
using inventory.Protos;

namespace inventory.Core.Repository
{
    public class TeamRepository : GenericReposistory<TeamModel>,ITeamRepository
    {
        private readonly IMapper _mapper;
        public TeamRepository(ApplicationDbContext context,IMapper mapper) : base(context){
            this._dbset = context.Set<TeamModel>();
            _mapper = mapper;
        }

        public override async Task<TeamModel?> GetById(int Id)
        {
            await this._dbset.Include(team => team.Members).ToListAsync();
            return await this._dbset.FindAsync(Id);
        }

        public async Task<bool> Add(TeamModel team,int captain){
            try {
                await this._dbset.Include(team => team.Members).ToListAsync();
                team.CaptainId = captain;
                this._dbset.Add(team);
            }
            catch(Exception ) { return false; }
            return true;
        }

        public async Task<bool> MakeTeamCaptain(int Id,int userId){
            try {
                TeamModel? _team =  await GetById(Id);
                if (_team == null) return false;
                _team.Members!.ToList().ForEach(player => player.IsCaptain = false);
                _team.Members!.SingleOrDefault(m=>m.userId == userId )!.IsCaptain = true;
            }
            catch(Exception) { return false; }
            return true;
        }

        public override async Task<TeamModel?> Update(TeamModel entity)
        {
            // await _dbset.Include(x=>x.Members).ToListAsync();
            _dbset.Update(entity);

            return await Task.FromResult(entity);
        }

        public async Task<bool> RemovePlayes(int Id, List<int> playerShouldBeRetained){
            try{
                TeamModel? team = await GetById(Id);
                team!.Members!.RemoveAll(m => !playerShouldBeRetained.Contains(m.Id));
            }catch(Exception) { return false; }

            return true;
        }

        public async Task<List<UsersModels>?> GetUserRangeById(List<int> Ids){
            return await _context.Users!.Where(i => Ids.Contains(i.Id)).ToListAsync();
        }


        public async Task<List<teamInstanceWithUser>> ReturnTeamsWithPlayerInstance(List<TeamModel> teams){

            List<int> userIds = teams
                            .SelectMany(team => team.Members!.Select(member => member.userId))
                            .Distinct()
                            .ToList();

            Dictionary<int,UsersModels>? userMap =
                    (await GetUserRangeById(userIds))!.
                    ToDictionary( user=>user.Id, user=>user);

            List<teamInstanceWithUser> response = new List<teamInstanceWithUser>();
            foreach (var team in teams){
                teamInstanceWithUser _team = new teamInstanceWithUser();
                _team.Id = team.Id;
                _team.Name = team.Name;
                _team.Count = team.Count;
                _team.CaptainId = team.CaptainId;

                foreach (var members in team.Members!){
                    teamMemberWithUsers _member = new teamMemberWithUsers();
                    _member.Id = members.Id;
                    _member.IsCaptain = members.IsCaptain;
                    _member.IsPlaying = members.IsPlaying;
                    _member.User =
                            _mapper.Map<userInstance>(
                                userMap.GetValueOrDefault(members.userId));
                    _team.Members.Add(_member);
                }
                response.Add(_team);
            }
            return response;
        }

    }
}