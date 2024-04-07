using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class UserPlan : Entity
    {
        public  const   string STATUS_ENABLED = "enabled";
        public  const   string STATUS_DISABLED = "disabled";
        public  const   string STATUS_CANCELLED = "cancelled";

        public  long        id {get;set;}
        public  long        plan_id {get;set;}
        public  long        customer_id {get;set;}
        public  long        user_id {get;set;}
        public  string      status {get;set;}
        public  SBDateTime  init_date {get;set;}
        public  SBDateTime  end_date {get;set;}

        construct
        {
            this._table = "subscriptions_user_plans";
            this._primary_key = "id";
        }
        public UserPlan()
        {

        }
    }
}
