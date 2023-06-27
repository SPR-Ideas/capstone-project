using System.Net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Auth.Models;
using Auth.Protos;
namespace Auth.Core
{
    public interface ICredentialsRepository
    {
        Task<CredentialsModel?> GetByUsername(string username);
        Task<CredentialsModel?> CheckCredentials(userCredentials user);
        bool Add(CredentialsModel entity);
    }
}