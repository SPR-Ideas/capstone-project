using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Matches.Core;
using Matches.Core.Repository;
using Matches.Models;

namespace Matches.Data
{
    public class UnitOfWork : IUnitOfWork ,IDisposable
    {
        private readonly ApplicationDbContext _context;
        public IScoreCardRepository ScoreCard { get; set; }

        public UnitOfWork(ApplicationDbContext context){
            _context = context;
            ScoreCard = new ScoreCardRepository(context);
        }

        public async Task CompleteAsync(){
           await  _context.SaveChangesAsync();
        }

        public void Dispose(){
            _context.Dispose();
        }
    }
}