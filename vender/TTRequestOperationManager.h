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
//MARK: ●发送短信验证码
#define API_USER_SEND_CODE  @"/api.php/v1.Publics/sendSms"

//MARK: ●API修改用户名
#define API_USER_CHANGE_USERNAME  @"&method=jingtu.user_center.editMemberInfo.post"
//MARK: ●API上传图片
#define API_USER_UPLOAD_IMAGE  @"/api.php/v1.Seller/upload"
//MARK: ●API上传不可修改信息
#define API_USER_UPLOAD_INFORMATION_ONLY_ONCE  @"/api.php/v1.Seller/addQualifications"
//MARK: ●API更新商家产品信息
#define API_USER_UPLOAD_INFORMATION_PRODUCT  @"/api.php/v1.Seller/updateDetail"
//MARK: ●API更新不需要审核信息
#define API_USER_UPLOAD_INFORMATION_OTHER  @"/api.php/v1.Seller/updateInfo"

//MARK: ●API省市区
#define API_GET_PROVINCE_CITY_DISTRICT @"/api.php/v1.Publics/location"
//MARK: ●API获取所有的商家分类
#define API_GET_SHOP_CATEGORY @"/api.php/v1.Publics/sellerCategory"
//MARK: ●API获取商家信息-不可修改信息(营业执照、许可证等)
#define API_GET_SHOP_CANNOT_CHANGE_INFO @"/api.php/v1.Seller/qualifications"
//MARK: ●API获取商户产品信息
#define API_GET_SHOP_PRODUCT_INFO @"/api.php/v1.Seller/detail"
//MARK: ●API获取商户信息
#define API_GET_SHOP_OTHER_INFO @"/api.php/v1.Seller/info"

//MARK: ●API获取商户信息（用户端接口）
#define API_SHOP_SHOPS_DETAIL @"/api.php/v1.Index/sellerDetail"


//MARK: ●API找回密码
#define API_USER_FINDPASSWORD  @"/api.php/v1.Publics/sellerRetrievePassword"
//MARK: ●API修改登录
#define API_USER_CHANGE_LOGIN_PASSWORD  @"/api.php/v1.Seller/changePassword"


//MARK: ●API
#define API_GET_PAY_LOGIN_PASSWORD_CODE  @" "
//MARK: ●API设置提现密码
#define API_SET_TAKECASH_PASSWORD  @"/api.php/v1.Seller/setWithdrawPassword"
//MARK: ●API提现申请提现
#define API_USER_POINTS_TAKE_CASH  @"/api.php/v1.Seller/applyWithdraw"
//MARK: ●API获取商户积分流水
#define API_USER_POINTS_HISTORY  @"/api.php/v1.Seller/statement"


//MARK: ●API设置提现账户
#define API_SET_TAKECASH_ACCOUNT  @"/api.php/v1.Seller/setWithdrawAccount"
//MARK: ●API积分充值
#define API_POINTS_RECHARGE  @"/api.php/v1.Seller/integralRecharge"
//MARK: ●API积分退单（消费）
#define API_USER_POINTS_TUIDAN_HISTORY  @"/api.php/v1.Seller/orders"
//MARK: ●API获取充值/提现说明
#define API_USER_RECHARGE_TAKECASH_DES  @"/api.php/v1.Seller/explain"

//MARK: ●API获取用户当前信息（包括用户信息、积分账户信息、积分汇率等）
#define API_USER_GET_ALLINFO  @"/api.php/v1.Seller/account"
//MARK: ●API通过退款
#define API_USER_AGREE_TUIDAN  @"/api.php/v1.Seller/agreeRefund"
//MARK: ●API意见反馈
#define API_USER_FEED_BACK  @"/api.php/v1.Seller/feedback"

//MARK: ●API常见问题
#define API_USER_FAQ_LIST  @"/api.php/v1.Seller/FAQs"
//MARK: ●API获取注册协议
#define API_USER_REGIST_PROTOCOL  @"/api.php/v1.Publics/registrationProtocol"
//MARK: ●API获取商户评价列表
#define API_SHOP_COMMENTS  @"/api.php/v1.Index/Comments"
//MARK: ●API获取商户三个评分
#define API_SHOP_COMMENTS_TRIBLE_SCORE  @"/api.php/v1.Index/average"
//MARK: ●API获取积分说明
#define API_SHOP_POINTS_DES  @"/api.php/v1.Publics/integralExplain"
//MARK: ●API获取版本信息
#define API_APP_VERSION_INFO @"/api.php/v1.Publics/checkVersion"


@interface TTRequestOperationManager : NSObject

+ (id)defaultManager;
//普通的POST传参方式
+ (void)POST:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;
//get
+ (void)GET:(NSString *)URLString Parameters:(NSMutableDictionary *)parameters Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


//上传data的post方法
+ (void)POST:(NSString *)URLString parameters:(NSMutableDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block Success:(void (^)(NSDictionary *responseJsonObject))mySuccess Failure:(void (^)(NSError *error))myFailure;


@end
