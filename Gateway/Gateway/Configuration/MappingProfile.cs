using AutoMapper;
using Gateway.Dto;
using InventoryProto =  inventory.Protos;

namespace inventory.Data.Configuration
{

    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
           CreateMap<InventoryProto.teamInstance,TeamInstance>();
           CreateMap<InventoryProto.teamMemberInstance,TeamMemberInstance>();
           CreateMap<TeamInstance,InventoryProto.teamInstance>();
           CreateMap<TeamMemberInstance,InventoryProto.teamMemberInstance>();
            CreateMap<DateTime, long>().ConvertUsing(d => d.Ticks);

        }
}

}