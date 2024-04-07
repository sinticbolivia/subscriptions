using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class Plan : Entity
    {
        public const string STATUS_ENABLED = "enabled";
        public const string STATUS_DISABLED = "disabled";

        public long         id { get; set; }
        public long         application_id {get; set;}
        public long         product_id {get;set;}
        public string?      name {get;set;}
        public string?      description {get; set;}
        public double       price {get; set;}
        public SBObject     data {get; set;}
        public string?      status {get;set;}

        construct
        {
            this._table = "subscriptions_plans";
            this._primary_key = "id";
        }
        public Plan()
        {

        }
        public SBHasMany<CustomerPlan> customers()
        {
            var has_many = this.has_many<CustomerPlan>("plan_id", "id");
            return has_many;
        }
        public SBCollection<CustomerPlan> get_customers()
        {
            return (SBCollection<CustomerPlan>)this.customers().get();
        }
    }
}
