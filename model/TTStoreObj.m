//
//  TTStoreObj.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTStoreObj.h"

@implementation TTStoreObj
- (instancetype)initWithDic: (NSDictionary *)info
{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.store_id = [info string_ForKey:@"store_id"];
    self.store_name = [info string_ForKey:@"store_name"];
    self.area_info = [info string_ForKey:@"area_info"];
    self.city_id = [info string_ForKey:@"city_id"];
    self.data_description = [info string_ForKey:@"description"];
    self.data_id = [info string_ForKey:@"id"];
    self.is_favorites = [info string_ForKey:@"is_favorites"].boolValue;
    self.jingtu_storeid = [info string_ForKey:@"jingtu_storeid"];
    self.latitude = [info string_ForKey:@"latitude"].doubleValue;
    self.longitude = [info string_ForKey:@"longitude"].doubleValue;
    self.member_id = [info string_ForKey:@"member_id"];
    self.pano_url = [info string_ForKey:@"pano_url"];
    self.preview_img = [info string_ForKey:@"preview_img"];
    self.province_id = [info string_ForKey:@"province_id"];
    self.title = [info string_ForKey:@"title"];
    if ([self.title isEqualToString:@""]) {
        self.title = @"VR店铺";
    }
    return self;
}
@end
