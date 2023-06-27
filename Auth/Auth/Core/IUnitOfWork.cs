using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Auth.Core ;

namespace Auth.Core
{
    public interface IUnitOfWork
    {
        ICredentialsRepository Credentials {get;}
        Task CompleteAsync();
    }
}