using SinticBolivia;
using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.Subscriptions.Entities;
using SinticBolivia.Modules.Subscriptions.Models;

namespace SinticBolivia.Modules.Subscriptions.Controllers
{
    public class SubscriptionsController : RestController
    {
        protected   SubscriptionsModel model;

        construct
        {
            this.model = new SubscriptionsModel();
        }
        public override void register_routes()
        {
            this.add_route("GET", "/api/subscriptions/?$", this.read_all);
            this.add_route("GET", """/api/subscriptions/(?P<id>\d+)/?$""", this.read);
            this.add_route("GET", """/api/subscriptions/customers/(?P<id>\d+)/?$""", this.read_customer_subscriptions);
            this.add_route("POST", """/api/subscriptions/?$""", this.create);
            this.add_route("POST", """/api/subscriptions/(?P<id>\d+)/payments/?$""", this.register_payment);
            this.add_route("PUT", """/api/subscriptions/(?P<id>\d+)/?$""", this.update);
            this.add_route("DELETE", """/api/subscriptions/(?P<id>\d+)/?$""", this.remove);
            this.add_route("GET", "/api/subscriptions/close-to-expiration/?$", this.close_to_expiration);
            this.add_route("GET", "/api/subscriptions/estimated-month-income/?$", this.estimated_month_income);
            this.add_route("GET", "/api/subscriptions/month-income/?$", this.month_income);
            this.add_route("GET", "/api/subscriptions/check-expired/?$", this.check_expired);
            this.add_route("GET", "/api/subscriptions/expired/?$", this.expired);
            this.add_route("GET", """/api/subscriptions/archived/?$""", this.read_all_archived);
            this.add_route("GET", """/api/subscriptions/(?P<id>\d+)/archive/?$""", this.archive);
            this.add_route("GET", """/api/subscriptions/(?P<id>\d+)/dearchive/?$""", this.dearchive);
        }
        public RestResponse? create(SBCallbackArgs args)
        {
            try
            {
                var subscription = this.toObject<CustomerPlan>();
                //subscription.save();
                this.model.create(subscription);
                return new RestResponse(Soup.Status.CREATED, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_all(SBCallbackArgs args)
        {
            try
            {
                int limit   = this.get_int("limit", 20);
                int page    = this.get_int("page", 1);
                int offset  = (page > 1) ? ((page-1) * limit) : 0;
                long count  = Entity.count<CustomerPlan>();
                long total_pages = (long)Math.ceil(count/limit);

                var items   = Entity
                    .order_by("creation_date", "DESC")
                    .limit(limit, offset)
                    .get<CustomerPlan>()
                ;
                var res     = new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
                res.add_header("total-rows", count.to_string())
                    .add_header("total-pages", total_pages.to_string())
                ;
                return res;
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var subscription  = Entity.read<CustomerPlan>(id);
                if( subscription == null )
                    throw new SBException.GENERAL("The subscription does not exists");
                return new RestResponse(Soup.Status.OK, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? update(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var data = this.toObject<CustomerPlan>();
                if( data == null )
                    throw new SBException.GENERAL("Invalid data, unable to update subscription");
                data.id = id;
                var subscription = this.model.update(data);

                return new RestResponse(Soup.Status.OK, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? remove(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var subscription  = Entity.read<CustomerPlan>(id);
                if( subscription == null )
                    throw new SBException.GENERAL("The subscription does not exists");
                subscription.delete();

                return new RestResponse.json_object(Soup.Status.OK, null, "The subscription has been deleted");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_payments(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var subscription  = Entity.read<CustomerPlan>(id);
                if( subscription == null )
                    throw new SBException.GENERAL("The subscription does not exists");
                var items = subscription.get_payments();

                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_customer_subscriptions(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid customer identifier");
                int page = this.get_int("page", 1);
                int limit = this.get_int("limit", 20);

                var items = this.model.read_by_customer(id, page, limit);

                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? register_payment(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var payment = this.toObject<Payment>();
                if( payment == null )
                    throw new SBException.GENERAL("Invalid payment data");
                this.model.renew(payment);
                return new RestResponse(Soup.Status.OK, payment.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? close_to_expiration(SBCallbackArgs args)
        {
            try
            {
                int max_days    = this.get_int("max_days", 5);
                int page        = this.get_int("page", 1);
                int limit       = this.get_int("limit", 20);
                var items       = this.model.close_to_expiration(max_days, page, limit);
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? estimated_month_income(SBCallbackArgs args)
        {
            try
            {
                var date = new DateTime.now_local();
                double income = this.model.estimated_month_income(date.get_year(), date.get_month());
                return new RestResponse(Soup.Status.OK, "{\"income\": %f}".printf(income), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? month_income(SBCallbackArgs args)
        {
            try
            {
                var date = new DateTime.now_local();
                double income = this.model.month_income(date.get_year(), date.get_month());
                return new RestResponse(Soup.Status.OK, "{\"income\": %f}".printf(income), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        /**
         * Controller method for cron job. The controller method checks de subscription close to expire
         * and sends a customer whatsapp message reminder
         *
         **/
        public RestResponse? check_close_to_expire(SBCallbackArgs args)
        {
            try
            {
                this.model.check_close_to_expire();
                return new RestResponse(Soup.Status.OK, "{}", "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? check_expired(SBCallbackArgs args)
        {
            try
            {
                this.model.check_expired();
                return new RestResponse(Soup.Status.OK, "{}", "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? expired(SBCallbackArgs args)
        {
            try
            {
                var items = Entity.where("status", "=", CustomerPlan.STATUS_EXPIRED).get<CustomerPlan>();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_all_archived(SBCallbackArgs args)
        {
            try
            {
                int limit   = this.get_int("limit", 20);
                int page    = this.get_int("page", 1);
                int offset  = (page > 1) ? ((page-1) * limit) : 0;
                long count  = Entity.count<CustomerPlan>();
                long total_pages = (long)Math.ceil(count/limit);

                var items   = Entity
                    .where("archived", "=", 1)
                    .order_by("creation_date", "DESC")
                    .limit(limit, offset)
                    .get<CustomerPlan>()
                ;
                var res     = new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
                res.add_header("total-rows", count.to_string())
                    .add_header("total-pages", total_pages.to_string())
                ;
                return res;
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? archive(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var subscription  = Entity.read<CustomerPlan>(id);
                if( subscription == null )
                    throw new SBException.GENERAL("The subscription does not exists");
                subscription.archived = 1;
                subscription.save();

                return new RestResponse(Soup.Status.OK, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? dearchive(SBCallbackArgs args)
        {
            try
            {
                long id = args.get_long("id");
                if( id <= 0 )
                    throw new SBException.GENERAL("Invalid subscription identifier");
                var subscription  = Entity.read<CustomerPlan>(id);
                if( subscription == null )
                    throw new SBException.GENERAL("The subscription does not exists");
                subscription.archived = 0;
                subscription.save();

                return new RestResponse(Soup.Status.OK, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
    }
}
