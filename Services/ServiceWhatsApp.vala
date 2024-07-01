using SinticBolivia;
using SinticBolivia.Classes;
using SinticBolivia.Modules.Subscriptions.Dto;

namespace SinticBolivia.Modules.Subscriptions.Services
{
    public class ServiceWhatsApp
    {
        public ServiceWhatsApp()
        {

        }
        public void send_message(DtoWhatsAppMessage message) throws SBException
        {
            string endpoint = (string)SBFactory.config.GetValue("service_whatsapp");
            var req = new SBRequest();
            req.headers.set("Content-Type", "application/json");
            //req.headers.set("Authorization", "Bearer %s".printf(this.jwt));
            var res = req.post(endpoint, message.to_json());
            if( !res.ok )
            {
                debug(res.body);
                throw new SBException.GENERAL("Error sending whatsapp message");
            }
        }
        
    }
}
