//
//  AppDelegate.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/13.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "AppDelegate.h"
#import "TTVenderHeader.h"
#import "MainMenuViewController.h"
#import "GuideViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //强制竖屏
    if(!UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)){
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    }
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    if ([TTUserInfoManager appHasLaunched] ==YES) {
        if ([TTUserInfoManager logined] == YES) {
            MainMenuViewController *mainVC = [[MainMenuViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        }
        else{
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        }
    }
    else{
        GuideViewController *guideVC = [[GuideViewController alloc] init];
        self.window.rootViewController = guideVC;
    }
    //注册推送
    [self prepareAPNs];
    [self prepareJPushWithOptions:launchOptions];
    return YES;
}
//MARK:添加初始化APNs代码
- (void)prepareAPNs{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:nil];
}
//MARK:初始化JPush代码
- (void)prepareJPushWithOptions:(NSDictionary *)launchOptions {
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"ad4193fb8db76ad975194754"
                          channel:@"1"
                 apsForProduction:0
            advertisingIdentifier:nil];
    
}
//MARK:DeviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    NSMutableString *deviceTokenStr = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    int iCount = (int)deviceToken.length;
    for (int i = 0; i < iCount; i++) {
        [deviceTokenStr appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    NSLog(@"方式1：%@", deviceTokenStr);
    [JPUSHService registerDeviceToken:deviceToken];
    if (deviceTokenStr) {
        [TTUserInfoManager setAPNsDeviceToken:deviceTokenStr];
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
//MARK:处理APNs通知回调方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

@end
