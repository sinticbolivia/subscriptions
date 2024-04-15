using GLib;
using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Classes;
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
        public CustomerPlan update(CustomerPlan data) throws SBException
        {
            var subscription  = Entity.read<CustomerPlan>(data.id);
            if( subscription == null )
                throw new SBException.GENERAL("The subscription does not exists");

            subscription.plan_id        = data.plan_id;
            subscription.customer_id    = data.customer_id;
            subscription.user_id        = data.user_id;
            subscription.type_id        = data.type_id;
            subscription.status         = data.status;
            subscription.init_date      = data.init_date;
            subscription.end_date       = data.end_date;
            subscription.notes          = data.notes;
            subscription.save();

            return subscription;
        }
        public void do_payment(Payment payment) throws SBException
        {
            if( payment.customer_plan_id <= 0 )
                throw new SBException.GENERAL("Invalid user plan identifier");
            if( payment.payment_method.strip().length <= 0 )
                throw new SBException.GENERAL("Invalid payment method");
            payment.save();
        }
        public SBCollection<CustomerPlan> close_to_expiration(int max_days, int page = 1, int limit = 20)
        {
            var init_date = new SBDateTime();
            var end_date = new SBDateTime();
            end_date.get_datetime().add_days(max_days);

            var builder = Entity.where("status", "=", CustomerPlan.STATUS_ENABLED)
                    .and()
                    .where_group((qb) =>
                    {
                        qb
                            .greater_than_or_equals("DATE(end_date)", init_date.format("%Y-%m-%d"))
                            .and()
                            .less_than_or_equals("DATE(end_date)", end_date.format("%Y-%m-%d"))
                        ;
                    })
                .order_by("end_date", "ASC")
                .limit(limit)
            ;
            var items = builder.get<CustomerPlan>();
            return items;
        }
        public void renew(Payment payment) throws SBException
        {
            if( payment.customer_plan_id <= 0 )
                throw new SBException.GENERAL("The payment does not has a customer plan identifier, unable to renew");
            if( payment.payment_method == null || payment.payment_method.strip().length <= 0 )
                throw new SBException.GENERAL("The payment does not has a payment method, unable to renew");
            var subscription = payment.get_subscription();
            if( subscription == null )
                throw new SBException.GENERAL("The subscription for this payment does not exists, unable to renew");
            var type = subscription.get_stype();
            if( type == null )
                throw new SBException.GENERAL("The subscription has no type, unable to renew");
            payment.payment_type = Payment.PAYMENT_TYPE_RENEW;
            payment.save();
            //var plan = subscription.get_plan();
            print(type.dump());
            subscription.init_date  = new SBDateTime.from_datetime(subscription.end_date.get_datetime()/*.format("%Y-%m-%d %H:%M:%S")*/);
            subscription.end_date   = new SBDateTime.from_datetime(
                subscription.init_date.get_datetime().add_days(type.months > 0 ? (type.months * 30) : type.days)
            );
            subscription.status     = CustomerPlan.STATUS_ENABLED;
            print(subscription.dump());
            subscription.save();
        }
        public SBCollection<CustomerPlan> read_by_customer(long id, int page = 1, int limit = 20)
        {
            int offset = (page <= 1) ? 0 : ((page - 1) * limit);
            var builder = Entity.where("customer_id", "=", id)
                .order_by("creation_date", "DESC")
                .limit(limit, offset)
            ;
            return builder.get<CustomerPlan>();
        }
        public double estimated_month_income(int year, int month)
        {
            var date = new DateTime.local(year, month, 1, 0, 0, 0);
            var builder = new SBDBQuery();
            builder.select("SUM(p.price) AS total")
                .from("subscriptions_plans p")
                .join("subscriptions_customer_plans cp", "cp.plan_id", "p.id")
                .where("p.status", "=", CustomerPlan.STATUS_ENABLED)
                .and()
                .where_group((qb) =>
                {
                        qb.greater_than_or_equals("DATE(end_date)", date.format("%Y-%m-%d"))
                            .and()
                            .less_than("DATE(end_date)", date.add_months(1).format("%Y-%m-%d"))
                        ;
                })
                //.group_by("")
            ;
            print(builder.sql());
            //return 0;
            var db_row = builder.first<SBDBRow>();
            return db_row.GetDouble("total");
        }
        public void check_expired()
        {
            var date = new DateTime.now_local();
            var builder = new SBDBQuery();
            builder.select("id")
                .from("subscriptions_customer_plans")
                .where("status", "=", CustomerPlan.STATUS_ENABLED)
                .and()
                .less_than("DATE(end_date)", date.format("%Y-%m-%d"))
                .order_by("end_date", "ASC")
            ;
            var subscriptions = builder.get<CustomerPlan>();
            foreach(var subscription in subscriptions.items)
            {
                subscription.status = CustomerPlan.STATUS_EXPIRED;
                subscription.save();
            }
        }
    }
}
