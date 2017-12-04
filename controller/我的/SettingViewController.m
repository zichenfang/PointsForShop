//
//  SettingViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/1.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "SettingViewController.h"
#import "SetTakeCashAccountViewController.h"
#import "SetPayPasswordViewController.h"
#import "SetLoginPasswordViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goSetPassWord:(id)sender {
    SetPayPasswordViewController *vc = [[SetPayPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)goSetAccount:(id)sender {
    SetTakeCashAccountViewController *vc = [[SetTakeCashAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)goChangeLoginPassword:(id)sender {
    SetLoginPasswordViewController *vc = [[SetLoginPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)logOut:(id)sender {
    [self presentAlertWithTitle:@"退出登录" Handler:^{
        [self gologinOut];
    } Cancel:nil];

}
//MARK:退出登录
- (void)gologinOut{
    [TTUserInfoManager setLogined:NO];
    [TTUserInfoManager setUserInfo:@{}];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UIWindow *keyWindow =[[UIApplication sharedApplication] delegate].window;
    [UIView transitionWithView:keyWindow duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];;
    } completion:nil];
}

@end
