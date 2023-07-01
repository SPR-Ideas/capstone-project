using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using inventory.Models;
namespace inventory.Core
{
    public interface IUnitOfWork
    {
        IUserRepository Users{get;}
        // ILeaderBoardRespository LeaderBoard {get;}
        ITeamRepository Team {get;}
        ILeaderBoardRespository LeaderBoard {get;}
        Task CompleteAsync();


    }
}