//
//  TTCommentObj.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTCommentObj.h"

@implementation TTCommentObj
- (instancetype)initWithDic: (NSDictionary *)info{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.comment_id = [info string_ForKey:@"comment_id"];
    self.user_id = [info string_ForKey:@"user_id"];
    self.nickname = [info string_ForKey:@"nickname"];
    self.head_url = [info string_ForKey:@"head_url"];
    self.comment = [info string_ForKey:@"comment"];
    self.score = [[info string_ForKey:@"score"] doubleValue];
    self.star = [[info string_ForKey:@"score"] intValue];
    self.image1 = [info string_ForKey:@"image1"];
    self.image2 = [info string_ForKey:@"image2"];
    self.image3 = [info string_ForKey:@"image3"];
    self.images = [NSMutableArray array];
    if (self.image1) {
        [self.images addObject:self.image1];
    }
    if (self.image2) {
        [self.images addObject:self.image2];
    }
    if (self.image3) {
        [self.images addObject:self.image3];
    }
    self.create_time = [info string_ForKey:@"create_time"];
    return self;
}
@end


