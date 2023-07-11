using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Matches.Core;
using Matches.Core.Repository;
using Matches.Models;
using InventoryService =inventory.Protos.inventory;

namespace Matches.Data
{
    public class UnitOfWork : IUnitOfWork ,IDisposable
    {
        private readonly ApplicationDbContext _context;
        public IScoreCardRepository ScoreCard { get; set; }
        public InningsCardRepository Innings { get; }

        public UnitOfWork(
                        ApplicationDbContext context,
                        InventoryService.inventoryClient inventoryClient){
            _context = context;
            ScoreCard = new ScoreCardRepository(context,inventoryClient);
            Innings = new InningsCardRepository(context);
        }

        public async Task CompleteAsync(){
           await  _context.SaveChangesAsync();
        }

        public void Dispose(){
            _context.Dispose();
        }
    }
}