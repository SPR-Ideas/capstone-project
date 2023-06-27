using System.Xml;
using System.ComponentModel.DataAnnotations;

namespace Auth.Models
{
    public class CredentialsModel
    {
        [Key]
        public int Id { get; set; }
        public string Username { get; set; }
        public string? Password { get; set; }
        public bool IsExternal { get; set; }
    }
}