//
//  OrderTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius =4;
    
    self.agreeBtn.layer.borderWidth =1;
    self.agreeBtn.layer.borderColor = [UIColor stylePinkColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTOrderObj *)obj{
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
    self.userNameLabel.text = obj.user_name;
    self.timeLabel.text = obj.pay_time;
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%d",obj.amount];
}
@end
