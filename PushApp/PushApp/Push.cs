using System;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Net.Sockets;
using System.Security.Authentication;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
//using Microsoft.AspNetCore.Mvc.RazorPages;

namespace PushDemo
{
    public class Push
    {
        private SslStream _sslStream = null;
        private string deviceToken = "60ceef8431532f4dfc28d6727b603761de95173cbd9c6975d4eb1166de8046f6"; // 接收通知的设备令牌
        private string appBundleId = "com.freqty.pandacloud.test2";
        private string certificatePath = "./pandacloud_push.p12"; // my certificate path
        private string password = "1111";



        public Push()
        {
        }

        ~Push()
        {
            Console.WriteLine("####000000");
        }

        public bool SendPushNotification()
        {
            var payload = new
            {
                aps = new
                {
                    alert = "A Hello from C#",
                    sound = "default"
                }


            };


            //string jsonPayload = Newtonsoft.Json.JsonConvert.SerializeObject(payload);

            String jsonPayload = "{\"aps\": {\"alert\": \"New message from John\",\"badge\": 1,\"sound\": \"default\"},\"data\": {\"id\": \"12345\",\"message\":\"v33333\",\"date\":\"2023-06-26 18:00:00\"}}";

            byte[] deviceTokenBytes = HexStringToByteArray(deviceToken);
            byte[] jsonPayloadBytes = Encoding.UTF8.GetBytes(jsonPayload);

            //MemoryStream memoryStream = new MemoryStream();
            //memoryStream.WriteByte(0);
            //memoryStream.WriteByte(0);
            //memoryStream.WriteByte(32);
            //memoryStream.Write(deviceTokenBytes, 0, deviceTokenBytes.Length);
            //memoryStream.WriteByte(0);
            //memoryStream.WriteByte((byte)jsonPayloadBytes.Length);
            //memoryStream.Write(jsonPayloadBytes, 0, jsonPayloadBytes.Length);

            //byte[] notificationBytes = memoryStream.ToArray();

            String host = "api.development.push.apple.com"; // 开发环境
            //string host = "api.push.apple.com"; // 生产环境
            int port = 443;


            X509Certificate2 clientCertificate = new X509Certificate2(System.IO.File.ReadAllBytes(certificatePath), password, X509KeyStorageFlags.MachineKeySet);
            X509Certificate2Collection certificatesCollection = new X509Certificate2Collection(clientCertificate);
            Console.WriteLine("####111111");

            TcpClient client = new TcpClient(host, port);
            _sslStream = new SslStream(client.GetStream(), false, new RemoteCertificateValidationCallback(ValidateServerCertificate), null);

            
                Console.WriteLine("####22222");
                //sslStream.AuthenticateAsClient(host);

                try
                {

                    Console.WriteLine("####33333");
                    _sslStream.AuthenticateAsClient(host, certificatesCollection, SslProtocols.Tls, true);

                    //using (BinaryWriter writer = new BinaryWriter(_sslStream))
                    //{
                    //    byte[] notificationLengthBytes = BitConverter.GetBytes((int)notificationBytes.Length);
                    //    if (BitConverter.IsLittleEndian)
                    //    {
                    //        Array.Reverse(notificationLengthBytes);
                    //    }

                    //    writer.Write((byte)0);
                    //    writer.Write((byte)0);
                    //    writer.Write((byte)32);
                    //    writer.Write(serverKey.Length);
                    //    writer.Write(Encoding.UTF8.GetBytes(serverKey));
                    //    writer.Write((byte)0);
                    //    writer.Write((byte)notificationLengthBytes.Length);
                    //    writer.Write(notificationLengthBytes);
                    //    writer.Write(notificationBytes);
                    //    writer.Flush();

                    //    Console.WriteLine("333!");
                    //}


                    Console.WriteLine("####444444");
                //Send(jsonPayload);

                //MemoryStream memoryStream = new MemoryStream();
                //BinaryWriter writer = new BinaryWriter(memoryStream);
                //writer.Write((byte)0);
                //writer.Write((byte)0);
                //writer.Write((byte)32);

                //writer.Write(HexStringToByteArray(deviceToken.ToUpper()));

                //writer.Write((byte)0);
                //writer.Write((byte)jsonPayload.Length);
                //byte[] b1 = System.Text.Encoding.UTF8.GetBytes(jsonPayload);
                //writer.Write(b1);
                //writer.Flush();
                //byte[] array = memoryStream.ToArray();
                //_sslStream.Write(array);
                //_sslStream.Flush();

                MemoryStream memoryStream = new MemoryStream();
                BinaryWriter writer = new BinaryWriter(memoryStream);

                //The command
                writer.Write((byte)0);
                //The first byte of the deviceId length (big-endian first byte)
                writer.Write((byte)0);
                //The deviceId length (big-endian second byte)
                writer.Write((byte)32);
                writer.Write(ToByteArray(deviceToken.ToUpper()));
                byte[] payloadBytes = System.Text.Encoding.UTF8.GetBytes(jsonPayload);
                // First byte of payload length; (big-endian first byte)
                writer.Write(
                    Convert.ToByte(
                        Math.Floor(
                            (double)payloadBytes.Count() / 256
                        )
                    )
                );
                //payload length (big-endian second byte)
                writer.Write((byte)jsonPayload.Length);
                writer.Write(payloadBytes);
                writer.Flush();

                byte[] array = memoryStream.ToArray();
                _sslStream.Write(array);
                _sslStream.Flush();

                string result = ReadMessage(_sslStream);
                Console.WriteLine("####server said: " + result);

                client.Close();



                Console.WriteLine("###66666");

            }
                catch (Exception e)
                {
                    Console.WriteLine("####5555");
                    Console.WriteLine("####Exception Message: {0} ", e.Message);
                    _sslStream.Close();
                }


            return true;
        }

