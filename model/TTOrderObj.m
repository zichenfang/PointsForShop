//
//  TTOrderObj.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTOrderObj.h"

@implementation TTOrderObj
- (instancetype)initWithDic: (NSDictionary *)info{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.order_no = [info string_ForKey:@"order_no"];
    self.amount = [[info string_ForKey:@"amount"] intValue];
    self.integral_proportion = [[info string_ForKey:@"integral_proportion"] intValue];
    self.pay_time = [info string_ForKey:@"pay_time"];
    self.obtain_integral = [[info string_ForKey:@"obtain_integral"] intValue];
    self.integral_ratio = [[info string_ForKey:@"integral_ratio"] intValue];
    self.order_id = [info string_ForKey:@"order_id"];
    self.order_id = [info string_ForKey:@"id"];
    self.user_id = [info string_ForKey:@"user_id"];
    self.user_name = [info string_ForKey:@"user_name"];
    self.state = [info string_ForKey:@"state"];

    return self;
}
@end
