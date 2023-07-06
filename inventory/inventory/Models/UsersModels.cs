
using System.Globalization;
using System.ComponentModel.DataAnnotations;
using inventory.Protos;
using Microsoft.EntityFrameworkCore;

namespace inventory.Models
{
    [Index(nameof(UserName),IsUnique = true)]
    public class UsersModels
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? UserName { get; set; }
        public int Age  { get;set; }
        public string? DisplayImage {get;set;}
        public string? Role { get; set; }
        public string? BattingStyles { get; set; }
        public string? BlowingStyles {get;set;}
        // public LeaderboardModel? Leaderboard { get; set; }
        public int Runs { get; set; }
        public int Wickets { get; set;}
        public int Matches { get; set; }

        public static explicit operator UsersModels(userInstance v)
        {
            UsersModels user = new UsersModels();
            if(v.Id!=0){user.Id = v.Id;}
            user.UserName = v.UserName;
            user.Name = v.Name;
            user.Age = v.Age;
            user.BattingStyles = v.BattingStyles;
            user.BlowingStyles  = v.BlowingStyles;
            user.Role = v.Role;
            user.Wickets = v.Wickets;
            user.Runs = v.Runs;
            user.Matches = v.Matches;
            user.DisplayImage = v.DisplayImage;

            return user;
        }
    }
}