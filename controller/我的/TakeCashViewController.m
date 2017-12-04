//
//  TakeCashViewController.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TakeCashViewController.h"
#import "ResignKeyboardView.h"
#import "TakeCashDesViewController.h"


@interface TakeCashViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLastLabel;//积分余额
@property (strong, nonatomic) IBOutlet UITextField *inputPointsTF;//提现积分
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;//显示可提现金额
@property (assign, nonatomic) double withdraw_proportion;//1积分可以兑换的人民币",
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;

@end

@implementation TakeCashViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"积分提现";
    [self loadTakeCashConfigInfo];
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)configUI{
    self.inputPointsTF.inputAccessoryView = [[ResignKeyboardView alloc] initWithTextField:self.inputPointsTF TextView:nil Instruction:@"积分"];
    NSString *member_points = [[TTUserInfoManager userInfo]string_ForKey:@"integral_withdraw"];
    self.pointsLastLabel.text = member_points;
    self.inputPointsTF.placeholder = [NSString stringWithFormat:@"您本次最多可兑换%@积分",member_points];
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
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_GET_ALLINFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            self.withdraw_proportion = [[[responseJsonObject dictionary_ForKey:@"result"]string_ForKey:@"withdraw_proportion" ]doubleValue];
            [ProgressHUD dismiss];
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
    if (self.passWordTF.text.length<6) {
        [ProgressHUD showError:@"请输入不少于6位数提现密码" Interaction:NO];
        return;
    }
    [self presentAlertWithTitle:[NSString stringWithFormat:@"确认提现%@积分",self.inputPointsTF.text] Handler:^{
        [self requestTakeCash];
    } Cancel:nil];

}
- (void)requestTakeCash{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:self.inputPointsTF.text forKey:@"amount"];//
    [para setObject:self.passWordTF.text.md5_32Bit_String forKey:@"withdraw_password"];//密码
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
