//
//  TTNullDataTableViewCell.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/21.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTNullDataTableViewCell.h"

@implementation TTNullDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)msg :(NSString *)msg{
    self.msgLabel.text = msg;
}
@end
