//
//  TTLocationManager.m
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/10/14.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTLocationManager.h"
#import "ProgressHUD.h"

@interface TTLocationManager()
/*定位*/
@property (nonatomic,strong) AMapLocationManager *mapManager;


@end
@implementation TTLocationManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        /*定位初始化*/
        [AMapServices sharedServices].apiKey = @"36674764102ee717cc936692235f8cb0";
        self.mapManager = [[AMapLocationManager alloc] init];
        self.mapManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.mapManager.locationTimeout = 10;
        self.mapManager.reGeocodeTimeout = 10;
    }
    return self;
}
+ (TTLocationManager *)defaultManager
{
    static TTLocationManager *manager;
    if (manager ==nil) {
        manager = [[TTLocationManager alloc] init];
    }
    return manager;
}
- (void)requestLocation :(void(^)(CLLocation *location,NSString *cityName))success PermissionFaild :(void(^)(NSError *error))permissionFaild locationFailed :(void(^)(NSError *error))locationFaild{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        if (permissionFaild) {
            permissionFaild(nil);
        }
        return;
    }
    [ProgressHUD show:@"位置更新中..." Interaction:NO];
    [self.mapManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        [ProgressHUD dismiss];
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed)
            {
                if (permissionFaild) {
                    permissionFaild(error);
                }
                return;
            }
            else{
                if (locationFaild) {
                    locationFaild(error);
                }
                return;
            }
        }
        self.location = location;
        if (regeocode)
        {
            if (regeocode.city) {
                self.cityName = regeocode.city;
                if (success) {
                    success(location,regeocode.city);
                    return;
                }
            }
            else{
                if (locationFaild) {
                    locationFaild(error);
                }
            }
        }
        else{
            if (locationFaild) {
                locationFaild(error);
            }
        }
    }];
}
@end
