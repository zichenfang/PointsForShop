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
    CGRect whiteBackViewRect =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width -120, 150);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteBackViewRect byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(34, 34)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = whiteBackViewRect;
    maskLayer.path = maskPath.CGPath;
    self.whiteBackView.layer.mask = maskLayer;
    //添加手势
}

@end
