using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class Tag : Entity
    {
        public      long id {get;set;}
        public      string  name {get;set;}

        construct
        {
            this._table = "tags";
            this._primary_key = "id";
        }

        public Tag()
        {

        }
    }
}
