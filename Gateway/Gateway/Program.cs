using System.Text.RegularExpressions;
using Grpc.AspNetCore.ClientFactory;
using Grpc.Net.Client;
using AuthProto = Auth.Protos.authService;
using InventoryProto = inventory.Protos.inventory;
using MatchProto = Matches.Protos.Matches;
using AutoMapper;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

namespace Gateway
{
    public static class  Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            builder.Services.AddAutoMapper(typeof(Program).Assembly);
            builder.Services.AddAuthorization();
            builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
            .AddJwtBearer(options =>
            {
                options.TokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(
                    builder.Configuration.GetSection("AppSettings:Token").Value!)),
                    ValidateLifetime = true,
                };

            });



            var AuthChannel = GrpcChannel.ForAddress(
                                    "http://auth:80");
            var MatchChannel = GrpcChannel.ForAddress(
                                    "http://matches:80");

            var InventoryChannel = GrpcChannel.ForAddress(
                                    "http://inventory:80");

            var Authclient = new AuthProto.authServiceClient(AuthChannel);
            var MatchClient = new MatchProto.MatchesClient(MatchChannel);
            var InventoryClient = new InventoryProto.inventoryClient(InventoryChannel);


            builder.Services.AddSingleton(Authclient);
            builder.Services.AddSingleton(MatchClient);
            builder.Services.AddSingleton(InventoryClient);

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            // if (app.Environment.IsDevelopment())
            // {
                app.UseSwagger();
                app.UseSwaggerUI();
            // }

            app.UseAuthorization();
            app.MapControllers();

            app.Run();
        }
    }
}