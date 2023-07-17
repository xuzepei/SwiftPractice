//
//  Tool.m
//  Test1
//
//  Created by xuzepei on 2023/5/17.
//

#import "Tool.h"

@implementation Tool

+ (void)showAlert:(NSString*)title message:(NSString*)message rootViewController:(UIViewController*)rootViewController
{
    if(0 == [title length])
        title = @"";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Handle OK button tap
    }];

//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        // Handle cancel button tap
//    }];

    [alertController addAction:okAction];
    //[alertController addAction:cancelAction];

    [rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
