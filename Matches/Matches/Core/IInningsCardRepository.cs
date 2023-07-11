using Matches.Models;
using Matches.Protos;

namespace Matches.Core
{
    public interface IInningsCardRepository
    {
        // Task<InningsScoreCard> createInningWithTeam(teamInstanceWithUser team);

        Task<bool> FreshInnings(freshInnings data);
        Task<bool> changeBatsMen(changeBatsmenReq request);
        Task<bool> changeblower(changeBlowerReq request);

    }
}