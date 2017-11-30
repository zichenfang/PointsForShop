//
//  TTPointsHistoryObj.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTObject.h"

@interface TTPointsHistoryObj : TTObject
@property (nonatomic,assign) NSTimeInterval pdr_add_time;//
@property (nonatomic,strong) NSString * pdr_add_time_format;//

@property (nonatomic,strong) NSString *pdr_admin;//
@property (nonatomic,assign) NSTimeInterval pdr_amount;//
@property (nonatomic,strong) NSString *pdr_id;//
@property (nonatomic,strong) NSString *pdr_member_id;//
@property (nonatomic,strong) NSString *pdr_member_name;//
@property (nonatomic,strong) NSString *pdr_payment_code;//
@property (nonatomic,strong) NSString *pdr_payment_name;//
@property (nonatomic,strong) NSString *pdr_payment_state;//
@property (nonatomic,assign) NSTimeInterval pdr_payment_time;//
@property (nonatomic,strong) NSString * pdr_payment_time_format;//
@property (nonatomic,strong) NSString *pdr_sn;//
@property (nonatomic,strong) NSString *pdr_trade_sn;//

//0:未知，1:充值，2：体现
@property (nonatomic,strong) NSString *historyType;//

@end
//"pdr_add_time" = 1510108036;
//"pdr_admin" = "";
//"pdr_amount" = "200.00";
//"pdr_id" = 2;
//"pdr_member_id" = 15;
//"pdr_member_name" = "186****1270";
//"pdr_payment_code" = "";
//"pdr_payment_name" = "";
//"pdr_payment_state" = 0;
//"pdr_payment_time" = 0;
//"pdr_sn" = 790563452036798015;
//"pdr_trade_sn" = "";

