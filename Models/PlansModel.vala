using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Modules.Subscriptions.Entities;

namespace SinticBolivia.Modules.Subscriptions.Models
{
    public class PlansModel
    {
        public PlansModel()
        {

        }
        public void create(Plan plan) throws SBException
        {
            if( plan.product_id <= 0 )
                throw new SBException.GENERAL("Invalid product identifier, unable to create plan");
            if( plan.name == null || plan.name.strip().length <= 0 )
                throw new SBException.GENERAL("Invalid plan name, unable to create it");
            if( plan.status == null || plan.status.strip().length <= 0 )
                plan.status = Plan.STATUS_DISABLED;
            message("Creating plan...");
            plan.save();
        }
        public Plan? read(long id) throws SBException
        {
            if( id <= 0 )
                throw new SBException.GENERAL("Invalid plan identifier, unable to read");
            var plan = Entity.read<Plan>(id);
            if( plan == null )
                throw new SBException.GENERAL("The subscription plan does not exists");
            return plan;
        }
        public void read_all()
        {
            
        }
        public void update(Plan plan) throws SBException
        {
            if( plan.product_id <= 0 )
                throw new SBException.GENERAL("Invalid product identifier, unable to update plan");
            if( plan.name == null || plan.name.strip().length <= 0 )
                throw new SBException.GENERAL("Invalid plan name, unable to update it");
            if( plan.status == null || plan.status.strip().length <= 0 )
                throw new SBException.GENERAL("Invalid plan status, unable to update it");

            message("Updating plan...");
            plan.save();
        }
    }
}
