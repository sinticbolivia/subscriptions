using SinticBolivia.Database;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class Payment : Entity
    {
        public  const   string PAYMENT_TYPE_INITIAL = "initial";
        public  const   string PAYMENT_TYPE_RENEW   = "renew";

        public  long    id {get;set;}
        public  long    customer_plan_id {get;set;}
        public  long    user_id {get;set;}
        public  string  payment_method {get;set;}
        public  double  amount_paid {get;set;}
        public  string  payment_type {get;set;}

        construct
        {
            this._table = "subscriptions_payments";
            this._primary_key = "id";
        }
        public SBBelongsTo<CustomerPlan> subscription()
        {
            return this.belongs_to<CustomerPlan>("customer_plan_id", "id");
        }
        public CustomerPlan get_subscription()
        {
            return this.subscription().get();
        }
    }
}
