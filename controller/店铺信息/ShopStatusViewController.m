//
//  ShopStatusViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/13.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopStatusViewController.h"

@interface ShopStatusViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ShopStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺状态";
//    1.未审核：未维护店铺信息，提示尽快填写店铺资料，此时只能维护店铺。2.审核中，什么都不可操作。3.已冻结，什么都不可操作。4.营业中：店铺所有功能都可用
    switch (self.status.intValue) {
        case 1://未审核
            {
                self.iv.image = [UIImage imageNamed:@""];
                self.statusLabel.text = @"";
            }
            break;
        case 2://审核中
        {
            self.iv.image = [UIImage imageNamed:@""];
            self.statusLabel.text = @"";
        }
            break;
        case 3://已冻结
        {
            self.iv.image = [UIImage imageNamed:@""];
            self.statusLabel.text = @"";
        }
            break;
        case 4://营业中
        {
            self.iv.image = [UIImage imageNamed:@""];
            self.statusLabel.text = @"";
        }
            break;
            
        default:
            break;
    }
    
}


@end
