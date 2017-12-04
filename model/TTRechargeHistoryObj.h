//
//  TTRechargeHistoryObj.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTObject.h"

@interface TTRechargeHistoryObj : TTObject
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
