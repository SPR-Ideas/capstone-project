using Matches.Models;
using Matches.Protos;
namespace Matches.Core
{
    public interface IScoreCardRepository
    {
        ScoreCard? createScoreCard(ScoreCardCreateRequest ScoreCard);

        Task<bool> updateScoreCard(EachBallRequest ScoreCard);
        Task<ScoreCard> GetById(int Id);
        Task<List<ScoreCard>> GetByIds(List<int> Ids);
    }
}