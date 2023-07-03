
using Matches.Data;
using Matches.Protos;
using Grpc.Core;
using Matches.Models;
using InventoryService = inventory.Protos.inventory;
using AutoMapper;

namespace Matches.Services
{
    public class MatchService : Protos.Matches.MatchesBase
    {
        private readonly UnitOfWork _unitOfwork;
        private readonly IMapper _mapper;

        public MatchService(ApplicationDbContext context,
                        InventoryService.inventoryClient client,
                        IMapper mapper
                    ){
            _unitOfwork = new UnitOfWork(context,client);
            _mapper = mapper;
        }


        public override async Task<statusResponse> updateEachBall(EachBallRequest request, ServerCallContext context)
        {
            try{
                await _unitOfwork.ScoreCard.updateScoreCard(request);
                await  _unitOfwork.CompleteAsync();
                return new statusResponse{Status = true};
            }catch(Exception ){return new statusResponse{Status = false};}

        }

        public override async Task<scoreCardResponse> CreateScoreCard(ScoreCardCreateRequest request, ServerCallContext context)
        {
            ScoreCard? scoreCard = _unitOfwork.ScoreCard.createScoreCard(request);
            await _unitOfwork.CompleteAsync();
            return new scoreCardResponse{ScoreCardId = scoreCard!.Id};
        }

        public override async Task<scoreCardRequest> getScoreCardById(scoreCardRequest request, ServerCallContext context)
        {
            return _mapper.Map<scoreCardRequest>( await _unitOfwork.ScoreCard.GetById(request.Id));
        }

        public override async Task<listOfScoreCard> getScoreCardsByIds(listOfScoreCard request, ServerCallContext context)
        {
            var response = new listOfScoreCard();
            List<int> Ids = request.ScoreCard.Select(scoreCard => scoreCard.Id).ToList();
            List<ScoreCard> ScoreCards = await _unitOfwork.ScoreCard.GetByIds(Ids);
            response.ScoreCard.Add(ScoreCards.Select(scoreCard => _mapper.Map<scoreCardRequest>(scoreCard)).ToList());
            return response;
        }
    }
}