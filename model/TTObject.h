//
//  TTObject.h
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/25.
//  Copyright © 2017年 fff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTVenderHeader.h"
@interface TTObject : NSObject
//填充到数组中，用于展示空白数据页面
@property (nonatomic,assign)BOOL isNullData;
@property (nonatomic,strong)NSString *nullDataMsg;

/*用于快速初始化一个空白标示model*/
- (instancetype)initWithNullDataMsg :(NSString *)msg;
- (instancetype)initWithDic: (NSDictionary *)info;

@end
