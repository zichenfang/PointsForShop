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
#import <AMapSearchKit/AMapSearchKit.h>
#import "PointsDesViewController.h"
#import "TTShopInfoObj.h"
#import "PointsDesViewController.h"

@interface ShopInfoMoreViewController ()<UITextFieldDelegate,MAMapViewDelegate,AMapSearchDelegate,MAMapViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *shenhezhongView;//上传成功之后，如果在审核中，则显示此View
@property (strong, nonatomic) IBOutlet UITextField *pointsPercentTF;//积分比例
@property (strong, nonatomic) IBOutlet UITextView *pointsUseDesTV;//积分使用说明
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *areaTF;//地区
@property (strong, nonatomic) IBOutlet UITextField *addressTF;//详细地址
@property (strong, nonatomic) IBOutlet MAMapView *mapView;//地图
@property (strong, nonatomic) IBOutlet UITextField *pinleiTF;//品类
@property (strong, nonatomic) IBOutlet UITextField *openTimeTF;//营业时间
@property (strong, nonatomic) TTShopInfoObj *shopInfo;//从服务器获取到的店铺信息（用来根表单信息进行对比，不一致信息进行提交处理）

@property (strong, nonatomic) NSMutableArray *pointsPercentDatas;//积分比例候选
@property (strong, nonatomic) TTNormalPickerItem *pointsPercentItem;//选中积分比例
@property (strong, nonatomic) TTDistrictObj *areaObj;//选中积省市区
@property (strong, nonatomic) AMapSearchAPI *search;//根据城市名称返回当前位置
@property (strong, nonatomic) MAPointAnnotation *pointAnnotation;//点击地图，选择地图位置
@property (strong, nonatomic) NSMutableArray *pinleiDatas;//选择品类候选
@property (strong, nonatomic) TTNormalPickerItem *pinleiItem;//选中品类
@property (strong, nonatomic) IBOutlet UILabel *rejectReasonLabel;//审核未通过的原因

@end

@implementation ShopInfoMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"积分说明" style:UIBarButtonItemStylePlain target:self action:@selector(checkPoinsDes)];
    [self configMapUIAndOtherUI];
    [self loadShopInfo];
}
//MARK:获取店铺信息-每天只能修改一次的信息
- (void)loadShopInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
//    [para setObject:@"pending" forKey:@"type"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_GET_SHOP_OTHER_INFO Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD dismiss];
            self.shopInfo = [[TTShopInfoObj alloc] initWithDic:result];
            [self switchUIHidden];
        }
        else{
            [ProgressHUD showError:msg];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
    } Failure:^(NSError *error) {
    }];
}
//根据状态status，选择需要显示和隐藏的控件
- (void)switchUIHidden{
    //type=pending时:1：待审核2：审核通过9：未上传信息 ；0未通过 type=其他值时:不存在
    NSInteger state = self.shopInfo.state.integerValue;
    //待审核
    if (state ==1) {
        self.shenhezhongView.hidden = NO;
    }
    //审核通过，显示已上传的信息
    else if (state ==2){
        self.scrollView.hidden = NO;
        [self updateInfoUI];
    }
    //未上传信息
    else if (state ==9){
        self.scrollView.hidden = NO;
    }
    //未通过
    else if (state ==0){
        self.scrollView.hidden = NO;
        self.rejectReasonLabel.hidden = NO;
        [self updateInfoUI];
    }
}

