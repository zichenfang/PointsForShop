//
//  RechargeViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/28.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *inputPointsTF;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UITextView *rechargeDesTV;
@property (nonatomic,assign) float pointPercent;//充值比例
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.pointPercent = 0.087;//瞎编的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tfChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)tfChanged:(NSNotification *)noti{
    if (noti.object ==self.inputPointsTF) {
        NSString *inputText = [NSString stringWithFormat:@"%d",self.inputPointsTF.text.absolute_String.intValue];
        self.moneyLabel.text = [NSString stringWithFormat:@"¥%.1f",inputText.intValue*self.pointPercent];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [TTRequestOperationManager POST:API_POINTS_RECHARGE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            //充值成功之后，需要重新获取一下积分信息才可以
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
