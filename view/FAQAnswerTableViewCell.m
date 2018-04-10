//
//  FAQAnswerTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "FAQAnswerTableViewCell.h"

@implementation FAQAnswerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTFAQObj *)obj{
    self.answerLabel.text = obj.answer;
}
@end
