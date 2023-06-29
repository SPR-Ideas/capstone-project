
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
        public string? Role { get; set; }
        public string? BattingStyles { get; set; }
        public string? BlowingStyles {get;set;}

        public static explicit operator UsersModels(userInstance v)
        {
            UsersModels user = new UsersModels();
            if(v.Id!=0){user.Id = v.Id;}
            user.UserName = v.UserName;
            user.Name = v.Name;
            user.Age = v.Age;
            user.BattingStyles = v.BattingStyle;
            user.BlowingStyles  = v.BlowingStyle;
            user.Role = v.Role;

            return user;
        }
    }
}