//
//  AppDelegate.m
//  BookRead
//
//  Created by 刘飞龙 on 2022/8/16.
//

#import "AppDelegate.h"
#import "FLTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    FLTabBarController *tabbarVc = [[FLTabBarController alloc] init];
    self.window.rootViewController = tabbarVc;
    
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].delegate.window = self.window;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

//进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:HiddenMune object:nil];
}

@end
