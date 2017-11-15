//
//  MyNetWork.h
//  DressIn3D
//
//  Created by Timo on 15/9/19.
//  Copyright (c) 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "JsonKillNull.h"
//数据请求地址
#define kHTTP @"http://jf.bingplus.com/"

//MARK: ●IS_MD5
//#define IS_MD5  0

//MARK: ●登录
#define API_USER_LOGIN  @"/api.php/v1.Publics/sellerLogin"
//MARK: ●注册
#define API_USER_REGIST @"/api.php/v1.Publics/sellerRegister"
//MARK: ●注册发送短信验证码
#define API_USER_REGIST_CODE  @"/api.php/v1.Publics/sendSms"



//MARK: ●API修改用户名
#define API_USER_CHANGE_USERNAME  @"&method=jingtu.user_center.editMemberInfo.post"
//MARK: ●API上传头像
#define API_USER_UPLOAD_AVATAR  @"&method=jingtu.user_center.editMemberAvatar.post"
//MARK: ●API找回密码-发送短信验证码
#define API_USER_FINDPASSWORD_CODE  @"&method=jingtu.user.sendForgetPwdSms.post"
//MARK: ●API找回密码
#define API_USER_FINDPASSWORD  @"&method=jingtu.user.forgetPwd.post"

//MARK: ●API
#define API_GET_PAY_LOGIN_PASSWORD_CODE  @" "
//MARK: ●API
#define API_SET_PAY_LOGIN_PASSWORD  @" "


@interface TTRequestOperationManager : NSObject

+ (id)defaultManager;
//普通的POST传参方式
+ (void)POST:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;
//get
+ (void)GET:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


//上传data的post方法
+ (void)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


@end
