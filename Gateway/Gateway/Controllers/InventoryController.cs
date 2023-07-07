
using System.Text.RegularExpressions;
using Microsoft.AspNetCore.Mvc;
using InventroyService = inventory.Protos.inventory;
using inventoryProto = inventory.Protos;
using Gateway.Dto;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using System.Net;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Grpc.Core;

namespace Gateway.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class InventoryController : ControllerBase
    {
        private readonly InventroyService.inventoryClient _inventoryClient;
        private readonly IMapper _mapper;

        public InventoryController(
            InventroyService.inventoryClient inventoryClient,
            IMapper mapper
            ){
            _inventoryClient = inventoryClient;
            _mapper = mapper;
        }
        [HttpPut("UpdateUser")]
        public async Task<IActionResult> updateUser(UserInstance user){
            var result = await _inventoryClient.updateUserAsync(
                new inventoryProto.userInstance{
                        UserName = user.UserName,
                        Name = user.Name,
                        Age = user.Age,
                        BattingStyles = user.BattingStyles,
                        BlowingStyles = user.BlowingStyles,
                        IsExternal = user.IsExternal,
                        Password = user.Password,
                        Role = user.Role,
                        Id = user.Id,
                        Matches = user.Matches,
                        Runs = user.Runs,
                        Wickets = user.Wickets,
                        DisplayImage = user.DisplayImage,

                }
            );
            return Ok(result);
        }


        [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpGet("getInventory")]
        public async Task<IActionResult>GetInventory(){

            Metadata headers = new()
            {
                { "Authorization", Request.Headers.Authorization.Single() }
            };

            var result = await _inventoryClient.getInventoryAsync(
                new inventoryProto.emptyRequest{},
                headers :headers
            );
            return Ok(result);
        }

         [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
        [HttpPost("CreateTeam")]
        public async Task<IActionResult>CreateTeam(TeamInstance team){
            Metadata headers = new()
            {
                { "Authorization", Request.Headers.Authorization.Single() }
            };

            var result = await _inventoryClient.createTeamAsync(
                _mapper.Map<inventoryProto.teamInstance>(team),
                headers: headers
            );
            return Ok(result);
        }


        [HttpPut("UpdateTeam")]
        public async Task<IActionResult>UpatedTeam(TeamInstance team){

            var result = await _inventoryClient.updateTeamAsync(
                _mapper.Map<inventoryProto.teamInstance>(team)
            );
            return Ok(result);
        }

        [HttpPut("MakeCaptain")]
        public async Task<IActionResult> makeTeamCaptain(makeCaptain obj){
            var result = await _inventoryClient.makeCaptainAsync(
                new inventoryProto.makeCaptainInstance{
                    TeamId =obj.TeamId,
                    UserId = obj.captainId
                }
            );
            return Ok(result);
        }

        [HttpPost("CreateMatch")]
        public async Task<IActionResult>createMatch(createMatch match){

            inventoryProto.MatchInstance t = new inventoryProto.MatchInstance();
                    t.HostTeamId = match.HostTeam_id;
                    t.VisitorTeamId = match.VisitorTeam_id;
                    t.Overs = match.Overs;
                    t.Wickets = match.Wickets;
                    t.IsHostInnings = match.IsHostInnings;



            var result = await _inventoryClient.createMatchAsync(
                t
                            );
            return Ok(result);
        }

        [HttpGet("GetLeaderBoard")]
        public async Task<IActionResult>getLeaderboard(bool mode=true , int page=1,string? searchString=""){
            var result = await _inventoryClient.getLeaderBoardAsync(
                new inventoryProto.LeaderBoardRequest{
                    Mode = mode,
                    Page = page,
                    SearchString = searchString
                }
            );
            return Ok(result);
        }

        [HttpGet("GetTeams")]
        public async Task<IActionResult> getTeamsBySearchString(string searchString){
            var result = await _inventoryClient.getTeamsAsync(
                new inventoryProto.searchStringRequest{SearchString = searchString}
            );
            return Ok(result);
        }
    }
}