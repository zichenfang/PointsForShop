//
//  SetLoginPasswordViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/31.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "SetLoginPasswordViewController.h"

@interface SetLoginPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *oldPassWordTF;
@property (strong, nonatomic) IBOutlet UITextField *xinPassWord_TF;
@property (strong, nonatomic) IBOutlet UITextField *xinPassWord_again_TF;

@end

@implementation SetLoginPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
}
- (IBAction)saveNow:(id)sender {
    if (self.oldPassWordTF.text.length<6 || self.oldPassWordTF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数旧密码" Interaction:NO];
        return;
    }
    if (self.xinPassWord_TF.text.length<6 || self.xinPassWord_TF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数新密码" Interaction:NO];
        return;
    }
    if (![self.xinPassWord_TF.text isEqualToString:self.xinPassWord_again_TF.text]) {
        [ProgressHUD showError:@"两次输入新密码不一致" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.oldPassWordTF.text.md5_32Bit_String forKey:@"old_password"];
    [para setObject:self.xinPassWord_TF.text.md5_32Bit_String forKey:@"new_password"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_CHANGE_LOGIN_PASSWORD Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            [ProgressHUD showSuccess:msg Interaction:NO];
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            NSString *token = [result string_ForKey:@"token"];
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[TTUserInfoManager userInfo]];
            [userinfo setObject:token forKey:@"token"];
            [TTUserInfoManager setUserInfo:userinfo];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.5];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}
- (void)successBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
