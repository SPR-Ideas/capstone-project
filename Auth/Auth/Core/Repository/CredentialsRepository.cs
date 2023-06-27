using Auth.Models;
using Auth.Data;
using Auth.Protos;
using Microsoft.EntityFrameworkCore;

namespace Auth.Core.Repository
{
    public class CredentialsRepository : ICredentialsRepository
    {
        private readonly ApplicationDbContext _context;
        public CredentialsRepository(ApplicationDbContext context){
            _context = context;
        }
        public async Task<CredentialsModel?> GetByUsername(string username){
            return await _context.cred.FirstOrDefaultAsync(u => u.Username == username);
        }

        public bool Add(CredentialsModel entity){
            try{ _context.cred.Add(entity) ;}
            catch { return false ;}
            return true ;
        }

        public async Task<CredentialsModel>? CheckCredentials(userCredentials user){
            CredentialsModel? _user  =  await GetByUsername(user.UserName);
            if(_user==null) {return null;}

            if(user.IsExternal){ return _user; }
            else {return ( _user.Password == user.Password)?_user:null;}
        
        }
    }
}