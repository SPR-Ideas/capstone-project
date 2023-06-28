using Grpc.Core;
using inventory;
using inventory.Core;
using inventory.Data;

namespace inventory.Services
{
    public class GreeterService : Greeter.GreeterBase
    {
        private readonly IUnitOfWork _unitOfWork  ;
        public GreeterService(UnitOfWork unitOfwork)
        {
            _unitOfWork = unitOfwork;
        }

        public override Task<HelloReply> SayHello(HelloRequest request, ServerCallContext context)
        {
            return Task.FromResult(new HelloReply
            {
                Message = "Hello " + request.Name
            });
        }
    }
}