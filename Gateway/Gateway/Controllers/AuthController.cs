using System.Net.Security;
using Gateway.Dto;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using AuthProto = Auth.Protos;
using AuthService = Auth.Protos.authService;
using InventoryService = inventory.Protos.inventory;
using InventoryProto = inventory.Protos;
namespace Gateway.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AuthService.authServiceClient _authService;
        private readonly InventoryService.inventoryClient _inventoryClient;

        public AuthController(
            AuthService.authServiceClient authServiceClient,
            InventoryService.inventoryClient inventoryClient
            ){
            _authService = authServiceClient;
            _inventoryClient = inventoryClient;
        }


        [HttpPost("auth")]
        public async Task<IActionResult> Authenticate(UserCredentials cred) {
            var result = await _authService.getCredentialsAsync(
                    new AuthProto.userCredentials{
                        UserName = cred.Username,
                        Password = cred.Password,
                        IsExternal = cred.IsExternal
                        });
            return Ok(result);
        }

        [HttpPost("SingUpUser")]
        public async Task<IActionResult> CreatUser(UserInstance user){
            var result = await _inventoryClient.createUserAsync(
                    new InventoryProto.userInstance{
                        UserName = user.UserName,
                        Name = user.Name,
                        Age = user.Age,
                        BattingStyles = user.BattingStyle,
                        BlowingStyles = user.BlowingStyle,
                        IsExternal = user.IsExternal,
                        Password = user.Password,
                        Role = user.Role,
                    }
            );
            return Ok(result);
        }
    }
}
