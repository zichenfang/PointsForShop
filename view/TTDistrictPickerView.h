//
//  TTSpotPickerView.h
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/24.
//  Copyright © 2017年 fff. All rights reserved.
//




#import <UIKit/UIKit.h>
#import "TTDistrictObj.h"


typedef void (^TTdistrictPickerViewHandler)(TTDistrictObj *model);

@interface TTDistrictPickerView : UIView
@property (nonatomic,strong) TTdistrictPickerViewHandler handler;
- (void)show:(TTdistrictPickerViewHandler)handler;

@end




