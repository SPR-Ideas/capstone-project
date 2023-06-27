using System.Text;
using System.Security.Cryptography;
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

            // It returns the credentials entity if username matches else returns null.

            return await _context.cred.FirstOrDefaultAsync(u => u.Username == username);
        }


        public String CreateHashPassword(string password){

            // It gnerates the hash password for a given string.

            var sha =  SHA256.Create();
            var asBytes = Encoding.Default.GetBytes(password);
            var hashedPassword = sha.ComputeHash(asBytes);

            return Convert.ToBase64String(hashedPassword);
        }


        public bool Add(CredentialsModel entity){

            // It Creates an new instance of the entity.

            entity.Password = (entity.Password==null)? null : CreateHashPassword(entity.Password);
            try{ _context.cred.Add(entity) ;}
            catch { return false ;}
            return true ;
        }


        public async Task<CredentialsModel?> CheckCredentials(userCredentials user){

            // Checks for the credentials and returns the credentials enity if it matches,
            // else returns null.

            CredentialsModel? _user  =  await GetByUsername(user.UserName);
            if(_user==null) {return null;}

            if(user.IsExternal){ return _user; }
            else {return ( _user.Password == CreateHashPassword(user.Password))?_user:null;}

        }
    }
}