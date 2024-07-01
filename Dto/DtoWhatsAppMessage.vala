using SinticBolivia.Classes;

namespace SinticBolivia.Modules.Subscriptions.Dto
{
    public class DtoWhatsAppMessage : SBSerializable
    {
        public  string  message {get;set;}
        public  string  customer {get;set;}
        public  string  phone {get;set;}

        public DtoWhatsAppMessage()
        {

        }
    }
}
