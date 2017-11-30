//
//  PointsHistoryTableViewCell.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "PointsHistoryTableViewCell.h"

@implementation PointsHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTPointsHistoryObj *)obj{
    self.bankNameLabel.text = obj.pdr_payment_name;
    self.userNameLabel.text = obj.pdr_member_name;
    self.cardNOLabel.text = [NSString stringWithFormat:@"银行卡号:%@",obj.pdr_payment_code];
    //充值
    if ([obj.historyType isEqualToString:@"1"]) {
        self.amountLabel.text = [NSString stringWithFormat:@"充值:%.2f",obj.pdr_amount];
    }
    //体现
    else{
        self.amountLabel.text = [NSString stringWithFormat:@"提现:%.2f",obj.pdr_amount];
    }
    if ([obj.pdr_payment_state isEqualToString:@"1"]) {
        //审核中
        self.stateLabel.text = @"审核中";
    }
    else{
        //完成
        self.stateLabel.text = @"成功";
    }
    self.timeLabel.text = obj.pdr_add_time_format;
}
@end
