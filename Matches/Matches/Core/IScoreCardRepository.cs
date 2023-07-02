using Matches.Protos;
namespace Matches.Core
{
    public interface IScoreCardRepository
    {
        bool createScoreCard(ScoreCardCreateRequest ScoreCard);

        Task<bool> updateScoreCard(EachBallRequest ScoreCard);
    }
}