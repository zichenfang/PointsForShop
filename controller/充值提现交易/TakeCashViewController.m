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
#import "TakeCashHistoryViewController.h"


@interface TakeCashViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lastPointsLabel;//积分余额
@property (strong, nonatomic) IBOutlet UITextField *inputPointsTF;//提现积分
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;//显示可提现金额
@property (assign, nonatomic) double withdraw_proportion;//1积分可以兑换的人民币",
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIButton *takeCashHistoryBtn;//充值记录按钮

@end

@implementation TakeCashViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"积分提现";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现说明" style:UIBarButtonItemStylePlain target:self action:@selector(goTakeCashDes)];
    [self loadTakeCashConfigInfo];
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)configUI{
    self.takeCashHistoryBtn.layer.masksToBounds = YES;
    self.takeCashHistoryBtn.layer.cornerRadius = 5;
    self.takeCashHistoryBtn.layer.borderWidth =1;
    self.takeCashHistoryBtn.layer.borderColor = [UIColor stylePinkColor].CGColor;
    self.inputPointsTF.inputAccessoryView = [[ResignKeyboardView alloc] initWithTextField:self.inputPointsTF TextView:nil Instruction:@"积分"];
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
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            self.withdraw_proportion = [[result string_ForKey:@"withdraw_proportion" ]doubleValue];
            //显示积分余额
            NSString *integral_balance = [result string_ForKey:@"integral_balance"];
            self.lastPointsLabel.text =integral_balance;
            self.inputPointsTF.placeholder = [NSString stringWithFormat:@"您本次最多可兑换%@积分",integral_balance];
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
        
    } Failure:^(NSError *error) {
    }];
}
//MARK:
- (IBAction)takeCashHistory:(id)sender{
    TakeCashHistoryViewController *vc = [[TakeCashHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (self.inputPointsTF.text.floatValue>self.lastPointsLabel.text.floatValue) {
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
    [ProgressHUD show:nil Interaction:NO];
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
