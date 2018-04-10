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
    self.num = [[info string_ForKey:@"num"] intValue];
    self.order_no = [info string_ForKey:@"order_no"];
    self.remark = [info string_ForKey:@"remark"];
    self.type = [info string_ForKey:@"type"];
    self.create_time = [info string_ForKey:@"create_time"];
    return self;
}
@end
