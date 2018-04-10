//
//  TTNormalPickerItem.h
//  WhaleShop
//
//  Created by 殷玉秋 on 2017/11/7.
//  Copyright © 2017年 HeiziTech. All rights reserved.
//

#import "TTObject.h"
/*
 用于pickerView选择时的Object
 */
@interface TTNormalPickerItem : TTObject
@property (nonatomic,strong) NSString *item_id;
@property (nonatomic,strong) NSString *item_name;


@end
