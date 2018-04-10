//
//  RegistViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/20.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "RegistViewController.h"
#import "AgreementViewController.h"

@interface RegistViewController ()
@property (strong, nonatomic) IBOutlet UITextField *shopNameTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIButton *registBtn;//注册按钮（在未同意合同之前，不能点击）


@property (nonatomic,assign) int leftCount;//验证码倒计时
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;//同意合同按钮

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"注册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBoard)];
}
- (void)resignKeyBoard{
    [self.shopNameTF.superview endEditing:YES];
}

- (IBAction)getCode:(id)sender {
    NSString *phone =[[self.phoneTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([phone isValidateMobile] !=YES) {
        [ProgressHUD showError:@"请输入正确的手机号" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:phone forKey:@"mobile"];
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
- (IBAction)registNow:(id)sender {
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self requestRegist];
    } Cancel:nil];
   
}
- (void)requestRegist{
    if (self.shopNameTF.text.length<2) {
        [ProgressHUD showError:@"请输入店铺名称" Interaction:NO];
        return;
    }
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
    [para setObject:self.shopNameTF.text.killEmoji forKey:@"name"];
    [para setObject:phone forKey:@"mobile"];
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"password"];
    [para setObject:self.codeTF.text forKey:@"code"];
    if ([TTUserInfoManager deviceToken]) {
        [para setObject:[TTUserInfoManager jPushRegistID] forKey:@"push_token"];
    }
    else{
        [para setObject:@"没有token" forKey:@"push_token"];
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_REGIST Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]) {
            [ProgressHUD showSuccess:@"注册成功" Interaction:NO];
            [TTUserInfoManager setUserInfo:result];
            [TTUserInfoManager setLogined:YES];
            [TTUserInfoManager setAccount:phone];
            [self performSelector:@selector(registSuccess) withObject:nil afterDelay:1.5];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络请求错误" Interaction:NO];
    }];
}
//注册成功之后，须登录操作
- (void)registSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}
//MARK:同意合同
- (IBAction)agreeDeal:(id)sender {
    if (self.agreeBtn.selected ==YES) {
        self.agreeBtn.selected = NO;
        self.registBtn.enabled = NO;
    }
    else{
        self.agreeBtn.selected = YES;
        self.registBtn.enabled = YES;
    }
}

//MARK:查看合同
- (IBAction)checkDeal:(id)sender {
    AgreementViewController *vc = [[AgreementViewController alloc] init];
    vc.handler = ^(NSDictionary *info) {
        self.agreeBtn.selected = YES;
        self.registBtn.enabled = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
