
namespace inventory.Core
{
    public interface IGenericRepository<T> where T : class
    {
        Task<bool> Add(T entity); // Adds to the Database
        bool Remove(T entity); // Removes from the Database
        Task<T?> Update(T entity); // Update the Database
        Task<T?> GetById(int Id); // Get entity by Id.
    }
}