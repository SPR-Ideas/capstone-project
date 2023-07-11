using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MatchService = Matches.Protos.Matches;
using MatchProtos = Matches.Protos;
using Microsoft.AspNetCore.Mvc;
using Gateway.Dto;

namespace Gateway.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ScoreCardController : ControllerBase
    {
        private MatchService.MatchesClient _mathcService;

        public ScoreCardController(
            MatchService.MatchesClient matchService
        )
        {
            _mathcService = matchService;
        }

        [HttpPut("UpdateEachBall")]
        public async Task<IActionResult> UpdateEachBall(EachBallUpdate update){
            try{
                var response = await _mathcService.updateEachBallAsync(
                new MatchProtos.EachBallRequest{
                    BatsmanId = update.BatsmanId,
                    BlowerId = update.BlowerId,
                    BlowerName = update.BlowerName,
                    Options = update.Options,
                    Runs = update.Runs,
                    ScoreCardID = update.ScoreCardID,
                }
            );
            return Ok(response);
            }
            catch(Exception){
                return Ok();
            }

        }

        [HttpGet("GetScoreCard")]
        public async Task<IActionResult> GetScoreCard(int Id){
            var response = await _mathcService.getScoreCardByIdAsync(
                    new MatchProtos.scoreCardRequest{Id = Id});
            return Ok(response);
        }

        [HttpPut("changeBatsman")]
        public async Task<IActionResult> ChangeBatsman(changeBatsmen request){
            var response = await _mathcService.changeBatsmenAsync(
                    new MatchProtos.changeBatsmenReq{
                        CurrentBatsmen = request.currentBatsmen,
                        InningsId = request.inningsId,
                        NewBatsmen = request.newBatsmen
                        }
            );
            return Ok(response);

        }


        [HttpPut("changeBlower")]
        public async Task<IActionResult> ChangeBlower(changeBlower request){
            var response = await _mathcService.changeBlowerAsync(
                    new MatchProtos.changeBlowerReq{
                        CurrentBlowerId = request.currentBlowerId,
                        InningsId = request.inningsId,
                        NewBlowerId = request.newBlowerId
                        }
            );
            return Ok(response);

        }

        [HttpPut("freshInnings")]
        public async Task<IActionResult> FreshInnings(freshInnings request){
            var response = await _mathcService.setfreshInningsAsync(
                    new MatchProtos.freshInnings{
                        InningsId = request.InningsId,
                        BlowerId = request.blowerId,
                        NonStrikerId = request.nonStrikerId,
                        StrikerId = request.strikerId
                    });

            return Ok(response);

        }


    }
}