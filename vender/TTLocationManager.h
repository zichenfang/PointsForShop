//
//  TTLocationManager.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/14.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
@interface TTLocationManager : NSObject

@property (nonatomic,strong) CLLocation *location;
@property (nonatomic,strong) NSString *cityID;
@property (nonatomic,strong) NSString *cityName;


+ (TTLocationManager *)defaultManager;

- (void)requestLocation :(void(^)(CLLocation *location,NSString *cityName))success PermissionFaild :(void(^)(NSError *error))permissionFaild locationFailed :(void(^)(NSError *error))locationFaild;

@end
