//
//  SignInViewController.m
//  Test1
//
//  Created by xuzepei on 2023/5/17.
//

#import "SignInViewController.h"
#import "HttpRequest.h"
#import "Tool.h"
#import "MBProgressHUD.h"

#define USERNAME @"freqtyc_taojiangxia"
#define PASSWORD @"123456"

@interface SignInViewController ()

@property(nonatomic, strong)MBProgressHUD* hud;
@property(nonatomic, assign)BOOL isRequesting;

@end

@implementation SignInViewController

- (void)dealloc {
    self.hud = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Sign In";
    self.usernameTF.text = USERNAME;
    self.passwordTF.text = PASSWORD;
    



}

- (void)showHUD
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
    self.hud.label.text = @"Success";

    // Hide the HUD after a delay (e.g. 2 seconds)
    [self.hud hideAnimated:YES afterDelay:2.0];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInNotification" object:nil userInfo:nil];
}

- (IBAction)clickedSignInBtn:(id)sender {
    
    if(self.isRequesting) {
        return;
    }
    
    NSString* urlString = @"http://4134d577z4.zicp.vip:51930/connect/token";
    
    if(0 == self.usernameTF.text || 0 == self.passwordTF.text.length)
    {
        [Tool showAlert:@"Error" message:@"Please input username & password first!" rootViewController:self];
        return;
    }
    
    NSDictionary* token = @{@"username":self.usernameTF.text, @"password":self.passwordTF.text};
    

    self.isRequesting = YES;
    [self.indicator startAnimating];
    
    [HttpRequest.sharedInstance post:urlString token:token withCompletionBlock:^(NSDictionary *dict) {
        
        self.isRequesting = NO;
        [self.indicator stopAnimating];
        
        if(dict && [dict isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"####login: %@",dict);
            
            [NSUserDefaults.standardUserDefaults setObject:dict forKey:@"access_token"];
            [NSUserDefaults.standardUserDefaults synchronize];
            
            [self showHUD];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignInNotification" object:nil userInfo:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });

        } else {
            NSLog(@"Get access token failed.");
            [Tool showAlert:@"Login Failed" message:@"Please check your internet, username & password!" rootViewController:self];
        }
    }];
}




@end
