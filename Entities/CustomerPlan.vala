using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class CustomerPlan : Entity
    {
        public  const   string STATUS_ENABLED = "enabled";
        public  const   string STATUS_DISABLED = "disabled";
        public  const   string STATUS_CANCELLED = "cancelled";

        public  long        id {get;set;}
        public  long        plan_id {get;set;}
        public  long        customer_id {get;set;}
        public  long        type_id {get;set;}
        public  long        user_id {get;set;}
        public  string      status {get;set;}
        public  SBDateTime  init_date {get;set;}
        public  SBDateTime  end_date {get;set;}
        public  string?     notes {get; set;}

        construct
        {
            this._table         = "subscriptions_customer_plans";
            this._primary_key   = "id";
        }
        public CustomerPlan()
        {

        }
        public SBHasOne<Type> stype()
        {
            return this.has_one<Type>("id", "type_id");
        }
        public SinticBolivia.Modules.Subscriptions.Entities.Type get_stype()
        {
            return this.stype().get();
        }
        public SBHasOne<Plan> plan()
        {
            var ho = this.has_one<Plan>("id", "plan_id");
            return ho;
        }
        public Plan get_plan()
        {
            var plan = this.plan().get();
            return plan;
        }
        public SBHasMany<Payment> payments()
        {
            return this.has_many<Payment>("customer_plan_id", "id");
        }
        public SBCollection<Payment> get_payments()
        {
            return this.payments().get();
        }
        public override void after_build_json_object(Json.Object obj)
        {
            var plan = this.get_plan();
            var type = this.get_stype();
            obj.set_object_member("plan", plan != null ? plan.to_json_object() : null);
            obj.set_object_member("type", type != null ? type.to_json_object() : null);
        }
    }
}
