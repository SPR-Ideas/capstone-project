
using inventory.Data;
using Microsoft.EntityFrameworkCore;

namespace inventory.Core.Repository
{
    public class GenericReposistory<T> : IGenericRepository<T>  where T : class
    {

        internal DbSet<T> _dbset;
        public GenericReposistory(ApplicationDbContext context){
            _dbset = context.Set<T>();

        }

        public virtual async Task<bool> Add(T entity)
        {
            try{ await _dbset.AddAsync(entity); }
            catch(Exception) { return false ; }
            return true;
        }


        public virtual async Task<T?> GetById(int Id)
        {
            return await _dbset.FindAsync(Id);
        }


        public virtual bool Remove(T entity)
        {
            try {
                _dbset.Remove(entity);
            }
            catch(Exception) { return false ; }
            return true;
        }


        public virtual T Update(T entity)
        {
            _dbset.Update(entity);
            return entity;
        }
    }
}