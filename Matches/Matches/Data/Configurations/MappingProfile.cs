
using AutoMapper;
using Matches.Models;
using Matches.Protos;

namespace Matches.Data.Configurations
{
    public class MappingProfile : Profile
    {
        public MappingProfile(){
            CreateMap<ScoreCard,scoreCardRequest>()
            .ForMember(dest => dest.HostTeamName, opt => opt.MapFrom(src => src.HostTeamName ?? string.Empty))
            .ForMember(dest => dest.VisitorTeamName, opt => opt.MapFrom(src => src.VisitorTeamName ?? string.Empty));
            CreateMap<InningsScoreCard,InningsScoreCardgrpc>();
            CreateMap<BattingInnings,BattingInningsgrpc>()
            .ForMember(dest => dest.BlowedBy, opt => opt.MapFrom(src => src.BlowedBy ?? string.Empty))
            .ForMember(dest => dest.CaughtBy, opt => opt.MapFrom(src => src.CaughtBY ?? string.Empty));
            CreateMap<BlowingInnings,BlowingInningsgrpc>();

            CreateMap<scoreCardRequest,ScoreCard>();
            CreateMap<InningsScoreCardgrpc,InningsScoreCard>();
            CreateMap<BattingInningsgrpc,BattingInnings>();
            CreateMap<BlowingInningsgrpc,BlowingInnings>();

        }
    }
}