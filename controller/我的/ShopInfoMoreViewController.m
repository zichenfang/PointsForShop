//
//  ShopInfoMoreViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/16.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopInfoMoreViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "TTLocationManager.h"
#import "TTNormalPickerView.h"
#import "TTNormalPickerItem.h"
//选择省市区
#import "TTDistrictPickerView.h"


@interface ShopInfoMoreViewController ()<UITextFieldDelegate,MAMapViewDelegate>
//scrollView height
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
//积分说明view height
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pointsDesViewHeightConstraint;


@property (strong, nonatomic) IBOutlet UITextField *pointsPercentTF;//积分比例
@property (strong, nonatomic) IBOutlet UITextView *pointsDesTV;//积分说明
@property (strong, nonatomic) IBOutlet UILabel *poinsDesPlaceHolderLabel;//placeHolder
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *areaTF;//地区
@property (strong, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (strong, nonatomic) IBOutlet MAMapView *mapView;//地图
@property (strong, nonatomic) IBOutlet UITextField *pinleiTF;//品类
@property (strong, nonatomic) IBOutlet UITextField *openTimeTF;//营业时间

@property (strong, nonatomic) NSMutableArray *pointsPercentDatas;//积分比例候选
@property (strong, nonatomic) TTNormalPickerItem *pointsPercentItem;//选中积分比例
@property (strong, nonatomic) TTDistrictObj *areaObj;//选中积省市区

@end

@implementation ShopInfoMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(resignKeyBorad)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tvChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [self configMapUIAndOtherUI];
}
- (void)resignKeyBorad{
    [self.pointsPercentTF.superview.superview endEditing:YES];
}
- (void)tvChanged :(NSNotification *)noti{
    UITextView *tv = noti.object;
    if (tv == self.pointsDesTV) {
        //积分说明，隐藏placeholder
        if (self.pointsDesTV.text.absolute_String.length>0) {
            self.poinsDesPlaceHolderLabel.hidden =YES;
        }
        else{
            self.poinsDesPlaceHolderLabel.hidden =NO;
        }
        //textView Y 为13
        CGFloat textHeight = self.pointsDesTV.contentSize.height +13.0;
        textHeight = MAX(60, textHeight);
        self.pointsDesViewHeightConstraint.constant = textHeight;
        self.contentViewHeightConstraint.constant =720 + textHeight;
    }
}
#pragma mark-config other UI
- (void)configMapUIAndOtherUI{
    //高德地图
	[TTLocationManager defaultManager];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}
- (void)requestLocation{
    TTLocationManager *manager = [TTLocationManager defaultManager];
    [manager requestLocation:^(CLLocation *location, NSString *cityName) {
    } PermissionFaild:^(NSError *error) {
        [self requestLocationPermissionFaild];
    } locationFailed:^(NSError *error) {
        [self requestLocationFaild];
    }];
}
//MARK:定位权限失败
- (void)requestLocationPermissionFaild{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"定位获取失败" message:@"请打开系统设置中“隐私->定位服务”，允许使用您的位置" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];

}
//MARK:定位失败
- (void)requestLocationFaild{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"获取定位失败，请重试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestLocation];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.pointsPercentTF) {
        //积分比例
        [self resignKeyBorad];
        [self selectPointsPercent];
        return NO;
    }
    else if (textField ==self.areaTF){
        //省市区
        [self resignKeyBorad];
        return NO;

    }
    else if (textField ==self.pinleiTF){
        //品类
        [self resignKeyBorad];
        return NO;

    }
    else if (textField ==self.openTimeTF){
        //营业时间
        [self resignKeyBorad];
        return NO;

    }
    return YES;
}
//MARK:积分比例
- (void)selectPointsPercent{
    if (self.pointsPercentDatas ==nil) {
        self.pointsPercentDatas = [NSMutableArray array];
    }
    if (self.pointsPercentDatas.count<=0) {
        NSArray *item_titles = @[@"10%",@"20%",@"30%",@"40%",@"50%",@"60%",@"70%",@"80%",@"90%",@"100%"];
        NSArray *item_ids = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
        for (int i=0; i<item_titles.count; i++) {
            TTNormalPickerItem *item = [[TTNormalPickerItem alloc] init];
            item.item_id = item_ids[i];
            item.item_name = item_titles[i];
            [self.pointsPercentDatas addObject:item];
        }
    }
    TTNormalPickerView *pickerView = [[TTNormalPickerView alloc] init];
    [pickerView showWithItems:self.pointsPercentDatas SelectedIndex:0 Handler:^(TTNormalPickerItem *item) {
        self.pointsPercentItem = item;
        self.pointsPercentTF.text = item.item_name;
    }];
}
//MARK:选择省市区
- (void)selectArea{
    TTDistrictPickerView *pickerView = [[TTDistrictPickerView alloc] init];
    [pickerView show:^(TTDistrictObj *model) {
        if (model) {
            NSString *area_info =[NSString stringWithFormat:@"%@ %@ %@ ",model.provinceName,model.cityName,model.districtName];
            self.areaTF.text = area_info;
            self.areaObj =model;
        }
    }];
}

- (IBAction)save:(id)sender {
}


@end
