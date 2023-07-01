using AutoMapper;
using inventory.Models; // Replace with your EF model namespace
using inventory.Protos; // Replace with your Protos namespace

namespace inventory.Data.Configuration
{

    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<UsersModels, userInstance>();
            CreateMap<TeamModel , teamInstance>();
            CreateMap<TeamMemberModel,teamMemberInstance>();

            CreateMap<MatchInstance,MatchModels>();
            CreateMap<MatchModels , MatchInstance>();
            // Define mappings for other models as needed
        }
}

}