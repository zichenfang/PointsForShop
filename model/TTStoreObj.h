//
//  TTStoreObj.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/22.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTObject.h"

@interface TTStoreObj : TTObject
@property (nonatomic,strong) NSString *store_id;
@property (nonatomic,strong) NSString *store_name;
@property (nonatomic,strong) NSString *area_info;
@property (nonatomic,strong) NSString *city_id;
@property (nonatomic,strong) NSString *data_description;
@property (nonatomic,strong) NSString *data_id;//id
@property (nonatomic,assign) BOOL is_favorites;
@property (nonatomic,strong) NSString *jingtu_storeid;
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,strong) NSString *member_id;
@property (nonatomic,strong) NSString *pano_url;
@property (nonatomic,strong) NSString *preview_img;
@property (nonatomic,strong) NSString *province_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *store_phone;

@end
