//
//  ViewController.m
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SignInViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "HttpRequest.h"
#import "MBProgressHUD.h"
#import "Tool.h"
//#import "SignalR.h"
#import "Demo-Swift.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


#define USERNAME @"freqtyc_taojiangxia"
#define PASSWORD @"123456"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic, strong)MBProgressHUD* hud;
@property(nonatomic, assign)BOOL isRequesting;
@property(nonatomic, assign)int tryTimes;
@property(nonatomic, assign)BOOL isUpdatingImage;
//@property(nonatomic, strong)SRHubConnection *connect;
@property(nonatomic, strong)AVPlayer* player;
@property(nonatomic, strong)AVPlayerLayer* playerLayer;


@end

@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //self.connect = nil;
}

- (BOOL)isSignIn {
    
    NSDictionary *userInfo = [NSUserDefaults.standardUserDefaults objectForKey:@"access_token"];
    if(userInfo && [userInfo isKindOfClass:[NSDictionary class]])
    {
        return YES;
    }
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInNotification:) name:@"SignInNotification" object:nil];
    
    self.title = @"Image Processor";
    
    if(NO == [self isSignIn])
    {
        [self clickedLeftBarItem: nil];
    }
    
    [self updateNavigationBarItems];
    
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor = [UIColor.systemGrayColor CGColor];
    
    //[self initPlayer];
    
}

- (void)updateNavigationBarItems
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: [self isSignIn] ? @"signout":@"signin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarItem:)];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(clickedRightBarItem:)];

    refreshItem.tintColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItem = refreshItem;
}

- (void)signInNotification:(NSNotification*)noti
{
    [self updateNavigationBarItems];
}

- (void)clickedLeftBarItem:(id)sender {
    
    if(self.isRequesting)
        return;
    
    if(self.isUpdatingImage)
        return;
    
    if([self isSignIn])
    {
        [NSUserDefaults.standardUserDefaults removeObjectForKey:@"access_token"];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    
    [self performSegueWithIdentifier:@"to_signin_vc" sender:nil];
}

- (void)clickedRightBarItem:(id)sender {
    
    if([self isSignIn])
    {
        NSString* urlString = @"http://4134d577z4.zicp.vip:51930/connect/token";
        
        NSDictionary* token = @{@"username":USERNAME, @"password":PASSWORD};
        
        [HttpRequest.sharedInstance post:urlString token:token withCompletionBlock:^(NSDictionary *dict) {
            
            if(dict && [dict isKindOfClass:[NSDictionary class]])
            {
                [NSUserDefaults.standardUserDefaults setObject:dict forKey:@"access_token"];
                [NSUserDefaults.standardUserDefaults synchronize];
                
                [self clickedRefreshBtn:nil];
            } else {
                NSLog(@"Get access token failed.");
            }
        }];
    } else {
        
        [Tool showAlert:@"Tip" message:@"Please sign in first." rootViewController:self];
        return;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"to_signin_vc"]) {
        SignInViewController* signInVC = segue.destinationViewController;
        signInVC.delegate = self;
        signInVC.modalPresentationStyle = UIModalPresentationFullScreen;
        //signInVC.transitioningDelegate = self;
    }
}


