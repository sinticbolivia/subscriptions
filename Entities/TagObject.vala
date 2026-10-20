using GLib;
using Gee;
using SinticBolivia;
using SinticBolivia.Database;
using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Entities
{
    public class TagObject : Entity
    {
        public      long tag_id {get;set;}
        public      long object_id {get;set;}
        public      string  object_type {get;set;}

        construct
        {
            this._table = "tag2object";
            this._primary_key = "tag_id|object_id|object_type";
            this._use_timestamp_columns = false;
        }

        public TagObject()
        {

        }
    }
}
