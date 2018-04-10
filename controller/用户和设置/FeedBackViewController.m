//
//  FeedBackViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FAQViewController.h"

@interface FeedBackViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITextView *inputTV;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
//输入电话号码
@property (strong, nonatomic) IBOutlet UITextField *inputPhoneTF;
//输入邮箱
@property (strong, nonatomic) IBOutlet UITextField *inputMailTF;
//拨打电话
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation FeedBackViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"常见问题" style:UIBarButtonItemStylePlain target:self action:@selector(goFAQ)];
    //添加输入框监控方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tvChanged:) name:UITextViewTextDidChangeNotification object:nil];
    NSString *service_phone = [[TTUserInfoManager userInfo] string_ForKey:@"service_phone"];
	self.phoneLabel.text =[NSString stringWithFormat:@"TEL:%@",service_phone];
}
// MARK:输入评论
- (void)tvChanged :(NSNotification *)noti{
    if (noti.object == self.inputTV) {
        if(self.inputTV.text.absolute_String.length<=0){
            self.placeHolderLabel.hidden = NO;
        }
        else{
            self.placeHolderLabel.hidden = YES;
        }
    }
}

//MARK:提交反馈
- (IBAction)save:(id)sender{
    if (self.inputTV.text.absolute_String.length<=0) {
        [ProgressHUD showError:@"请输入反馈内容" Interaction:NO];
        return;
    }
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [para setObject:self.inputTV.text.killEmoji forKey:@"content"];
    if (self.inputPhoneTF.text) {
        [para setObject:self.inputPhoneTF.text forKey:@"phone"];
    }
    if (self.inputMailTF.text) {
        [para setObject:self.inputMailTF.text forKey:@"email"];
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_FEED_BACK Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]) {
            [ProgressHUD showSuccess:msg Interaction:NO];
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
//MARK:拨打电话
- (IBAction)callMeMaybe:(id)sender{
    NSString *service_phone = [[TTUserInfoManager userInfo] string_ForKey:@"service_phone"];
    NSString *tel = [NSString stringWithFormat:@"tel://%@",service_phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}
//MARK:常见问题
- (void)goFAQ{
    FAQViewController *vc = [[FAQViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
