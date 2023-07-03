using Matches.Models;
using Matches.Protos;
namespace Matches.Core
{
    public interface IScoreCardRepository
    {
        ScoreCard? createScoreCard(ScoreCardCreateRequest ScoreCard);

        Task<bool> updateScoreCard(EachBallRequest ScoreCard);
    }
}