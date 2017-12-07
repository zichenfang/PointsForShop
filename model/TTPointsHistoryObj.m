//
//  TTPointsHistoryObj.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTPointsHistoryObj.h"

@implementation TTPointsHistoryObj
- (instancetype)initWithDic: (NSDictionary *)info
{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    return self;
}
@end
