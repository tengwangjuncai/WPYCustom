//
//  AppDelegate.m
//  WPYCustomControls
//
//  Created by 又一车－UI on 2017/2/19.
//  Copyright © 2017年 wpy_person. All rights reserved.
//

#import "AppDelegate.h"
#import "WPYTabBarController.h"
#import "IGShare.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    WPYTabBarController * tabBarController = [[WPYTabBarController alloc] init];
    NSLog(@"%ld",tabBarController.viewControllers.count);
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [self setupUMSocialManager];
    return YES;
}


- (void)setupUMSocialManager {
    
    // 设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMENG_APPKEY];
    
    [IGShare configIGSharePlatforms];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        
    }
    
     return  result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
