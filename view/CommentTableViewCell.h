//
//  CommentTableViewCell.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTCommentObj.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIImageView *uesrAvatarIV;
@property (nonatomic,strong) IBOutlet UILabel *userNameLabel;
@property (nonatomic,strong) IBOutlet UILabel *commentTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *kdaLabel;
@property (nonatomic,strong) IBOutlet UIView *userInfoView;
@property (nonatomic,strong) IBOutlet UIView *insertImagesView;
@property (nonatomic,strong) IBOutlet UIImageView *iv1;

@property (nonatomic,strong) IBOutlet UIImageView *iv2;

@property (nonatomic,strong) IBOutlet UIImageView *iv3;
@property (nonatomic,strong) IBOutlet UILabel *commentLabel;
@property (nonatomic,strong) IBOutlet NSLayoutConstraint *insertImagesViewHeight;


- (void)data :(TTCommentObj *)obj;
@end
