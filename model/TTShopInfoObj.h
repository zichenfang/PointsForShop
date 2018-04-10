//
//  TTShopInfoObj.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/21.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTObject.h"
/*
 存储店铺其他信息
 */
@interface TTShopInfoObj : TTObject
@property (nonatomic,strong)NSString *shop_id;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *admin_id;//
@property (nonatomic,strong)NSString *area_id;//区ID
@property (nonatomic,strong)NSString *area_text;//区

@property (nonatomic,strong)NSString *business_hours;//
@property (nonatomic,strong)NSString *city_id;//
@property (nonatomic,strong)NSString *city_text;//
@property (nonatomic,assign)NSTimeInterval create_time;//
@property (nonatomic,strong)NSString *geo_code;//
@property (nonatomic,strong)NSString *head_img;//
@property (nonatomic,strong)NSString *integral_ratio;//
@property (nonatomic,strong)NSString *introduction;//
@property (nonatomic,strong)NSString * latitude;//
@property (nonatomic,strong)NSString * longitude;//
@property (nonatomic,strong)NSString *name;//
@property (nonatomic,strong)NSString *shop_phone;//
@property (nonatomic,strong)NSString *province_id;//
@property (nonatomic,strong)NSString *province_text;//
@property (nonatomic,strong)NSString *push_token;//
@property (nonatomic,strong)NSString *radio_update_time;//
@property (nonatomic,strong)NSString *state;//    "state": "integer,1待审核2审核通过 0未通过",
@property (nonatomic,strong)NSString *type;//店铺分类
@property (nonatomic,strong)NSString *type_text;//店铺分类

@property (nonatomic,assign)NSTimeInterval update_time;//
@property (nonatomic,strong)NSString *withdraw_account;//
@property (nonatomic,strong)NSString *withdraw_password;//
@property (nonatomic,strong)NSString *use_range;//积分使用范围
@property (nonatomic,strong)NSString *check_remark;//check_remark


@end


