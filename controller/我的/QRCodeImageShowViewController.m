//
//  QRCodeImageShowViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/1.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "QRCodeImageShowViewController.h"

@interface QRCodeImageShowViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iv;

@end

@implementation QRCodeImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"向商家付款";
    self.iv.image = self.qrImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
