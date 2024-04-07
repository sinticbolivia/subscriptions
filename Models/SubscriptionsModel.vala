using GLib;
using SinticBolivia;
using SinticBolivia.Modules.Subscriptions.Entities;

namespace SinticBolivia.Modules.Subscriptions.Models
{
    public class SubscriptionsModel
    {
        public SubscriptionsModel()
        {

        }
        public void create(CustomerPlan plan) throws SBException
        {
            if( plan.plan_id <= 0 )
                throw new SBException.GENERAL("Invalid plan identifier");
            if( plan.customer_id <= 0 )
                throw new SBException.GENERAL("Invalid plan customer identifier");
            if( plan.user_id <= 0 )
                throw new SBException.GENERAL("Invalid plan user identifier");
            
            plan.status = UserPlan.STATUS_ENABLED;
            plan.save();
        }
        public void do_payment(Payment payment) throws SBException
        {
            if( payment.user_plan_id <= 0 )
                throw new SBException.GENERAL("Invalid user plan identifier");
            if( payment.payment_method.strip().length <= 0 )
                throw new SBException.GENERAL("Invalid payment method");
            payment.save();
        }
    }
}
