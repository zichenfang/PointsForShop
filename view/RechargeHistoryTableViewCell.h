//
//  RechargeHistoryTableViewCell.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPointsHistoryObj.h"

@interface RechargeHistoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *statusDesLabel;//充值成功
@property (strong, nonatomic) IBOutlet UILabel *pointsDesLabel;//+100
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;


- (void)data :(TTPointsHistoryObj *)obj;

@end
