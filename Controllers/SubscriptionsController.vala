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
        public override RestResponse dispatch(string route, string method, RestHandler handler)
		{
            //print("SubscriptionsController.dispatch\n");
			try
			{
				MatchInfo pathData;
                if( this.is_get() )
                {
                    if( new Regex("/api/subscriptions/?$").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.read_all();
                    if( new Regex("""/api/subscriptions/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.read(long.parse(pathData.fetch_named("id")));
                }
				else if( this.is_post() )
				{
					if( new Regex("""/api/subscriptions/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.create();
				}
                else if( this.is_put() )
                {
                    if( new Regex("""/api/subscriptions/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.update(long.parse(pathData.fetch_named("id")));
                }
                else if( this.is_delete() )
                {
                    if( new Regex("""/api/subscriptions/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.remove(long.parse(pathData.fetch_named("id")));
                }
			}
			catch(SBException e)
			{
				return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
			}
            catch(RegexError e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
			return new RestResponse(Soup.Status.BAD_REQUEST, "Invalid route");
		}
        public RestResponse? create()
        {
            try
            {
                var subscription = this.toObject<CustomerPlan>();
                subscription.save();
                return new RestResponse(Soup.Status.CREATED, subscription.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read_all()
        {
            try
            {
                int limit   = this.get_int("limit", 20);
                int page    = this.get_int("page", 1);
                int offset  = (page > 1) ? ((page-1) * limit) : 0;
                var items   = Entity.limit(limit, offset).get<CustomerPlan>();
                return new RestResponse(Soup.Status.OK, items.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? read(long id)
        {
            try
            {
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
        public RestResponse? update(long id)
        {
            try
            {
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
        public RestResponse? remove(long id)
        {
            try
            {
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
        public RestResponse? read_payments(long id )
        {
            try
            {
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
    }
}
