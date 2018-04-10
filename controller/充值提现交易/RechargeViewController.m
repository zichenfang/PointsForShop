//
//  RechargeViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/28.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "RechargeViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RechargeHistoryViewController.h"


@interface RechargeViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *lastPointsLabel;//积分余额
@property (strong, nonatomic) IBOutlet UITextField *inputPointsTF;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (assign, nonatomic) double recharge_proportion;//充值汇率：一元人民币可以充值多少积分
@property (strong, nonatomic) IBOutlet UIButton *rechargeHistoryBtn;//充值记录按钮
@property (strong, nonatomic) IBOutlet UIButton *rechargeBtn;//充值按钮
@property (strong, nonatomic) IBOutlet UIWebView *desWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;//页面contentsize高度为500+屏幕高度-64
//充值说明
@property (strong, nonatomic) NSString *desContent;

@end

@implementation RechargeViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoti_AliPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNoti_AliPayFailed object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    [self configUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:kNoti_AliPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFaildWithNoti:) name:kNoti_AliPayFailed object:nil];
    [self loadTakeCashConfigInfo];
    [self loadRechargeDes];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.contentHeightConstraint.constant = 500+SCREEN_HEIGHT-64;
}
- (void)configUI{
    self.rechargeHistoryBtn.layer.masksToBounds = YES;
    self.rechargeHistoryBtn.layer.cornerRadius = 5;
    self.rechargeHistoryBtn.layer.borderWidth =1;
    self.rechargeHistoryBtn.layer.borderColor = [UIColor stylePinkColor].CGColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(showDes)];
}
- (void)tfChanged:(NSNotification *)noti{
    if (noti.object ==self.inputPointsTF) {
        NSString *inputText = [NSString stringWithFormat:@"%d",self.inputPointsTF.text.absolute_String.intValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",inputText.intValue/self.recharge_proportion];
    }
}
//MARK:获取提现比例和余额
- (void)loadTakeCashConfigInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_GET_ALLINFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            self.recharge_proportion = [[result string_ForKey:@"recharge_proportion" ]doubleValue];
            [ProgressHUD dismiss];
            self.rechargeBtn.enabled = YES;
            //显示积分余额
            self.lastPointsLabel.text = [result string_ForKey:@"integral_balance"];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
            self.rechargeBtn.enabled = NO;
        }
        
    } Failure:^(NSError *error) {
    }];
}
//MARK:获取充值说明
- (void)loadRechargeDes{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    //    recharge-充值说明    withdraw-提现说明
    [para setObject:@"recharge" forKey:@"type"];//
    [TTRequestOperationManager POST:API_USER_RECHARGE_TAKECASH_DES Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            self.desContent = [result string_ForKey:@"content"];
            [self.desWebView loadHTMLString:self.desContent baseURL:nil];
        }
    } Failure:^(NSError *error) {
    }];
    
}
//MARK:跳转到充值说明
- (void)showDes{
    [self.scrollView scrollRectToVisible:CGRectMake(0, 500, SCREEN_HEIGHT, SCREEN_HEIGHT-64) animated:YES];
}
- (IBAction)pay:(id)sender {
    if (self.inputPointsTF.text.absolute_String.intValue<=0) {
        [ProgressHUD showError:@"请输入充值积分" Interaction:NO];
        return;
    }
    [self presentAlertWithTitle:@"确认支付？" Handler:^{
        [self payNow];
    } Cancel:nil];
}
- (void)payNow{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    NSString *inputText = [NSString stringWithFormat:@"%d",self.inputPointsTF.text.absolute_String.intValue];
    [para setObject:inputText forKey:@"amount"];
    [para setObject:@"备注" forKey:@"remark"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_POINTS_RECHARGE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]) {
            [ProgressHUD dismiss];
            //暂时只有支付宝
            [self aliPayWithInfo:result];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
    }];
}
- (void)aliPayWithInfo:(NSDictionary *)info {
    NSString *order = [info string_ForKey:@"string"];
    [[AlipaySDK defaultService] payOrder:order fromScheme:@"alipaypointsform" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
        //充值成功之后，需要重新获取一下积分信息才可以
        if ([resultStatus isEqualToString:@"9000"]) {
            //success
            [self paySuccess];
        }
        else{
            //FAILED
            [self payFaildWithStatus:resultStatus];
        }
    }];
}

- (void)paySuccess{
    [ProgressHUD showSuccess:@"充值成功！" Interaction:NO];
    [self performSelector:@selector(loadTakeCashConfigInfo) withObject:nil afterDelay:1.5];
}

- (void)payFaildWithNoti :(NSNotification *)noti{
    NSString *resultStatus = [noti.object objectForKey:@"resultStatus"];
    [self payFaildWithStatus:resultStatus];
}
- (void)payFaildWithStatus :(NSString *)status{
    NSString *errorMsg;
    switch (status.intValue) {
        case 8000: {
           errorMsg =@"正在处理中，支付结果未知";
        }
            break;
        case 4000: {
            errorMsg =@"订单支付失败";
        }
            break;
        case 6001: {
            errorMsg =@"用户中途取消";
        }
            break;
        case 6002: {
            errorMsg =@"支付结果未知";
        }
            break;
        default:  {
            errorMsg =@"其它支付错误";
        }
            break;
    }
    [self presentToastAlertWithTitle:errorMsg Handler:nil];
}

//MARK:充值记录
- (IBAction)goRechargeHistory:(id)sender {
    RechargeHistoryViewController *vc =[[RechargeHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