- (void)updateInfoUI{
    if (self.shopInfo.shop_id.intValue>0) {
        //待审核或者审核通过状态下，将已经上传过的信息赋值到当前页面
        if (self.shopInfo.integral_ratio.length>1) {
            self.pointsPercentTF.text =[NSString stringWithFormat:@"%@%%",self.shopInfo.integral_ratio];//积分比例
        }
        if (self.shopInfo.use_range.length>1) {
            self.pointsUseDesTV.text =self.shopInfo.use_range;//积分使用说明
        }
        if (self.shopInfo.shop_phone.length>1) {
            self.phoneTF.text =self.shopInfo.shop_phone;//电话
        }
        if (self.shopInfo.province_text.length>2&&self.shopInfo.city_text.length>2&&self.shopInfo.area_text.length>2) {
            self.areaTF.text =[NSString stringWithFormat:@"%@ %@ %@",self.shopInfo.province_text,self.shopInfo.city_text,self.shopInfo.area_text];//
        }
        if (self.shopInfo.address.length>1) {
            self.addressTF.text =self.shopInfo.address;//地址
        }
        if (self.shopInfo.longitude.length>1) {
            double longitude = [self.shopInfo.longitude doubleValue];
            double latitude = [self.shopInfo.latitude doubleValue];
            CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(latitude, longitude);
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            [self addPointAnnotationAtCoordinate:coordinate];
        }
        if (self.shopInfo.type.intValue>0) {
            self.pinleiTF.text =self.shopInfo.type_text;//
        }
        if (self.shopInfo.business_hours.length>1) {
            self.openTimeTF.text =self.shopInfo.business_hours;//时间
        }
        self.rejectReasonLabel.text =self.shopInfo.check_remark;//审核意见（审核不通过的原因）
    }
}
- (void)resignKeyBorad{
    [self.pointsPercentTF.superview.superview endEditing:YES];
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
        [self selectArea];
        return NO;
    }
    else if (textField ==self.pinleiTF){
        //品类
        [self resignKeyBorad];
        [self selectPinLei];
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
        NSArray *item_ids = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90",@"100"];
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
//MARK:查看积分说明
- (void)checkPoinsDes{
    PointsDesViewController *vc = [[PointsDesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:选择省市区
- (void)selectArea{
    TTDistrictPickerView *pickerView = [[TTDistrictPickerView alloc] init];
    [pickerView show:^(TTDistrictObj *model) {
        if (model) {
            NSString *area_info =[NSString stringWithFormat:@"%@ %@ %@ ",model.provinceName,model.cityName,model.districtName];
            self.areaTF.text = area_info;
            self.areaObj =model;
            [self swichMapLocation];
        }
    }];
}
//MARK:选择省市区变动时，更改当前地图位置
- (void)swichMapLocation{
    if (self.search ==nil) {
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
    }
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = self.areaObj.districtName;
    dist.requireExtension = YES;
    [self.search AMapDistrictSearch:dist];
}
- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    if (response == nil){
        return;
    }
    for (AMapDistrict *dist in response.districts){
        NSLog(@"%@--%@ ",dist.name,dist.center);
        if (dist) {
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(dist.center.latitude, dist.center.longitude) animated:YES];
            break;
        }
    }
}
/**
 *  单击地图底图调用此接口
 *
 *  @param mapView    地图View
 *  @param coordinate 点击位置经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self addPointAnnotationAtCoordinate:coordinate];
}
- (void)addPointAnnotationAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if (self.pointAnnotation ==nil) {
        self.pointAnnotation = [[MAPointAnnotation alloc] init];
        self.pointAnnotation.title = [[TTUserInfoManager userInfo] string_ForKey:@"name"];
    }
    [self.mapView removeAnnotation:self.pointAnnotation];
    self.pointAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:self.pointAnnotation];
}
#pragma mark-MAMapViewDelegate 标记样式
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"selectPoint";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        return annotationView;
    }
    return nil;
}
//MARK:选择品类
- (void)selectPinLei{
    if (self.pinleiDatas ==nil) {
        self.pinleiDatas = [NSMutableArray array];
    }
    if (self.pinleiDatas.count==0) {
        [self loadPinLeiDatas];
    }
    else{
        TTNormalPickerView *pickerView = [[TTNormalPickerView alloc] init];
        [pickerView showWithItems:self.pinleiDatas SelectedIndex:0 Handler:^(TTNormalPickerItem *item) {
            self.pinleiItem = item;
            self.pinleiTF.text = item.item_name;
        }];
    }
}
//MARK:获取品类数据
- (void)loadPinLeiDatas{
    [ProgressHUD show:nil Interaction:NO];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [TTRequestOperationManager GET:API_GET_SHOP_CATEGORY Parameters:para Success:^(NSDictionary *responseJsonObject) {
        [ProgressHUD dismiss];
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSArray *result = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"]&&result.count>0) {
            for (NSDictionary *dic in result) {
                TTNormalPickerItem *item = [[TTNormalPickerItem alloc] init];
                item.item_name = [dic string_ForKey:@"name"];
                item.item_id = [dic string_ForKey:@"id"];
                [self.pinleiDatas addObject:item];
            }
            [self selectPinLei];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
    }];
}
//MARK:保存店铺信息
- (IBAction)save:(id)sender {
    [self presentAlertWithTitle:@"确认提交？" Handler:^{
        [self saveNow];
    } Cancel:nil];
    
}
- (void)saveNow{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    //积分比例
    if (self.pointsPercentItem.item_id.intValue !=self.shopInfo.integral_ratio.intValue &&self.pointsPercentItem.item_id.intValue>0) {
        [para setObject:self.pointsPercentItem.item_id forKey:@"integral_ratio"];
    }
    //积分使用说明
    if (![self.pointsUseDesTV.text.absolute_String isEqualToString:self.shopInfo.use_range.absolute_String]&&self.pointsUseDesTV.text.absolute_String.length>1) {
        [para setObject:self.pointsUseDesTV.text.killEmoji forKey:@"use_range"];
    }
    //电话
    if (![self.phoneTF.text.absolute_String isEqualToString:self.shopInfo.shop_phone.absolute_String]&&self.phoneTF.text.absolute_String.length>1) {
        [para setObject:self.phoneTF.text forKey:@"shop_phone"];
    }
    //地区
    if (self.areaObj!=nil) {
        [para setObject:self.areaObj.provinceID forKey:@"province_id"];
        [para setObject:self.areaObj.cityID forKey:@"city_id"];
        [para setObject:self.areaObj.districtID forKey:@"area_id"];
        [para setObject:self.areaObj.provinceName forKey:@"province_name"];
        [para setObject:self.areaObj.cityName forKey:@"city_name"];
        [para setObject:self.areaObj.districtName forKey:@"area_name"];
    }
    //详细地址
    if (self.addressTF.text.absolute_String.length>0&&![self.addressTF.text.absolute_String isEqualToString:self.shopInfo.address.absolute_String]) {
        [para setObject:self.addressTF.text.killEmoji forKey:@"address"];
    }
    //经纬度
    if (self.pointAnnotation !=nil&&self.pointAnnotation.coordinate.latitude!=self.shopInfo.latitude.doubleValue) {
        [para setObject:[NSNumber numberWithDouble:self.pointAnnotation.coordinate.longitude] forKey:@"longitude"];
        [para setObject:[NSNumber numberWithDouble:self.pointAnnotation.coordinate.latitude] forKey:@"latitude"];
    }
    //品类
    if (self.pinleiItem !=nil&&![self.shopInfo.type isEqualToString:self.pinleiItem.item_id]) {
        [para setObject:self.pinleiItem.item_id forKey:@"type"];
        [para setObject:self.pinleiItem.item_name forKey:@"type_text"];
    }
    //营业时间
    if (self.openTimeTF.text.absolute_String.length>0&&![self.openTimeTF.text.absolute_String isEqualToString:self.shopInfo.business_hours.absolute_String]) {
        [para setObject:self.openTimeTF.text.killEmoji forKey:@"business_hours"];
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_UPLOAD_INFORMATION_OTHER Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"200"]){
            [ProgressHUD showSuccess:msg Interaction:NO];
            //提交成功之后，会获取state，该state等效于登录接口中的state
//            NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:[TTUserInfoManager userInfo]];
//            [userinfo setObject:@"1" forKey:@"state"];
//            [TTUserInfoManager setUserInfo:userinfo];
            [self performSelector:@selector(successBack) withObject:nil afterDelay:1.2];
        }
        else{
            [ProgressHUD showError:msg];
        }
        
    } Failure:^(NSError *error) {
        
    }];
    
}
- (void)successBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
