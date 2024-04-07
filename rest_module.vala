using SinticBolivia.Classes;
using SinticBolivia.Modules.Subscriptions.Controllers;

namespace SinticBolivia.Modules.Subscriptions
{
    public class SubscriptionsModule : Object, ISBRestModule
    {
        public string id {get; set construct;}
        public string name {get; set construct;}
        public string description {get; set construct;}
        public string version {get; set construct;}

        construct
        {
            this.id = "subscriptions";
            this.name = "Subscriptions module";
            this.description = "";
            this.version = "1.0.0";
        }
        public void load()
        {
            message("Module %s loaded\n".printf(this.name));
        }
        public void init(RestServer server)
        {
            this.set_handlers(server);
            message("Module %s initialized\n".printf(this.name));
        }
        protected void set_handlers(RestServer server)
        {
            server.add_handler_args("/api/subscriptions/types", typeof(TypesController));
            server.add_handler_args("/api/subscriptions/plans", typeof(PlansController));
            server.add_handler_args("/api/subscriptions", typeof(SubscriptionsController));
        }
    }
}
public Type sb_get_rest_module_type()
{
    return typeof(SinticBolivia.Modules.Subscriptions.SubscriptionsModule);
}
