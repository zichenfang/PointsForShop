//
//  TTdistrictPickerView.m
//  SuiTu
//
//  Created by 殷玉秋 on 2017/5/23.
//  Copyright © 2017年 fff. All rights reserved.
//

#import "TTDistrictPickerView.h"
#import "TTVenderHeader.h"




@interface TTDistrictPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIPickerView *pickerView;

@property (nonatomic,strong)NSArray *provinces;
@property (nonatomic,strong)NSArray *cities;
@property (nonatomic,strong)NSMutableArray *districts;

@property (nonatomic,assign)NSInteger province_selectedRow;
@property (nonatomic,assign)NSInteger city_selectedRow;
@property (nonatomic,assign)NSInteger district_selectedRow;



@end
@implementation TTDistrictPickerView

- (instancetype)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 240)];
        [self addSubview:self.contentView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        [self.contentView addSubview:self.pickerView];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        
        float btnWidth = 60;
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        okBtn.frame = CGRectMake(self.frame.size.width - btnWidth, 0, btnWidth, 40);
        [self.contentView addSubview:okBtn];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0.666 alpha:1] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(ok) forControlEvents:UIControlEventTouchUpInside];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(0, 0, btnWidth, 40);
        [self.contentView addSubview:cancelBtn];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        float titleWidth = 200;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - titleWidth) * 0.5, 0, titleWidth, 40)];
        [self.contentView addSubview:titleLabel];
        titleLabel.text = @"选择地区";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        titleLabel.textColor = [UIColor darkGrayColor];
        
    }
    return self;
}
- (void)ok{
    if (self.handler) {
        TTDistrictObj *districtModel = [[TTDistrictObj alloc] init];
        if (self.provinces.count>0) {
            districtModel.provinceID = [[self.provinces objectAtIndex:self.province_selectedRow] string_ForKey:@"id"];
            districtModel.provinceName = [[self.provinces objectAtIndex:self.province_selectedRow] string_ForKey:@"name"];
            
        }
        if (self.cities.count>0) {
            districtModel.cityID = [[self.cities objectAtIndex:self.city_selectedRow] string_ForKey:@"id"];
            districtModel.cityName = [[self.cities objectAtIndex:self.city_selectedRow] string_ForKey:@"name"];
            
        }
        if (self.districts.count>0) {
            districtModel.districtID = [[self.districts objectAtIndex:self.district_selectedRow] string_ForKey:@"id"];
            districtModel.districtName = [[self.districts objectAtIndex:self.district_selectedRow] string_ForKey:@"name"];
            
        }
        self.handler(districtModel);
    }
    [self dismiss];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return self.provinces.count;
        }
            break;
        case 1:
        {
            return self.cities.count;
        }
            break;
        case 2:
        {
            return self.districts.count;
        }
            break;
            
        default:
            return 0;
            break;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width/3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return [[self.provinces objectAtIndex:row] string_ForKey:@"name"];
        }
            break;
        case 1:
        {
            return [[self.cities objectAtIndex:row] string_ForKey:@"name"];
        }
            break;
        case 2:
        {
            return [[self.districts objectAtIndex:row] string_ForKey:@"name"];
        }
            break;
            
        default:
            return @"";
            break;
    }
    return @"test";
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
        {
            self.province_selectedRow = row;
            self.city_selectedRow =0;
            self.district_selectedRow = 0;
            [self loadCityList];
        }
            break;
        case 1:
        {
            self.city_selectedRow = row;
            self.district_selectedRow = 0;
            [self loaddistrictList];
        }
            break;
        case 2:
        {
            self.district_selectedRow = row;
//            [self updateSelectedModelInfo];
        }
            break;
            
        default:
            break;
    }

    
    
}
- (void)updateSelectedModelInfo{
    if (self.handler) {
        TTDistrictObj *districtModel = [[TTDistrictObj alloc] init];
        if (self.provinces.count>0) {
            districtModel.provinceID = [[self.provinces objectAtIndex:self.province_selectedRow] string_ForKey:@"area_id"];
            districtModel.provinceName = [[self.provinces objectAtIndex:self.province_selectedRow] string_ForKey:@"area_name"];
            
        }
        if (self.cities.count>0) {
            districtModel.cityID = [[self.cities objectAtIndex:self.city_selectedRow] string_ForKey:@"area_id"];
            districtModel.cityName = [[self.cities objectAtIndex:self.city_selectedRow] string_ForKey:@"area_name"];
            
        }
        if (self.districts.count>0) {
            districtModel.districtID = [[self.districts objectAtIndex:self.district_selectedRow] string_ForKey:@"area_id"];
            districtModel.districtName = [[self.districts objectAtIndex:self.district_selectedRow] string_ForKey:@"area_name"];
            
        }
        self.handler(districtModel);
    }
}
- (void)loadProvinceList{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:@"0" forKey:@"parent_id"];
    [TTRequestOperationManager GET:API_GET_PROVINCE_CITY_DISTRICT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSArray *result = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"]&&result.count>0)//
        {
            self.provinces = result;
            self.province_selectedRow = 0;
            self.city_selectedRow = 0;
            self.district_selectedRow = 0;
            [self loadCityList];
        }
        else{
            self.provinces = @[];
        }
        [self.pickerView reloadComponent:0];
        
    } Failure:^(NSError *error) {
    }];
}
- (void)loadCityList{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[[self.provinces objectAtIndex:self.province_selectedRow] string_ForKey:@"id"] forKey:@"parent_id"];
    [TTRequestOperationManager GET:API_GET_PROVINCE_CITY_DISTRICT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSArray *result = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"]&&result.count>0)//
        {
            self.cities = result;
            self.city_selectedRow = 0;
            self.district_selectedRow = 0;
            [self loaddistrictList];
        }
        else{
            self.cities = @[];
        }
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
    } Failure:^(NSError *error) {
    }];
}
- (void)loaddistrictList{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[[self.cities objectAtIndex:self.city_selectedRow] string_ForKey:@"id"] forKey:@"parent_id"];
    [TTRequestOperationManager GET:API_GET_PROVINCE_CITY_DISTRICT Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSArray *result = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            if (self.districts ==nil) {
                self.districts = [NSMutableArray array];
            }
            else{
                [self.districts removeAllObjects];
            }
            if (result.count>0) {
                [self.districts addObjectsFromArray:result];
            }
            self.district_selectedRow = 0;
        }

        [self.pickerView reloadComponent:2];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
    } Failure:^(NSError *error) {
    }];
}
- (void)show:(TTdistrictPickerViewHandler)handler
{
    
    if (handler) {
        self.handler = handler;
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self loadProvinceList];

    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -self.contentView.frame.size.height);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    }];

}
- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];


}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[self class]]) {
        [self dismiss];
    }
}
@end
