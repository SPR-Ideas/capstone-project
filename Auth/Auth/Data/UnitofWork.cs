using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Auth.Core;
using Auth.Core.Repository;
using Auth.Data;

namespace Auth.Data
{
    public class UnitofWork : IUnitOfWork , IDisposable
    {
        public ICredentialsRepository Credentials {get; private set; }
        private readonly ApplicationDbContext _context;
        public UnitofWork(ApplicationDbContext context){
            _context = context;
            Credentials  = new CredentialsRepository(context);
        }

        public async Task CompleteAsync(){
            await _context.SaveChangesAsync();
        }

        public void Dispose(){
            _context.Dispose();
        }
    }
}