//
//  TTShopInfoObj.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/21.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTShopInfoObj.h"

@implementation TTShopInfoObj
- (instancetype)initWithDic: (NSDictionary *)info
{
    self = [super initWithDic:info];
    if (![info isKindOfClass:NSClassFromString(@"NSDictionary")]) {
        info = @{};
    }
    self.shop_id = [info string_ForKey:@"id"];
    self.address = [info string_ForKey:@"address"];
    self.admin_id = [info string_ForKey:@"admin_id"];
    self.area_id = [info string_ForKey:@"area_id"];
    self.area_text = [info string_ForKey:@"area_text"];

    self.business_hours = [info string_ForKey:@"business_hours"];
    self.city_id = [info string_ForKey:@"city_id"];
    self.city_text = [info string_ForKey:@"city_text"];
    self.create_time = [[info string_ForKey:@"create_time"] doubleValue];
    self.geo_code = [info string_ForKey:@"geo_code"];
    self.head_img = [info string_ForKey:@"head_img"];
    self.integral_ratio = [info string_ForKey:@"integral_ratio"];
    self.introduction = [info string_ForKey:@"introduction"];
    self.latitude = [info string_ForKey:@"latitude"];
    self.longitude = [info string_ForKey:@"longitude"];
    self.name = [info string_ForKey:@"name"];
    self.shop_phone = [info string_ForKey:@"shop_phone"];
    self.province_id = [info string_ForKey:@"province_id"];
    self.province_text = [info string_ForKey:@"province_text"];
    self.push_token = [info string_ForKey:@"push_token"];
    self.radio_update_time = [info string_ForKey:@"radio_update_time"];
    self.state = [info string_ForKey:@"state"];
    self.type = [info string_ForKey:@"type"];
    self.type_text = [info string_ForKey:@"type_text"];
    self.update_time = [[info string_ForKey:@"update_time"] doubleValue];
    self.withdraw_account = [info string_ForKey:@"withdraw_account"];
    self.withdraw_password = [info string_ForKey:@"withdraw_password"];
    self.use_range = [info string_ForKey:@"use_range"];
    self.check_remark = [info string_ForKey:@"check_remark"];

    return self;
}
@end

//@property (nonatomic,strong)NSString *name;//
//@property (nonatomic,strong)NSString *mobile;//
//@property (nonatomic,strong)NSString *province_id;//
//@property (nonatomic,strong)NSString *province_text;//
//@property (nonatomic,strong)NSString *push_token;//
//@property (nonatomic,strong)NSString *radio_update_time;//
//@property (nonatomic,strong)NSString *state;//    "state": "integer,1待审核2审核通过 0未通过",
//@property (nonatomic,strong)NSString *type;//店铺分类
//@property (nonatomic,assign)NSTimeInterval update_time;//
//@property (nonatomic,strong)NSString *withdraw_account;//
//@property (nonatomic,strong)NSString *withdraw_password;//

