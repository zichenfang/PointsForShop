//
//  RechargeHistoryTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "RechargeHistoryTableViewCell.h"

@implementation RechargeHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTPointsHistoryObj *)obj{
    if ([obj.type isEqualToString:@"充值"]) {
        self.statusDesLabel.text = @"充值成功";
        self.pointsDesLabel.text = [NSString stringWithFormat:@"+%d",obj.num];
    }
    else{
        self.statusDesLabel.text = @"提现成功";
        self.pointsDesLabel.text = [NSString stringWithFormat:@"-%d",obj.num];
    }
    self.timeLabel.text = obj.create_time;
}
@end
