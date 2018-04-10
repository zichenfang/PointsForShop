//
//  TTDistrictObj.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/21.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDistrictObj : NSObject
@property (nonatomic,strong)NSString *provinceName;
@property (nonatomic,strong)NSString *provinceID;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *cityID;
@property (nonatomic,strong)NSString *districtName;
@property (nonatomic,strong)NSString *districtID;
- (NSString *)description;
@end
