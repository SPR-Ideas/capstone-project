using Grpc.Net.Client;
using inventory.Data;
using inventory.Services;
using Microsoft.EntityFrameworkCore;
using AuthProto = Auth.Protos.authService;

namespace inventory
{
    public static  class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Additional configuration is required to successfully run gRPC on macOS.
            // For instructions on how to configure Kestrel and gRPC clients on macOS, visit https://go.microsoft.com/fwlink/?linkid=2099682

            // Add services to the container.
            builder.Services.AddGrpc();
            builder.Services.AddGrpcReflection();
            builder.Services.AddGrpcHttpApi();

            builder.Services.AddAutoMapper(typeof(Program).Assembly);

            builder.Services.AddDbContext<ApplicationDbContext>(
                options => options.UseSqlServer(
                    builder.Configuration.GetConnectionString("LocalDb")
                )
            );

            var AuthChannel = GrpcChannel.ForAddress(
                                    "http://localhost:5218");
            var client = new AuthProto.authServiceClient(AuthChannel);

            builder.Services.AddSingleton(client);

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            app.MapGrpcService<InventoryService>();

            app.MapGrpcReflectionService();

            app.MapGet("/", () => "Communication with gRPC endpoints must be made through a gRPC client. To learn how to create a client, visit: https://go.microsoft.com/fwlink/?linkid=2086909");

            app.Run();
        }
    }
}