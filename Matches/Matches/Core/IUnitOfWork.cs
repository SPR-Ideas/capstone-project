
using Matches.Models;
namespace Matches.Core
{
    public interface IUnitOfWork
    {
        IScoreCardRepository ScoreCard { get; set; }
        Task CompleteAsync();

    }
}