- (IBAction)clickedUploadBtn:(id)sender {
    
    if(NO == [self isSignIn])
    {
        [Tool showAlert:@"Tip" message:@"Please sign in first." rootViewController:self];
        return;
    }
    else {
        NSString* urlString = @"http://4134d577z4.zicp.vip:51930/connect/token";
        
        NSDictionary* token = @{@"username":USERNAME, @"password":PASSWORD};
        
        [HttpRequest.sharedInstance post:urlString token:token withCompletionBlock:^(NSDictionary *dict) {
            
            if(dict && [dict isKindOfClass:[NSDictionary class]])
            {
                [NSUserDefaults.standardUserDefaults setObject:dict forKey:@"access_token"];
                [NSUserDefaults.standardUserDefaults synchronize];
            } else {
                NSLog(@"Get access token failed.");
            }
        }];
    }
    
    if (NO == [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"This device does not have a camera.");
        
        [Tool showAlert:@"Tip" message:@"This device does not have a camera." rootViewController:self];
        return;
    }
    
    if(self.isRequesting) {
        return;
    }
    
    if(self.isUpdatingImage)
    {
        [Tool showAlert:@"Tip" message:@"Current image is updating, please wait for a moment." rootViewController:self];
        return;
    }
    
    if(self.playerLayer)
        [self.playerLayer removeFromSuperlayer];
    
    self.isRequesting = YES;
    
    self.imageLabel.text = @"";
    self.tryTimes = 5;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // Do something with the captured image
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    
    [self.tipLabel setHidden: (self.imageView.image != nil) ? YES:NO];
    
    if(image)
    {
        [self uploadImage: image];
        [self.indicator startAnimating];
    }
    else {
        self.isRequesting = NO;
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.isRequesting = NO;
    [Tool showAlert:@"Tip" message:@"Please take a photo for uploading first." rootViewController:self];
}

- (void)uploadImage:(UIImage*)image {
    
    //SwiftTool.shared.uploadImage(image);
    
//    [SwiftTool.shared uploadImage: image];
//
//    return;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString* urlString = @"http://4134d577z4.zicp.vip:51930/dsdapi/image";
    //NSString* urlString = @"http://172.58.168.91:5000/";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"####upload-image: %@", urlString);
    NSDictionary *parameters = [NSUserDefaults.standardUserDefaults objectForKey:@"access_token"];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[url absoluteString] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    
    NSString* accessToken = [parameters objectForKey:@"access_token"];
    NSString* token_type = [parameters objectForKey:@"token_type"];
    NSString* temp = [NSString stringWithFormat:@"%@ %@",token_type,accessToken];
    [request setValue:temp forHTTPHeaderField:@"Authorization"];

//    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"video/mpeg", nil];
    
//    [request setValue:@"Apifox/1.0.0 (https://apifox.com)" forHTTPHeaderField: @"User-Agent"];
//    [request setValue:@"*/*" forHTTPHeaderField: @"Accept"];
//    [request setValue:@"172.58.168.91:5000" forHTTPHeaderField: @"Host"];
//    [request setValue:@"keep-alive" forHTTPHeaderField: @"Connection"];
//    request.addValue("multipart/form-data; boundary=--------------------------405055041975812888850014", forHTTPHeaderField: "Content-Type")
//    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    NSProgress* progress = nil;
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        self.isRequesting = NO;
        
            if (error != nil) {
                [self.indicator stopAnimating];
                [Tool showAlert:@"Uploading Error" message:@"Please check your internet and try to log in again." rootViewController:self];
                NSLog(@"####upload-image: error: %@", [error localizedDescription]);
                return;
            }
            else {
                NSLog(@"Upload image succeeded!");
                NSDictionary* resultDict = (NSDictionary*)responseObject;
                if(resultDict && [resultDict isKindOfClass:[NSDictionary class]])
                {
                    NSLog(@"####upload-image: success: %@", resultDict);
                    
                    NSNumber* success = [resultDict objectForKey:@"success"];
                    if(success && [success isKindOfClass:[NSNumber class]])
                    {
                        BOOL b = [success boolValue];
                        if(b)
                        {
                            [self showHUD:@"Image Uploading Complete"];
                            NSDictionary* resultData = [resultDict objectForKey:@"data"];
                            if(resultData && [resultData isKindOfClass:[NSDictionary class]]) {
                                [NSUserDefaults.standardUserDefaults setObject:resultData forKey:@"upload_result_data"];
                                [NSUserDefaults.standardUserDefaults synchronize];
                                
                                [self updateBySignalR];
                                [self clickedRefreshBtn:nil];
                                return;
                            }
                        }
                    }
                }
            }
        
        [Tool showAlert:@"Uploading Error" message:@"Please check your internet and try to log in again." rootViewController:self];
        return;
        
    }];
    [uploadTask resume];
}

