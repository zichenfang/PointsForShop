//
//  UserHeaderCollectionReusableView.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/13.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UIView *whiteBackView;
@property (strong, nonatomic) IBOutlet UIImageView *avatarIV;
@property (strong, nonatomic) IBOutlet UILabel *shopNameLabel;

@end
