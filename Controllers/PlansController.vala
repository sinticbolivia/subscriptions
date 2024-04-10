using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.Subscriptions.Entities;
using SinticBolivia.Modules.Subscriptions.Models;

namespace SinticBolivia.Modules.Subscriptions.Controllers
{
    public class PlansController : RestController
    {
        protected   PlansModel model;

        construct
        {
            this.model = new PlansModel();
        }
        public override void register_routes()
        {
            this.add_route("GET", "/api/subscriptions/plans/?$", this.read_all);
            this.add_route("GET", """/api/subscriptions/plans/(?P<id>\d+)/?$""", this.read);
            this.add_route("GET", """/api/subscriptions/plans/search/?$""", this.search);
            this.add_route("POST", "/api/subscriptions/plans/?$", this.create);
            this.add_route("PUT", """/api/subscriptions/plans/(?P<id>\d+)/?$""", this.update);
            this.add_route("DELETE", """/api/subscriptions/plans/(?P<id>\d+)/?$""", this.remove);
        }
        public RestResponse? create(SBCallbackArgs args)
        {
            try
            {
                var plan = this.toObject<Plan>();
                if( this.model != null )
                    this.model.create(plan);
                return new RestResponse(Soup.Status.CREATED, plan.to_json(), "application/json");
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
                long app_id = this.get_long("app_id", 0);
                int offset  = page > 1 ? ((page - 1) * limit) : 0;
                var query   = Entity.limit(limit, offset);
                if( app_id > 0 )
                    query.equals("application_id", app_id);
                query.order_by("creation_date", "DESC");
                var items = query.get<Plan>();
                /*
                stdout.printf("TOTAL ITEMS: %d\n", items.size);
                foreach(Plan item in items.items)
                {
                    stdout.printf("NAME: %s\n", item.name);
                }
                */
                return new RestResponse(
                    Soup.Status.OK,
                    items.to_json(),
                    "application/json"
                );
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
                var plan = this.model.read(id);
                plan.customers();
                return new RestResponse(Soup.Status.OK, plan.to_json(), "application/json");
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
                var oldPlan = this.model.read(id);
                if( oldPlan == null )
                    throw new SBException.GENERAL("The subscription plan does not exists, unable to update");
                var plan    = this.toObject<Plan>();
                oldPlan.name            = plan.name;
                oldPlan.description     = plan.description;
                oldPlan.status          = plan.status;
                oldPlan.product_id      = plan.product_id;
                oldPlan.application_id  = plan.application_id;
                oldPlan.price           = plan.price;
                oldPlan.data            = plan.data;
                this.model.update(oldPlan);
                return new RestResponse(Soup.Status.OK, oldPlan.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? remove(SBCallbackArgs args)
        {
            RestResponse res;
            try
            {
                long id = args.get_long("id");
                var plan = Entity.read<Plan>(id);
                if( plan == null )
                    throw new SBException.GENERAL("The plan does not exists");
                plan.delete();
                res = new RestResponse.json_object(Soup.Status.OK, null, "The subscription plan has been deleted");
            }
            catch(SBException e)
            {
                res = new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
            return res;
        }
        public RestResponse? search(SBCallbackArgs args)
        {
            RestResponse? res = null;
            try
            {
                string keyword  = this.get("keyword");
                int limit       = this.get_int("limit", 20);
                if( keyword.strip().length <= 0 )
                    throw new SBException.GENERAL("Invalid plan search keyword");
                var items = Entity.where("status", "=", Plan.STATUS_ENABLED)
                    .and()
                    .where_group((qb) =>
                    {
                        qb.ilike("name", "%%%s%%".printf(keyword))
                            //.or()
                            //ilike("")
                        ;
                    })
                    .order_by("name", "ASC")
                    .limit(limit)
                    .get<Plan>()
                ;
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch (SBException e)
            {
                res = new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
            return res;
        }
    }
}
