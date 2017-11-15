//
//  LoginViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/20.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "RegistViewController.h"
#import "FndPassWordViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    if ([TTUserInfoManager account].length>1) {
        self.phoneTF.text =[TTUserInfoManager account];
    }
}


- (IBAction)findPassword:(id)sender {
    FndPassWordViewController *vc = [[FndPassWordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}
- (IBAction)regist:(id)sender {
    RegistViewController *vc = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginNow:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [ProgressHUD showError:@"请输入正确的手机号" Interaction:NO];
        return;
    }
    if (self.passWordTF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数密码" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"mobile"];
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"password"];
    if ([TTUserInfoManager deviceToken]) {
        [para setObject:[TTUserInfoManager deviceToken] forKey:@"push_token"];
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_LOGIN Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"])//
        {
            [ProgressHUD showSuccess:@"登录成功" Interaction:NO];
            [TTUserInfoManager setUserInfo:result];
            [TTUserInfoManager setLogined:YES];
            [TTUserInfoManager setAccount:phone];
            [self performSelector:@selector(loginSuccess) withObject:nil afterDelay:1.5];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}

#pragma mark - Navigation
- (void)loginSuccess{
    MainMenuViewController *mainVC = [[MainMenuViewController alloc] init];
    UIWindow *keyWindow =[[UIApplication sharedApplication] delegate].window;
    [UIView transitionWithView:keyWindow duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        keyWindow.rootViewController = mainVC;
    } completion:nil];
}
@end
