//
//  UIBarButtonItem+TTStyle.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/15.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "UIBarButtonItem+TTStyle.h"

@implementation UIBarButtonItem (TTStyle)
- (void)setTTStyle
{
    [self setTintColor:[UIColor blackColor]];
    [self setTitleTextAttributes:@{NSFontAttributeName :[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName :[UIColor darkGrayColor]} forState:UIControlStateNormal];

}

@end
