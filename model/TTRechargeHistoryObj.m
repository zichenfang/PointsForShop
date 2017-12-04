//
//  TTRechargeHistoryObj.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTRechargeHistoryObj.h"

@implementation TTRechargeHistoryObj
- (instancetype)initWithDic: (NSDictionary *)info
{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.pdr_add_time = [[info string_ForKey:@"pdr_add_time"] doubleValue];
    self.pdr_add_time_format = [[NSDate dateWithTimeIntervalSince1970:self.pdr_add_time] formatTimeInyyyyMMddHHmmss];
    self.pdr_admin = [info string_ForKey:@"pdr_admin"];
    self.pdr_amount = [[info string_ForKey:@"pdr_amount"] doubleValue];
    self.pdr_id = [info string_ForKey:@"pdr_id"];
    self.pdr_member_id = [info string_ForKey:@"pdr_member_id"];
    self.pdr_member_name = [info string_ForKey:@"pdr_member_name"];
    self.pdr_payment_code = [info string_ForKey:@"pdr_payment_code"];
    self.pdr_payment_name = [info string_ForKey:@"pdr_payment_name"];
    self.pdr_payment_state = [info string_ForKey:@"pdr_payment_state"];
    self.pdr_payment_time = [[info string_ForKey:@"pdr_payment_time"] doubleValue];
    self.pdr_payment_time_format = [[NSDate dateWithTimeIntervalSince1970:self.pdr_payment_time] formatTimeInyyyyMMddHHmmss];
    self.pdr_sn = [info string_ForKey:@"pdr_sn"];
    self.pdr_trade_sn = [info string_ForKey:@"pdr_trade_sn"];
    //默认为充值
    self.historyType = @"0";
    return self;
}
@end
