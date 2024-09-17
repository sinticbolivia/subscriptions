using Gee;
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
            string endpoint = (string)SBFactory.config.GetValue("service_waapi_message");
            string token = (string)SBFactory.config.GetValue("waapi_token");

            var req = new SBRequest();
            req.headers.set("Content-Type", "application/json");
            req.headers.set("Authorization", token);

            var res = req.post(endpoint, message.to_json());
            if( !res.ok )
            {
                debug(res.body);
                throw new SBException.GENERAL("Error sending whatsapp message");
            }
        }
        public void send_batch_message(ArrayList<DtoWhatsAppMessage> items)
        {
            string endpoint = (string)SBFactory.config.GetValue("service_waapi_batch_message");
            string token = (string)SBFactory.config.GetValue("waapi_token");
            string json = "[";
            foreach(var message in items)
            {
                json += message.to_json() + ",";
            }
            json = json.substring(-1) + "]";
            var req = new SBRequest();
            req.headers.set("Content-Type", "application/json");
            req.headers.set("Authorization", token);
            var res = req.post(endpoint, json);
            if( !res.ok )
            {
                debug(res.body);
                throw new SBException.GENERAL("Error sending whatsapp message");
            }
        }
    }
}
