using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Matches.Data;
using Matches.Protos;
using Grpc.Core;

namespace Matches.Services
{
    public class MatchService : Protos.Matches.MatchesBase
    {
        private readonly UnitOfWork _unitOfwork;

        public MatchService(ApplicationDbContext context){
            _unitOfwork = new UnitOfWork(context);
        }


        public override async Task<statusResponse> updateEachBall(EachBallRequest request, ServerCallContext context)
        {
            try{
                await _unitOfwork.ScoreCard.updateScoreCard(request);
                await  _unitOfwork.CompleteAsync();
                return new statusResponse{Status = true};
            }catch(Exception ){return new statusResponse{Status = false};}

        }

    }
}