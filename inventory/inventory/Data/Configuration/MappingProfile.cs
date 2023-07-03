using System.Text.RegularExpressions;
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

            //  CreateMap<Matches.Protos.teamInstanceWithUser,teamInstanceWithUser>();
            CreateMap<teamInstanceWithUser,Matches.Protos.teamInstanceWithUser>();
            // CreateMap<teamInstanceWithUser,Matches.Protos.teamInstanceWithUser>()
            // .ForMember(dest => dest.Members, opt => opt.MapFrom(src => src.Members));
            CreateMap<teamMemberWithUsers,Matches.Protos.teamMemberWithUsers>();
            CreateMap<userInstance,Matches.Protos.userInstance>();

            CreateMap<Matches.Protos.scoreCardRequest,scoreCardRequest>();
            CreateMap<Matches.Protos.InningsScoreCardgrpc,InningsScoreCardgrpc>();
            CreateMap<Matches.Protos.BlowingInningsgrpc,BlowingInningsgrpc>();
            CreateMap<Matches.Protos.BattingInningsgrpc,BattingInningsgrpc>();

            CreateMap<MatchModels,MatchInstanceResponse>()
            .ForMember(dest => dest.Result, opt => opt.MapFrom(src => src.Result ?? string.Empty));;
            CreateMap<DateTime, long>().ConvertUsing(d => d.Ticks);

        }
}

}