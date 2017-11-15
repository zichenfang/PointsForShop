//
//  TTObject.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/25.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "TTObject.h"

@implementation TTObject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isNullData = NO;
    }
    return self;
}
- (instancetype)initWithNullDataMsg :(NSString *)msg
{
    self = [super init];
    if (self) {
        self.nullDataMsg = msg;
        self.isNullData = YES;
    }
    return self;
}
- (instancetype)initWithDic: (NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.isNullData = NO;
    }
    return self;
}
@end
