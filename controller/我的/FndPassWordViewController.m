//
//  FndPassWordViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "FndPassWordViewController.h"

@interface FndPassWordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (nonatomic,assign) int leftCount;//验证码倒计时

@end

@implementation FndPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"找回密码";
}


- (IBAction)sendCode:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [ProgressHUD showError:@"请输入正确的手机号" Interaction:NO];
        return;
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"mobile"];
    [para setObject:@"ios" forKey:@"client"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_FINDPASSWORD_CODE Parameters:para Success:^(NSDictionary *responseJsonObject) {
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
- (IBAction)save:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [ProgressHUD showError:@"请输入正确的手机号" Interaction:NO];
        return;
    }
    if (self.codeTF.text.length<4) {
        [ProgressHUD showError:@"请输入正确的验证码" Interaction:NO];
        return;
    }
    if (self.passWordTF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数密码" Interaction:NO];
        return;
    }

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"mobile"];
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"password"];

    [para setObject:self.codeTF.text forKey:@"vcode"];
    [para setObject:@"ios" forKey:@"client"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_FINDPASSWORD Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"])//
        {
            [ProgressHUD showSuccess:@"密码修改成功" Interaction:NO];
            [self performSelector:@selector(registSuccess) withObject:nil afterDelay:1.5];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
        
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}
//注册成功之后，直接跳转到主页，无须登录操作
- (void)registSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
