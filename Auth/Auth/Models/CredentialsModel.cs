using System.Xml;
using System.ComponentModel.DataAnnotations;
using Microsoft.EntityFrameworkCore;

namespace Auth.Models
{
    [Index(nameof(Username),IsUnique = true)]
    public class CredentialsModel
    {
        [Key]
        public int Id { get; set; }
        public string Username { get; set; }
        public string? Password { get; set; }
        public bool IsExternal { get; set; }
    }
}