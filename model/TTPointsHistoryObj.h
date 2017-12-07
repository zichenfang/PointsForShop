//
//  TTPointsHistoryObj.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/1.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTObject.h"
/*
 此model 服务于充值记录与提现记录页面
 */
@interface TTPointsHistoryObj : TTObject

@property (nonatomic,assign) int num;//
//type为1|2时是订单号,为3|4为流水号
@property (nonatomic,strong) NSString *order_no;//
//备注.type为3|4时显示
@property (nonatomic,strong) NSString *remark;//
//类型：1收入，2支出 3购买，4提现
@property (nonatomic,strong) NSString *type;//

@end


