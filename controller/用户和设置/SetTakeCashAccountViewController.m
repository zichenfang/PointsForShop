//
//  SetTakeCashAccountViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/23.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "SetTakeCashAccountViewController.h"

@interface SetTakeCashAccountViewController ()
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;

@end

@implementation SetTakeCashAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)ok:(id)sender {
    if (self.accountTF.text.length<6) {
        [ProgressHUD showError:@"请输入正确的提现账号" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.accountTF.text forKey:@"withdraw_account"];
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"withdraw_password"];

    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_SET_TAKECASH_ACCOUNT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            //设置支付密码
            NSString *withdraw_account = self.accountTF.text;
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[TTUserInfoManager userInfo]];
            [userinfo setObject:withdraw_account forKey:@"withdraw_account"];
            [TTUserInfoManager setUserInfo:userinfo];
            [ProgressHUD showSuccess:msg Interaction:NO];
            [self performSelector:@selector(setPassWordSuccess) withObject:nil afterDelay:1.5];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
        
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}
- (void)setPassWordSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
