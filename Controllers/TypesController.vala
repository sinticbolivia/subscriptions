using SinticBolivia.Classes;
using SinticBolivia.Database;
using SinticBolivia.Modules.Subscriptions.Entities;
using SinticBolivia.Modules.Subscriptions.Models;

namespace SinticBolivia.Modules.Subscriptions.Controllers
{
    public class TypesController : RestController
    {
        public override RestResponse dispatch(string route, string method, RestHandler handler)
        {
            try
			{
				MatchInfo pathData;
                if( this.is_get() )
                {
                    if( new Regex("/api/subscriptions/types?$").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.read_all();
                    if( new Regex("""/api/subscriptions/types/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.read(long.parse(pathData.fetch_named("id")));
                    if( new Regex("""/api/subscriptions/types/search/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.search();
                }
				else if( this.is_post() )
				{
					if( new Regex("/api/subscriptions/types/?$").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.create();
				}
                else if( this.is_put() )
                {
                    if( new Regex("""/api/subscriptions/types/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
						return this.update(long.parse(pathData.fetch_named("id")));
                }
                else if( this.is_delete() )
                {
                    if( new Regex("""/api/subscriptions/types/(?P<id>\d+)/?$""").match(route, RegexMatchFlags.ANCHORED, out pathData) )
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
                var type = this.toObject<SinticBolivia.Modules.Subscriptions.Entities.Type>();
                if( type.name.strip().length <= 0 )
                    throw new SBException.GENERAL("Invalid subscription type name, unable to create it");
                type.status = SinticBolivia.Modules.Subscriptions.Entities.Type.STATUS_ENABLED;
                type.save();
                return new RestResponse(Soup.Status.CREATED, type.to_json(), "application/json");
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
                int offset  = page > 1 ? ((page - 1) * limit) : 0;
                var query   = Entity
                    .limit(limit, offset)
                    .order_by("creation_date", "DESC")
                ;
                var items = query.get<SinticBolivia.Modules.Subscriptions.Entities.Type>();

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
        public RestResponse? read(long id)
        {
            try
            {
                var type = Entity.read<SinticBolivia.Modules.Subscriptions.Entities.Type>(id);
                return new RestResponse(Soup.Status.OK, type.to_json(), "application/json");
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
                var oldType = Entity.read<SinticBolivia.Modules.Subscriptions.Entities.Type>(id);
                if( oldType == null )
                    throw new SBException.GENERAL("The subscription type does not exists, unable to update");
                var type    = this.toObject<SinticBolivia.Modules.Subscriptions.Entities.Type>();
                oldType.name            = type.name;
                oldType.description     = type.description;
                oldType.status          = type.status;
                oldType.discount        = type.discount;
                oldType.days            = type.days;
                oldType.save();

                return new RestResponse(Soup.Status.OK, oldType.to_json(), "application/json");
            }
            catch(SBException e)
            {
                return new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
        }
        public RestResponse? remove(long id)
        {
            RestResponse res;
            try
            {
                var type = Entity.read<SinticBolivia.Modules.Subscriptions.Entities.Type>(id);
                if( type == null )
                    throw new SBException.GENERAL("The plan does not exists");
                type.delete();
                res = new RestResponse.json_object(Soup.Status.OK, null, "The subscription plan has been deleted");
            }
            catch(SBException e)
            {
                res = new RestResponse(Soup.Status.INTERNAL_SERVER_ERROR, e.message);
            }
            return res;
        }
        public RestResponse? search()
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
                    .get<SinticBolivia.Modules.Subscriptions.Entities.Type>()
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
