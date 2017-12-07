//
//  TTOrderObj.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTObject.h"

@interface TTOrderObj : TTObject
@property (nonatomic,strong) NSString * order_no;//

@property (nonatomic,assign) int amount;//消费金额
@property (nonatomic,assign) int integral_proportion;//使用积分
@property (nonatomic,strong) NSString * pay_time;//

@property (nonatomic,assign) int obtain_integral;//获赠积分
@property (nonatomic,assign) int integral_ratio;//积分比例
@property (nonatomic,strong) NSString * order_id;//订单号
@property (nonatomic,strong) NSString * state;//订单状态:订单状态 2-冻结中 3-退款中 5-已完成  9-已退款"
@property (nonatomic,strong) NSString * user_id;//
@property (nonatomic,strong) NSString * user_name;//

@end
