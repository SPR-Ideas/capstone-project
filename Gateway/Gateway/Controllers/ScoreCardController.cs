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
            var response = await _mathcService.updateEachBallAsync(
                new MatchProtos.EachBallRequest{
                    BatsmanId = update.BatsmanId,
                    BlowerId = update.BlowerId,
                    BlowerName = update.BlowerName,
                }
            );
          return Ok(response);
        }
    }
}