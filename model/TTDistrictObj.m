//
//  TTDistrictObj.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/21.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTDistrictObj.h"

@implementation TTDistrictObj
- (NSString *)description{
    return [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",self.provinceName,self.provinceID,self.cityName,self.cityID,self.districtName,self.districtID];
}
@end
