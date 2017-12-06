//
//  TuiDanTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/6.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TuiDanTableViewCell.h"

@implementation TuiDanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTTuiDanObj *)obj{
//    订单状态:订单状态 2-冻结中 3-退款中 5-已完成  9-已退款"
    if ([obj.state isEqualToString:@"3"]) {
        //显示同意按钮
        self.agreeBtn.hidden = NO;
        self.moneyLabelTrailingConstraint.constant = 100;
    }
    else{
        self.agreeBtn.hidden = YES;
        self.moneyLabelTrailingConstraint.constant = 10;
    }
    self.userNameLabel.text = obj.order_no;
    self.timeLabel.text = obj.pay_time_format;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%d",obj.amount];
}
@end
