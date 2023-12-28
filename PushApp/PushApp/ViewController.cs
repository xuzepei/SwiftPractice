using System.Reflection.Emit;
using AppKit;
using MailKit;
using ObjCRuntime;

namespace PushApp;

public class Tool
{
    public static bool isDebug = true;
}

public partial class ViewController : NSViewController {

    [Outlet]
    public NSButton pushBtn { get; set; }

    [Outlet]
    public NSTextField bundleIdTF { get; set; }

    [Outlet]
    public NSTextField deviceTokenTF { get; set; }

    [Outlet]
    public NSTextField titleTF { get; set; }

    [Outlet]
    public NSTextField typeTF { get; set; }

    [Outlet]
    public NSTextField fromTF { get; set; }

    [Outlet]
    public NSTextField dateTF { get; set; }

    [Outlet]
    public NSTextField imageUrlTF { get; set; }

    [Outlet]
    public NSTextField pageUrlTF { get; set; }

    [Outlet]
    public NSTextView textTV { get; set; }

    [Outlet]
    public NSTextField logTF { get; set; }

    private NSObject observer;


    string p12FilePath = "";

    protected ViewController (NativeHandle handle) : base (handle)
	{
		// This constructor is required if the view controller is loaded from a xib or a storyboard.
		// Do not put any initialization here, use ViewDidLoad instead.
	}

    protected override void Dispose(bool disposing)
    {
        // Release resources and unsubscribe from events here

        StopObserving();

        base.Dispose(disposing);
    }


    public override void ViewDidAppear()
    {
        base.ViewDidAppear();

        // Set the window name or title
        this.View.Window.Title = "Push Notificaton";

        // Disable resizing by setting the StyleMask
        this.View.Window.StyleMask &= ~NSWindowStyle.Resizable;
        this.View.Window.Center();

        logTF.Cell.LineBreakMode = NSLineBreakMode.TruncatingTail;
        logTF.Cell.Wraps = true;

        RestoreValue();
    }

    public void RestoreValue() {
        string bundle_id = NSUserDefaults.StandardUserDefaults.StringForKey("bundle_id");
        if (bundle_id != null && bundle_id.Length > 0) {
            bundleIdTF.StringValue = bundle_id;
        }

        string device_token = NSUserDefaults.StandardUserDefaults.StringForKey("device_token");
        if (device_token != null && device_token.Length > 0)
        {
            deviceTokenTF.StringValue = device_token;
        }

    }

    public override void ViewDidLoad ()
	{
		base.ViewDidLoad ();

        //View.Window.Title = "Push Notification";
        // Do any additional setup after loading the view.

        // Create and configure the button
        pushBtn.Title = "Push";

        // Handle button click event
        pushBtn.Activated += (sender, e) =>
        {
            // Implement your logic here when the button is clicked
            Console.WriteLine("Button Clicked!");

            logTF.StringValue = "";

            Push();
        };

        StartObserving();

    }

    public async Task<int> Push()
    {
        PushNew pushNew = new PushNew();

        var bundleId = "com.freqtek.pandaunion"; //应用BundleID
        if (bundleIdTF.StringValue.Length > 0) {
            bundleId = bundleIdTF.StringValue;

            NSUserDefaults.StandardUserDefaults.SetString(bundleId, "bundle_id");
            NSUserDefaults.StandardUserDefaults.Synchronize();
        }



        //var deviceToken = "8b24f4975921c60bd7e328364789513f64af9d3c5995a5e06dee6aeccce9d8cb"; // 接收通知的设备令牌
        var deviceToken = "9ef00afc01927bd6bf72a334583daed373f9cb0a1cf12055f95cf0de28729b0d";
        if (deviceTokenTF.StringValue.Length > 0) {

            deviceToken = deviceTokenTF.StringValue;

            NSUserDefaults.StandardUserDefaults.SetString(deviceToken, "device_token");
            NSUserDefaults.StandardUserDefaults.Synchronize();
        }

        if (Tool.isDebug) {
            p12FilePath = NSBundle.MainBundle.PathForResource("PandaUnion_Push_DEV", "p12");
        } else {
            p12FilePath = NSBundle.MainBundle.PathForResource("PandaUnion_Push_DIS", "p12");
            //var p12FilePath = "/Users/xuzepei/Desktop/Push-PandaUnion/PandaUnion_Push_DIS.p12"; //p12文件地址
        }

        Console.WriteLine("filepath-new: " + p12FilePath);

        var p12Password = "1111"; //p12文件密码


        var title = titleTF.StringValue;
        var type = int.Parse(typeTF.StringValue);
        var from = fromTF.StringValue;
        var dateString = dateTF.StringValue;
        var date = DateTime.Now;
        if (dateString.Length > 0) {
            bool success = DateTime.TryParse(dateString, out DateTime myDate);
            if (success)
            {
                // Conversion successful, use the 'date' variable here

                date = myDate;
            }
        }

        string dateStr = date.ToString("yyyy-MM-dd HH:mm:ss");


        var imageUrl = imageUrlTF.StringValue;
        var pageUrl = pageUrlTF.StringValue;
        var textBody = textTV.TextStorage.Value;
        if (textBody == null) {
            textBody = "";
        }

        await pushNew.Send(bundleId, deviceToken, p12FilePath, p12Password, title, type, from, dateStr, imageUrl, pageUrl, textBody);
        return 1;
    }

    public override NSObject RepresentedObject {
		get => base.RepresentedObject;
		set {
			base.RepresentedObject = value;

			// Update the view, if already loaded.
		}
	}


    public void StartObserving()
    {
        observer = NSNotificationCenter.DefaultCenter.AddObserver(new NSString("PushResult"), (notification) =>
        {
            NSString resultStr = new NSString("result");
            NSString messageStr = new NSString("message");

            if (notification.UserInfo != null && notification.UserInfo.ContainsKey(messageStr))
            {
                NSObject message = notification.UserInfo.ObjectForKey(messageStr);
                logTF.StringValue = message.ToString();
            }
        });
    }

    public void StopObserving()
    {
        if (observer != null)
        {
            NSNotificationCenter.DefaultCenter.RemoveObserver(observer);
            observer = null;
        }
    }
}

