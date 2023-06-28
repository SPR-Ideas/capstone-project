
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
            throw new NotImplementedException();
        }
    }
}