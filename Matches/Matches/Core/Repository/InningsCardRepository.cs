using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Matches.Data;
using Matches.Models;
using Matches.Protos;
using Microsoft.EntityFrameworkCore;

namespace Matches.Core.Repository
{
    public class InningsCardRepository : IInningsCardRepository
    {
        private readonly ApplicationDbContext _context;

        public InningsCardRepository(
                ApplicationDbContext context){
            _context = context;
        }

        public async Task<bool> changeBatsMen(changeBatsmenReq request)
        {
            try{
                // InningsScoreCard? scoreCard = await  _context.InningsScoreCards!.FindAsync(request.InningsId);
                InningsScoreCard? scoreCard = await
                        _context.InningsScoreCards!.Include(a=>a.BattingStats)
                        .Include(a=>a.BlowingStats)
                        .FirstAsync(x=>x.Id==request.InningsId);
                scoreCard!.BattingStats!.First(x=>x.Id==request.CurrentBatsmen)!.IsCurrent= -1;
                scoreCard!.BattingStats!.First(x=>x.Id==request.NewBatsmen)!.IsCurrent= 1;
                return true;
            }
            catch(Exception){return false;}

        }

        public async  Task<bool> changeblower(changeBlowerReq request)
        {
            try{
                // InningsScoreCard? scoreCard = await  _context.InningsScoreCards!.FindAsync(request.InningsId);
                InningsScoreCard? scoreCard = await
                        _context.InningsScoreCards!.Include(a=>a.BattingStats)
                        .Include(a=>a.BlowingStats)
                        .FirstAsync(x=>x.Id==request.InningsId);
                scoreCard!.BlowingStats!.First(x=>x.Id==request.CurrentBlowerId)!.IsCurrent= 0;
                scoreCard!.BlowingStats!.First(x=>x.Id==request.NewBlowerId)!.IsCurrent= 1;
                return true;
            }
            catch(Exception){return false;}

        }

        public async Task<bool> FreshInnings(freshInnings data)
        {
            try{
                InningsScoreCard? scoreCard = await
                        _context.InningsScoreCards!.Include(a=>a.BattingStats)
                        .Include(a=>a.BlowingStats)
                        .FirstAsync(x=>x.Id==data.InningsId);

                var striker  = scoreCard!.BattingStats!.First(x=>x.Id==data.StrikerId);
                striker.IsCurrent = 1;
                var nonstriker  = scoreCard!.BattingStats!.First(x=>x.Id==data.NonStrikerId);
                nonstriker.IsCurrent=1;
                var blower = await _context.BlowingInnings!.FindAsync(data.BlowerId);
                blower!.IsCurrent=1;
                return true;
            }
            catch(Exception){return false;}
        }
    }
}