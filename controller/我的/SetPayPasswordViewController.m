//
//  SetPayPasswordViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/31.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "SetPayPasswordViewController.h"

@interface SetPayPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UITextField *passWord_again_TF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (nonatomic,assign) int leftCount;//验证码倒计时
@end

@implementation SetPayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置支付密码";
    //当没有设置过支付密码，但是需要输入支付密码的操作时，进入到该页面（例如订单支付）
    if (self.handler) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSetPassWord)];
    }
}
- (void)cancelSetPassWord{
    [self presentAlertWithTitle:@"确认退出？" Handler:^{
        self.handler(@{@"type":@"cancel"});
        [self.navigationController popViewControllerAnimated:YES];
    } Cancel:nil];
}
- (IBAction)getCode:(id)sender {
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:[TTUserInfoManager account] forKey:@"mobile"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_SEND_CODE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"])//
        {
            [self startTimeLimit];
            [ProgressHUD showSuccess:msg Interaction:NO];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
        
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
    
}
#pragma mark - 倒计时
- (void)startTimeLimit{
    self.codeBtn.enabled = NO;
    self.leftCount = MESSAGE_CODE_TIMEOUT;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(self.leftCount<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeBtn.enabled = YES;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",self.leftCount] forState:UIControlStateDisabled];
            });
            self.leftCount--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)saveNow:(id)sender {
    if (self.passWordTF.text.length<6 || self.passWord_again_TF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数密码" Interaction:NO];
        return;
    }
    if (![self.passWord_again_TF.text isEqualToString:self.passWordTF.text]) {
        [ProgressHUD showError:@"两次输入密码不一致" Interaction:NO];
        return;
    }
    if (self.codeTF.text.length<4) {
        [ProgressHUD showError:@"请填写正确的验证码" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"withdraw_password"];
    [para setObject:self.codeTF.text forKey:@"verify_code"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_SET_TAKECASH_PASSWORD Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            //设置支付密码
            NSString *member_paypwd = self.passWordTF.text.absolute_String.md5_32Bit_String;
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[TTUserInfoManager userInfo]];
            [userinfo setObject:member_paypwd forKey:@"withdraw_password"];
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
