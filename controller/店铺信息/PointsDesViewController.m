//
//  AgreementViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/5.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "PointsDesViewController.h"

@interface PointsDesViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PointsDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"积分说明";
    [self loadData];
    if (self.handler) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"同意" style:UIBarButtonItemStylePlain target:self action:@selector(agree)];
    }
}
//MARK:获取协议说明
- (void)loadData{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [TTRequestOperationManager POST:API_SHOP_POINTS_DES Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
            NSString *content = [result string_ForKey:@"content"];
            [self.webView loadHTMLString:content baseURL:nil];
        }
    } Failure:^(NSError *error) {
    }];
    
}
- (void)agree{
    if (self.handler) {
        self.handler(@{});
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

