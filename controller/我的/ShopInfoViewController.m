//
//  ShopInfoViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopInfoBaseViewController.h"
#import "ShopInfoShenHeViewController.h"
#import "ShopInfoMoreViewController.h"


@interface ShopInfoViewController ()

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺维护";
}
//MARK:基本信息
- (IBAction)baseInfo:(id)sender {
    ShopInfoBaseViewController *vc = [[ShopInfoBaseViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:审核信息
- (IBAction)shenheInfo:(id)sender {
    ShopInfoShenHeViewController *vc = [[ShopInfoShenHeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:更多信息
- (IBAction)moreInfo:(id)sender {
    ShopInfoMoreViewController *vc = [[ShopInfoMoreViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
