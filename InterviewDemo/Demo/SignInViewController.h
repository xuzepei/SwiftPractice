//
//  SignInViewController.h
//  Test1
//
//  Created by xuzepei on 2023/5/17.
//

#import <UIKit/UIKit.h>


@interface SignInViewController : UIViewController

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;



- (IBAction)clickedSignInBtn:(id)sender;

@end
