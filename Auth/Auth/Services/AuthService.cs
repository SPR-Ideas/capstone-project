
using Auth.Protos;
using Auth.Core;
using Auth.Models;
using Grpc.Core;

using System.Security.Claims;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;



namespace Auth.Services
{
    public class AuthService : authService.authServiceBase
    {
        private readonly IUnitOfWork _unitOfWork ;
        private readonly IConfiguration _configuration;
        public AuthService(IUnitOfWork unitOfWork, IConfiguration configuration ){
            _unitOfWork = unitOfWork;
            _configuration = configuration;

        }

        public string CreateToken(CredentialsModel credentials)
        {
            List<Claim> claim = new List<Claim>() {
                new Claim(ClaimTypes.Sid,Convert.ToString(credentials.Id)),
                new Claim(ClaimTypes.Name,credentials.Username)
            };

            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(
                _configuration.GetSection("AppSettings:Token").Value
                )); // Creating Secret key.

            var cred = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
            var token = new JwtSecurityToken(
                claims: claim,
                expires: DateTime.Now.AddMinutes(1),
                signingCredentials: cred
                ); // Creating Jwt Token

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);
            return jwt;
        }


        public override async Task<statusResponse> addCredentials(userCredentials request, ServerCallContext context)
        {

            bool _status = _unitOfWork.Credentials.Add(new CredentialsModel{
                Username  = request.UserName,
                Password = request.Password,
                IsExternal = request.IsExternal,
            });

            await _unitOfWork.CompleteAsync();


            return new statusResponse{Status = _status};

        }

        public override async Task<tokenResponse> getCredentials(userCredentials request, ServerCallContext context)
        {
            CredentialsModel?  user = await _unitOfWork.Credentials.CheckCredentials(request);

            string _token =  (user == null) ? "": CreateToken(user);

            return new tokenResponse{
                Token = _token,
                IsExternal = request.IsExternal
            };

        }
    }
}