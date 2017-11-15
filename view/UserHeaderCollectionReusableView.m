//
//  UserHeaderCollectionReusableView.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/13.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "UserHeaderCollectionReusableView.h"

@implementation UserHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置不规则圆角
    self.whiteBackView.layer.cornerRadius = 4;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.whiteBackView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(34, 34)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.whiteBackView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.whiteBackView.layer.mask = maskLayer;
    //添加手势
}

@end
