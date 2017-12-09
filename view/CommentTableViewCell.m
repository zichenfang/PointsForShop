//
//  CommentTableViewCell.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)data :(TTCommentObj *)obj{
    //包含图片
    if (obj.images.count>0) {
        self.insertImagesViewHeight.constant = SCREEN_WIDTH * 0.2;
        self.insertImagesView.hidden = NO;
        //图1
        if (obj.image1 != nil){
            [self.iv1 sd_setImageWithURL:[NSURL URLWithString:obj.image1] placeholderImage:PLACEHOLDER_GENERAL];
        }
        else{
            self.iv1.image = nil;
        }
        //图2
        if (obj.image2 != nil){
            [self.iv2 sd_setImageWithURL:[NSURL URLWithString:obj.image2] placeholderImage:PLACEHOLDER_GENERAL];
        }
        else{
            self.iv2.image = nil;
        }
        //图3
        if (obj.image3 != nil){
            [self.iv3 sd_setImageWithURL:[NSURL URLWithString:obj.image3] placeholderImage:PLACEHOLDER_GENERAL];
        }
        else{
            self.iv3.image = nil;
        }
        
    }
    //不包含图片，只有文字
    else{
        self.insertImagesViewHeight.constant = 0;
        self.insertImagesView.hidden = YES;
    }
    //头像等信息
    [self.uesrAvatarIV sd_setImageWithURL:[NSURL URLWithString:obj.head_url] placeholderImage:PLACEHOLDER_USER];
    self.userNameLabel.text = obj.nickname;
    self.kdaLabel.text = [NSString stringWithFormat:@"%.1f分",obj.score];
    self.commentTimeLabel.text = obj.create_time;
    //星星
    int starValue = obj.star;
    for (int tag = 100;tag<105;tag++) {
        UIImageView *starIV = [self.userInfoView viewWithTag:tag];
        if (tag-100 < starValue){
            starIV.image =[UIImage imageNamed:@"xingxing_liang"];
        }
        else{
            starIV.image =[UIImage imageNamed:@"xingxing_an"];
        }
    }
    //评论内容
    self.commentLabel.text = obj.comment;
    
}
@end
