using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Security;
using System.Net.Sockets;
using System.Reflection.Metadata;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using PushApp;
using ThreadNetwork;

public class PushNew
{
    public async Task Send(string bundleId, string deviceToken, string p12FilePath, string p12Password, string title, int type, string from, string date, string imageUrl, string pageUrl, string textBody)
    {
        var apnsPushType = "alert";
        Guid uniqueId = Guid.NewGuid();
        string messageId = uniqueId.ToString();

        //整个消息体需要小于4K
        var payload = new
        {
            aps = new {
                alert = title,
                badge = 1,
                sound = "default"
            },

            data = new {
                id = messageId,
                type = type,
                title = title,
                textBody = textBody,
                imageUrl = imageUrl,
                pageUrl = pageUrl,
                createDate = date,
                from = from,
                replyNum = 99
            }
        };

        var serializedPayload = Newtonsoft.Json.JsonConvert.SerializeObject(payload);

        using (var httpClientHandler = new HttpClientHandler())
        {
            var certificates = new X509Certificate2Collection();

            X509Certificate2 certificate = new X509Certificate2(p12FilePath, p12Password);
            certificates.Add(certificate);

            httpClientHandler.ClientCertificates.Add(certificate);

            using (var httpClient = new HttpClient(httpClientHandler))
            {
                //需要用Http2.0协议
                httpClient.DefaultRequestVersion = HttpVersion.Version20;
                httpClient.DefaultVersionPolicy = HttpVersionPolicy.RequestVersionOrLower;


                string url = "";
                if (Tool.isDebug)
                {
                    //测试URL
                    url = "https://api.sandbox.push.apple.com/3/device/" + deviceToken;
                }
                else
                {
                    //发布用URL
                    url = "https://api.push.apple.com/3/device/" + deviceToken;
                }

                httpClient.DefaultRequestHeaders.Add("apns-topic", bundleId);
                httpClient.DefaultRequestHeaders.Add("apns-push-type", apnsPushType);

                var jsonContent = new StringContent(serializedPayload, Encoding.UTF8, "application/json");
                Console.WriteLine(jsonContent);
                var errorMessage = "";
                var result = 0;
                try
                {
                    var response = await httpClient.PostAsync(url, jsonContent);
                    
                    
                    if (response.IsSuccessStatusCode)
                    {
                        errorMessage = "推送通知发送成功！";
                        Console.WriteLine(errorMessage);
                        result = 1;
                        
                    }
                    else
                    {
                        errorMessage = $"推送通知发送失败：{response.StatusCode}";
                        Console.WriteLine(errorMessage);
                    }
                }
                catch (Exception ex)
                {
                    errorMessage = $"推送通知发送异常：{ex.Message}";
                    Console.WriteLine(errorMessage);
                }

                NSMutableDictionary userInfo = new NSMutableDictionary();
                userInfo.Add(new NSString("result"), new NSNumber(result));
                userInfo.Add(new NSString("message"), new NSString(errorMessage));

                NSNotificationCenter.DefaultCenter.PostNotificationName("PushResult", null, userInfo);

            }
        }
    }
}

