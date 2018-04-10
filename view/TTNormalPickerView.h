//
//  TTTourTypePickerView.h
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/24.
//  Copyright © 2017年 fff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTNormalPickerItem.h"

typedef void (^TTNormalPickerViewHandler)(TTNormalPickerItem *item);

@interface TTNormalPickerView : UIView
@property (nonatomic,strong) TTNormalPickerViewHandler handler;
- (void)showWithItems :(NSArray <TTNormalPickerItem *> *)items SelectedIndex :(NSInteger)selectedIndex Handler:(TTNormalPickerViewHandler)handler;

@end
/*
 NSString *selectedItemID;
 - (void)rightBarButtonClick:(UIButton *)button {
 //    MapViewController *mapVC = [[MapViewController alloc]init];
 //    mapVC.dataArray = _dataArray;
 //    [self.navigationController pushViewController:mapVC animated:YES];
 TTNormalPickerView *pickerView = [[TTNormalPickerView alloc] init];
 TTNormalPickerItem *item1 = [[TTNormalPickerItem alloc] init];
 item1.title = @"经销商1";
 item1.item_id = @"1";
 
 TTNormalPickerItem *item3 = [[TTNormalPickerItem alloc] init];
 item3.title = @"经销商3";
 item3.item_id = @"3";
 
 
 TTNormalPickerItem *item2 = [[TTNormalPickerItem alloc] init];
 item2.title = @"经销商2";
 item2.item_id = @"2";
 
 TTNormalPickerItem *item4 = [[TTNormalPickerItem alloc] init];
 item4.title = @"经销商4";
 item4.item_id = @"4";
 
 TTNormalPickerItem *item5 = [[TTNormalPickerItem alloc] init];
 item5.title = @"经销商5";
 item5.item_id = @"5";
 
 NSArray *items =@[item1,item2,item3,item4,item5];
 NSInteger selectedIndex = 0;
 for(int i=0;i<items.count;i++){
 TTNormalPickerItem *item  = items[i];
 if ([selectedItemID isEqualToString:item.item_id]) {
 selectedIndex = i;
 break;
 }
 }
 
 [pickerView showWithItems:items SelectedIndex :selectedIndex Handler:^(TTNormalPickerItem *item) {
 //
 NSLog(@"%@ --%@ ",item.title,item.item_id);
 selectedItemID =item.item_id;
 }];
 }
 */