- (IBAction)clickedRefreshBtn:(id)sender {
    
    if(self.isUpdatingImage)
        return;
    
    self.tryTimes = 5;
    self.isUpdatingImage = YES;
    if(NO == self.indicator.isAnimating)
        [self.indicator startAnimating];
    
    self.imageLabel.text = @"Updating the image from server...";
    [self updateImage];

}

- (void)updateImage
{
    NSDictionary* resultData = [NSUserDefaults.standardUserDefaults objectForKey:@"upload_result_data"];
    if(resultData && [resultData isKindOfClass:[NSDictionary class]]){
        NSString* idString = [resultData objectForKey:@"result"];
        if(idString.length)
        {
            HttpRequest* request = [HttpRequest new];
            NSString* urlString = [NSString stringWithFormat:@"http://4134d577z4.zicp.vip:51930/dsdapi/result/%@",idString];
            
            NSLog(@"####refresh-image: start");
            
            [request refreshImage:urlString withCompletionBlock:^(NSDictionary* dict) {
                
                BOOL b = NO;
                if(dict && [dict isKindOfClass:[NSDictionary class]])
                {
                    NSString* result = [dict objectForKey:@"result"];
                    if(result.length && [result intValue] == 1)
                    {
                        b = YES;
                    }
                }
                
                //Test
                if(b == NO)
                {
                    NSString* result = [dict objectForKey:@"path"];
                    
                    NSLog(@"####refresh-image: success.");
                    
                    [self showHUD:@"Image Refresh Complete"];
                    self.imageLabel.text = @"The image has been updated from server.";
                    
                    
                    //self.imageView.image = image;
                    
                    [self initPlayer];
                    
                    [self.tipLabel setHidden: YES];
                    
                    [self.indicator stopAnimating];
                    self.isUpdatingImage = NO;
                }
                else {

                    NSLog(@"####refresh-image: failed");
                    
                    if(self.tryTimes > 0)
                    {
                        self.tryTimes--;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self updateImage];
                        });
                        
                    } else {
                        
                        NSLog(@"####refresh-image: end.");
                        
                        self.imageLabel.text = @"Updating the image failed.";
                        [Tool showAlert:@"Image Updating Error" message:@"Please check your internet and try to log in again." rootViewController:self];
                        self.isUpdatingImage = NO;
                        //[self.indicator stopAnimating];
                    }
                }
                
            }];
        }
    }
}

- (void)showHUD:(NSString*)text
{
    // Create the custom view with the checkmark image
    UIImage *checkmarkImage = [UIImage imageNamed:@"tick"];
    UIImageView *checkmarkImageView = [[UIImageView alloc] initWithImage:checkmarkImage];
    // Create the MBProgressHUD instance and set its mode to custom view
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeCustomView;

    // Set the custom view to the checkmark image view
    self.hud.customView = checkmarkImageView;


    // Set the label text to "Success" or any other message you want to display
    self.hud.label.text = text;

    // Hide the HUD after a delay (e.g. 2 seconds)
    [self.hud hideAnimated:YES afterDelay:2.0];
}

- (void)updateBySignalR {
    [SwiftTool.shared connect];
}

- (BOOL)canFindFile:(NSString*)path
{
    if(0 == [path length])
        return NO;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

#pragma mark - 接收播放完成的通知
- (void)runLoopTheMovie:(NSNotification *)notification {
    AVPlayerItem *playerItem = notification.object;
    [playerItem seekToTime:kCMTimeZero];
    [_player play];
}

- (void)initPlayer
{
//    self.view.translatesAutoresizingMaskIntoConstraints = YES;
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"];
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    self.player = nil;
    self.playerLayer = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AVPlayerItemDidPlayToEndTimeNotification];

    NSString *videoPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), @"/video.mp4"];
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.playerLayer.frame = self.imageView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.imageView.layer addSublayer:self.playerLayer];
    [self.player play];
    //添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runLoopTheMovie:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];

}

@end
