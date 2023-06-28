using System.Net.Http.Headers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Data;
using inventory.Models;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class TeamRepository : GenericReposistory<TeamModel>,ITeamRepository
    {

        public TeamRepository(ApplicationDbContext context) : base(context){
            this._dbset = context.Set<TeamModel>();
        }

        public override async Task<TeamModel?> GetById(int Id)
        {
            await this._dbset.Include(team => team.Members).ToListAsync();
            return await this._dbset.FindAsync(Id);
        }

        public override async Task<bool> Add(TeamModel team){
            try {
                await this._dbset.Include(team => team.Members).ToListAsync();
                this._dbset.Add(team);
            }
            catch(Exception ) { return false; }
            return true;
        }

        public async Task<bool> MakeTeamCaptain(int Id,UsersModels user){
            try {
                TeamModel? _team =  await GetById(Id);
                if (_team == null) return false;
                _team.Members!.ToList().ForEach(player => player.IsCaptain = false);
                _team.Members!.SingleOrDefault(m=>m.Id == user.Id )!.IsCaptain = true;
            }
            catch(Exception) { return false; }
            return true;
        }

    }
}