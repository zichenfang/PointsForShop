//
//  TakeCashViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TakeCashViewController.h"
#import "ResignKeyboardView.h"
#import "SetPayPasswordViewController.h"
#import "TakeCashDesViewController.h"
#import "SetTakeCashAccountViewController.h"

@interface TakeCashViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLastLabel;//积分余额
@property (strong, nonatomic) IBOutlet UITextField *inputPointsTF;//提现积分
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;//显示可提现金额
@property (assign, nonatomic) double withdraw_proportion;//1积分可以兑换的人民币",

@end

@implementation TakeCashViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"积分提现";
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //检测是否设置过支付账号，没有的话则进入支付账号设置页面
    if ([[TTUserInfoManager userInfo] string_ForKey:@"withdraw_account"].length<=4) {
        [self presentAlertWithTitle:@"您尚未设置提现账号" Handler:^{
            [self goSettingPayAccount];
        } Cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    //检查是否有设置过支付密码，没有则进入支付密码设置界面
    else if ([[TTUserInfoManager userInfo] string_ForKey:@"withdraw_password"].length<=4) {
        [self presentAlertWithTitle:@"提现需要设置支付密码" Handler:^{
            [self goSettingPayPassword];
        } Cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else{
        [self loadTakeCashConfigInfo];
    }
}

- (void)goSettingPayAccount{
    SetTakeCashAccountViewController *vc = [[SetTakeCashAccountViewController alloc] init];
    vc.hidesBottomBarWhenPushed  =NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goSettingPayPassword{
    SetPayPasswordViewController *vc = [[SetPayPasswordViewController alloc] init];
    vc.hidesBottomBarWhenPushed  =NO;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)configUI{
    self.inputPointsTF.inputAccessoryView = [[ResignKeyboardView alloc] initWithTextField:self.inputPointsTF TextView:nil Instruction:@"积分"];
    NSString *member_points = [[TTUserInfoManager userInfo]string_ForKey:@"integral_withdraw"];
    self.pointsLastLabel.text = [NSString stringWithFormat:@"积分余额:%@",member_points];
}
- (void)tfChanged :(NSNotification *)noti{
    if (noti.object == self.inputPointsTF) {
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",self.withdraw_proportion*self.inputPointsTF.text.intValue];
    }
}
//MARK:获取提现比例
- (void)loadTakeCashConfigInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];    
    [TTRequestOperationManager POST:API_USER_GET_RATE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            self.withdraw_proportion = [[[responseJsonObject dictionary_ForKey:@"result"]string_ForKey:@"withdraw_proportion" ]doubleValue];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
        
    } Failure:^(NSError *error) {
    }];
}
//MARK:提现说明
- (void)goTakeCashDes{
    TakeCashDesViewController *vc = [[TakeCashDesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)ok:(id)sender {
    //验证信息
    if (self.inputPointsTF.text.floatValue<=0.1) {
        [ProgressHUD showError:@"请输入提现积分" Interaction:NO];
        return;
    }
    NSString *member_points = [[TTUserInfoManager userInfo]string_ForKey:@"integral_withdraw"];
    if (self.inputPointsTF.text.floatValue>member_points.floatValue) {
        [ProgressHUD showError:@"积分余额不足" Interaction:NO];
        return;
    }
    //输入提现密码
    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"请输入提现密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
    }];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alerVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = [alerVC textFields][0];
        [self presentAlertWithTitle:[NSString stringWithFormat:@"确认提现%@积分",self.inputPointsTF.text] Handler:^{
            [self requestWithPassword:tf.text];
        } Cancel:nil];
    }]];
    [self presentViewController:alerVC animated:YES completion:nil];
}
- (void)requestWithPassword:(NSString *)password{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.inputPointsTF.text forKey:@"amount"];//
    [para setObject:password.md5_32Bit_String forKey:@"withdraw_password"];//密码

    [TTRequestOperationManager POST:API_USER_POINTS_TAKE_CASH Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"1"])//
        {
            [ProgressHUD showSuccess:msg Interaction:NO];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
        
    } Failure:^(NSError *error) {
    }];
}
- (void)successBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
