//
//  TTFAQObj.h
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TTObject.h"

@interface TTFAQObj : TTObject

@property (nonatomic,strong) NSString * faq_id;//
@property (nonatomic,strong) NSString * issue;//
@property (nonatomic,strong) NSString * answer;//
@property (nonatomic,assign) int isOpen;//是否展开

@end
