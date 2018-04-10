//
//  TTFAQObj.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTFAQObj.h"

@implementation TTFAQObj
- (instancetype)initWithDic: (NSDictionary *)info{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.faq_id = [info string_ForKey:@"id"];
    self.issue = [info string_ForKey:@"issue"];
    self.answer = [info string_ForKey:@"answer"];
    self.isOpen = NO;//默认为关闭
    return self;
}
@end

