//
//  OrderTableViewCell.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTOrderObj.h"

@interface OrderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;//用户名
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;//金额
@property (strong, nonatomic) IBOutlet UIButton *agreeBtn;//同意按钮
//控制金额显示右边距
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelTrailingConstraint;

- (void)data :(TTOrderObj *)obj;
@end
