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
    //去掉引导页
    [TTUserInfoManager setAppHasLaunched:YES];
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
    //获取版本信息
    [self performSelector:@selector(loadVersionInfo) withObject:nil afterDelay:2];
    return YES;
}
//MARK:添加初始化APNs代码
- (void)prepareAPNs{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionSound;
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
//MARK:获取版本更新内容
- (void)loadVersionInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    //类型 1-用户端   2-商户端
    [para setObject:@"2" forKey:@"type"];
    if ([TTUserInfoManager deviceToken]) {
        [para setObject:[TTUserInfoManager jPushRegistID] forKey:@"push_token"];
    }
    [TTRequestOperationManager POST:API_APP_VERSION_INFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]) {
            NSString *version_online = [result string_ForKey:@"ios_version"];
            NSString *version_local =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            NSString *version_rejected = [TTUserInfoManager rejectUpdateVersion];
            int version_local_int = [version_local stringByReplacingOccurrencesOfString:@"." withString:@""].intValue;
            int version_online_int = [version_online stringByReplacingOccurrencesOfString:@"." withString:@""].intValue;
            int version_rejected_int = [version_rejected stringByReplacingOccurrencesOfString:@"." withString:@""].intValue;
            //version_online版本以下的并且在被拒绝版本以上的
            if (version_local_int<version_online_int&&version_rejected_int<version_online_int) {
                NSString *ios_describe = [result string_ForKey:@"ios_describe"];
                NSString *ios_href = [result string_ForKey:@"ios_href"];
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"新版本可用！" message:ios_describe preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *act = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ios_href]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ios_href]];
                    }
                }];
                [alertVC addAction:act];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"暂不升级" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [TTUserInfoManager setRejectUpdateVersion:version_online];
                }]];
                [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
            }
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}
@end
