//
//  AppDelegate.m
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//#define DEFAULT_COLOR [UIColor colorWithRed:74/255.0 green:172/255.0 blue:74/255.0 alpha:1.0]

#define DEFAULT_COLOR [UIColor colorWithRed:245/255.0 green:199/255.0 blue:49/255.0 alpha:1.0]

//#define DEFAULT_COLOR [UIColor colorWithRed:60/255.0 green:166/255.0 blue:126/255.0 alpha:1.0]


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = UIColor.systemYellowColor;
    
    [UINavigationBar appearance].standardAppearance = appearance;
    [UINavigationBar appearance].compactAppearance = appearance;
    [UINavigationBar appearance].scrollEdgeAppearance = appearance;
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