        static byte[] HexStringToByteArray(string hexString)
        {
            if (hexString.Length % 2 != 0)
                throw new ArgumentException("The binary key cannot have an odd number of digits");

            byte[] HexAsBytes = new byte[hexString.Length / 2];
            for (int index = 0; index < HexAsBytes.Length; index++)
            {
                string byteValue = hexString.Substring(index * 2, 2);
                HexAsBytes[index] = byte.Parse(byteValue, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
            }

            return HexAsBytes;
        }

        public void Send(string payloadStr)
        {
            MemoryStream memoryStream = new MemoryStream();
            BinaryWriter writer = new BinaryWriter(memoryStream);

            writer.Write((byte)0); //The command
            writer.Write((byte)0); //The first byte of deviceId length (Big-endian first byte)
            writer.Write((byte)32); //The deviceId length (Big-endian second type)

            byte[] deviceTokenBytes = DataWithDeviceToken(deviceToken.ToUpper());
            writer.Write(deviceTokenBytes);

            writer.Write((byte)0); //The first byte of payload length (Big-endian first byte)
            writer.Write((byte)payloadStr.Length); //payload length (Big-endian second byte)

            byte[] bytes = Encoding.UTF8.GetBytes(payloadStr);
            writer.Write(bytes);
            writer.Flush();

            _sslStream.Write(memoryStream.ToArray());
            _sslStream.Flush();

            //Thread.Sleep(3000);
            Console.WriteLine("####6666666");
            string result = ReadMessage(_sslStream);
            Console.WriteLine("####server said: " + result);

            _sslStream.Close();
        }


        public static byte[] ToByteArray(string value)
        {
            byte[] bytes = null;
            if (String.IsNullOrEmpty(value))
                bytes = null;
            else
            {
                int string_length = value.Length;
                int character_index = (value.StartsWith("0x", StringComparison.Ordinal)) ? 2 : 0; // If Does the string define leading HEX indicator '0x'. Adjust starting index accordingly.
                int number_of_characters = string_length - character_index;

                bool add_leading_zero = false;
                if (0 != (number_of_characters % 2))
                {
                    add_leading_zero = true;

                    number_of_characters += 1;  // Leading '0' has been striped from the string presentation.
                }

                bytes = new byte[number_of_characters / 2]; // Initialize our byte array to hold the converted string.

                int write_index = 0;
                if (add_leading_zero)
                {
                    bytes[write_index++] = FromCharacterToByte(value[character_index], character_index);
                    character_index += 1;
                }

                for (int read_index = character_index; read_index < value.Length; read_index += 2)
                {
                    byte upper = FromCharacterToByte(value[read_index], read_index, 4);
                    byte lower = FromCharacterToByte(value[read_index + 1], read_index + 1);

                    bytes[write_index++] = (byte)(upper | lower);
                }
            }

            return bytes;
        }

        private static byte FromCharacterToByte(char character, int index, int shift = 0)
        {
            byte value = (byte)character;
            if (((0x40 < value) && (0x47 > value)) || ((0x60 < value) && (0x67 > value)))
            {
                if (0x40 == (0x40 & value))
                {
                    if (0x20 == (0x20 & value))
                        value = (byte)(((value + 0xA) - 0x61) << shift);
                    else
                        value = (byte)(((value + 0xA) - 0x41) << shift);
                }
            }
            else if ((0x29 < value) && (0x40 > value))
                value = (byte)((value - 0x30) << shift);
            else
                throw new InvalidOperationException(String.Format("Character '{0}' at index '{1}' is not valid alphanumeric character.", character, index));

            return value;
        }

        private byte[] HexString2Bytes(String hexString)
        {
            //check for null
            if (hexString == null) return null;
            //get length
            int len = hexString.Length;
            if (len % 2 == 1) return null;
            int len_half = len / 2;
            //create a byte array
            byte[] bs = new byte[len_half];
            try
            {
                //convert the hexstring to bytes
                for (int i = 0; i != len_half; i++)
                {
                    bs[i] = (byte)Int32.Parse(hexString.Substring(i * 2, 2), System.Globalization.NumberStyles.HexNumber);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            //return the byte array
            return bs;
        }


        bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            if (sslPolicyErrors == SslPolicyErrors.None)
            {
                Console.WriteLine("Specified Certificate is accepted.");
                return true;
            }
            Console.WriteLine("Certificate error : {0} ", sslPolicyErrors);
            return false;
        }

        string ReadMessage(SslStream sslStream)
        {

            byte[] buffer = new byte[2048];
            StringBuilder messages = new StringBuilder();
            int bytes = -1;
            do
            {
                bytes = sslStream.Read(buffer, 0, buffer.Length);

                Decoder decoder = Encoding.UTF8.GetDecoder();
                char[] chars = new char[decoder.GetCharCount(buffer, 0, bytes)];
                decoder.GetChars(buffer, 0, bytes, chars, 0);
                messages.Append(chars);

                if (messages.ToString().IndexOf("<EOF>") != -1)
                {
                    break;
                }
            } while (bytes != 0);

            return messages.ToString();
        }

        byte[] DataWithDeviceToken(string deviceToken)
        {
            string normal = FilterHex(deviceToken);
            string trunk = normal.Length >= 64 ? normal.Substring(0, 64) : "";

            UTF8Encoding utf8 = new UTF8Encoding();
            byte[] utf8bytes = utf8.GetBytes(trunk);
            char[] chars = utf8.GetString(utf8bytes).ToCharArray();

            byte[] bytes = new byte[chars.Length / 2];

            string buffer;
            for (int i = 0; i < chars.Length / 2; i++)
            {
                buffer = Convert.ToString(chars[i * 2]) + Convert.ToString(chars[i * 2 + 1]);
                long b = Convert.ToInt64(buffer.ToString(), 16);
                bytes[i] = Convert.ToByte(b);
            }
            return bytes;
        }

        string FilterHex(string originalStr)
        {
            char[] lowerStr = originalStr.ToLower().ToCharArray();
            StringBuilder result = new StringBuilder();
            for (int i = 0; i < lowerStr.Length; i++)
            {
                if ((lowerStr[i] >= 'a' && lowerStr[i] <= 'f') || (lowerStr[i] >= '0' && lowerStr[i] <= '9'))
                {
                    result.Append(lowerStr[i]);
                }
            }
            return result.ToString();
        }
    }
}

