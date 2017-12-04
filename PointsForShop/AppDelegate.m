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
#import <AlipaySDK/AlipaySDK.h>

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
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"ad4193fb8db76ad975194754"
                          channel:@"1"
                 apsForProduction:0
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [TTUserInfoManager setJPUSHRegistID:registrationID];
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
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
//MARK:处理支付宝客户端返回的url（在app被杀模式下，通过这个方法获取支付结果）。
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handlerAlipaySuccess:resultDic];
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口 处理支付宝客户端返回的url（在app被杀模式下，通过这个方法获取支付结果）。
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self handlerAlipaySuccess:resultDic];
        }];
    }
    return YES;
}
//MARK:支付宝支付回掉处理
- (void)handlerAlipaySuccess :(NSDictionary *)resultDic{
    NSLog(@"result = %@",resultDic);
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    if ([resultStatus isEqualToString:@"9000"]) {
        //success
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AliPaySuccess object:nil];
    }
    else{
        //FAILED
        [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AliPayFailed object:resultDic];
    }

}
@end
