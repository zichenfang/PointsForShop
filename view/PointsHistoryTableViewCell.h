//
//  PointsHistoryTableViewCell.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPointsHistoryObj.h"

@interface PointsHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNOLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;//充值或体现金额
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;//
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;//时间



- (void)data :(TTPointsHistoryObj *)obj;
@end
