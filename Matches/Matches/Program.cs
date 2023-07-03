using System.Text.RegularExpressions;
using Grpc.Net.Client;
using Matches.Data;
using Matches.Services;
using InventoryService = inventory.Protos.inventory;
using Microsoft.EntityFrameworkCore;
using AutoMapper;
// using Matches.Services;

namespace Matches
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            builder.Services.AddAutoMapper(typeof(Program).Assembly);
            // Additional configuration is required to successfully run gRPC on macOS.
            // For instructions on how to configure Kestrel and gRPC clients on macOS, visit https://go.microsoft.com/fwlink/?linkid=2099682

            // Add services to the container.
            builder.Services.AddGrpc();
            builder.Services.AddGrpcReflection();
            builder.Services.AddDbContext<ApplicationDbContext>(
                options => options.UseSqlServer(
                    builder.Configuration.GetConnectionString("LocalDb")
                )
            );
            
            var inventoryChannel = GrpcChannel.ForAddress(
                                    "http://localhost:5106");

            var client = new InventoryService.inventoryClient(inventoryChannel);

            builder.Services.AddSingleton(client);

            var app = builder.Build();
            app.MapGrpcService<MatchService>();
            app.MapGrpcReflectionService();

            app.MapGet("/", () => "Communication with gRPC endpoints must be made through a gRPC client. To learn how to create a client, visit: https://go.microsoft.com/fwlink/?linkid=2086909");

            app.Run();
        }
    }
}