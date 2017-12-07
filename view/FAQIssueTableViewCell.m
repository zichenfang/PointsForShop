//
//  FAQIssueTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "FAQIssueTableViewCell.h"

@implementation FAQIssueTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)data :(TTFAQObj *)obj{
    self.issueLabel.text = obj.issue;
    if (obj.isOpen == YES) {
        self.arrowIV.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else{
        self.arrowIV.transform = CGAffineTransformMakeRotation(0);
    }
}
@end
