using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class Type : Entity
    {
        public const string STATUS_ENABLED  = "enabled";
        public const string STATUS_DISABLED = "disabled";

        public long         id { get; set; }
        public string?      name {get;set;}
        public string?      description {get; set;}
        public string?      status {get;set;}
        public double       discount {get; set;}
        public int          days {get;set;}
        public int          months {get;set;}

        construct
        {
            this._table = "subscriptions_types";
            this._primary_key = "id";
        }
        public Type()
        {

        }
    }
}
