//
//  ShopPreviewViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopPreviewViewController.h"
#import "ShopDetailSingleTextTableViewCell.h"
#import "ShopDetailSingleImageTableViewCell.h"
#import "ImageBrowserVC.h"
#import "ShopCommentListViewController.h"

@interface ShopPreviewViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet SDCycleScrollView *bannerScrollView;
 //标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
 //内容
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
//比例
@property (strong, nonatomic) IBOutlet UILabel *pointScaleLabel;
//评分
@property (strong, nonatomic) IBOutlet UILabel *kdaLabel;
//评论数目
@property (strong, nonatomic) IBOutlet UIButton *commentCountBtn;
//地址
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
//营业时间
@property (strong, nonatomic) IBOutlet UILabel *timeDesLabel;
//使用范围
@property (strong, nonatomic) IBOutlet UITextView *shiyongDesTV;
//营业执照
@property (strong, nonatomic) IBOutlet UIImageView *zhizhaoIV;
//经营许可证
@property (strong, nonatomic) IBOutlet UIImageView *xukezhengIV;
//小星星的父视图，用来批量处理小星星
@property (strong, nonatomic) IBOutlet UIView *subContentView;
//用来适配中间标题+简介view模块的高度，没有用autolayout是因为它报错了
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleViewConstraint;
//店铺信息（这里不作解析成model了，因为就这一个地方用）
@property (strong, nonatomic) NSDictionary *shopInfo;
//店铺信息三个描述
@property (strong, nonatomic) NSMutableArray *deses;
//店铺信息三个产品图片
@property (strong, nonatomic) NSMutableArray *bannerImages;
@end

@implementation ShopPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    [self richBannerScrollView];
    [self loadShopInfo];
}
//    MARK:配置轮播图和数据容器
- (void)richBannerScrollView{
    self.bannerScrollView.delegate = self;
    self.bannerScrollView.backgroundColor = [UIColor whiteColor];
    self.bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.bannerScrollView.currentPageDotColor = [UIColor stylePinkColor]; // 自定义分页控件小圆标颜色
    self.bannerScrollView.pageDotColor = [UIColor darkGrayColor]; //
    self.bannerScrollView.autoScrollTimeInterval = 4.0;
    self.bannerScrollView.pageControlBottomOffset = 10;
    self.bannerScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    self.bannerImages = [NSMutableArray array];
    self.deses = [NSMutableArray array];

}
//    MARK:获取店铺详情数据（使用用户端接口获取）
- (void)loadShopInfo{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[[TTUserInfoManager userInfo] string_ForKey:@"id"] forKey:@"seller_id"];
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_SHOP_SHOPS_DETAIL Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            self.shopInfo = result;
            //轮播图数据
            [self.bannerImages addObject:[self.shopInfo string_ForKey:@"image"]];
            [self.bannerImages addObject:[self.shopInfo string_ForKey:@"image2"]];
            [self.bannerImages addObject:[self.shopInfo string_ForKey:@"image3"]];
            //店铺介绍文字数据
            [self.deses addObject:[self.shopInfo string_ForKey:@"desc"]];
            [self.deses addObject:[self.shopInfo string_ForKey:@"desc2"]];
            [self.deses addObject:[self.shopInfo string_ForKey:@"desc3"]];
            [self updateHeaderUIData];
            [ProgressHUD dismiss];
        }
        else{
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
    }];
}
//    MARK:更新头部数据（除图文以外的数据）
-(void)updateHeaderUIData{
    self.bannerScrollView.imageURLStringsGroup = self.bannerImages;
    //headerView高度
    self.titleLabel.text = [self.shopInfo string_ForKey:@"name"];
    NSString *introduction = [self.shopInfo string_ForKey:@"introduction"];
    self.contentLabel.text = introduction;
    float bannerHeight = SCREEN_WIDTH*7/15;
    //标题和描述view的高度
    float titleViewHeight =[introduction heightWithFont:self.contentLabel.font Width:SCREEN_WIDTH -10*2] +40;
    self.titleViewConstraint.constant = titleViewHeight;
    //积分、电话等内容的高度
    float subContentheight = 350;
    UIView *tableHeaderView =self.tableView.tableHeaderView;
    tableHeaderView.frame = CGRectMake( 0,  0,  SCREEN_WIDTH,  bannerHeight + titleViewHeight + subContentheight);
    self.tableView.tableHeaderView = tableHeaderView;
    NSString *integral_ratio = [self.shopInfo string_ForKey:@"integral_ratio"];
    self.pointScaleLabel.text = [NSString stringWithFormat:@"积分比例：%@ %%",integral_ratio];

    NSString *ave_score =[self.shopInfo string_ForKey:@"ave_score"];
    int  starValue = [ave_score intValue];
    for (int index =0;index<4;index++) {
        UIImageView *starIV = [self.subContentView viewWithTag:100+index];
        if (index+1 <= starValue){
            starIV.image = [UIImage imageNamed:@"xingxing_liang"];
        }
        else{
            starIV.image = [UIImage imageNamed:@"xingxing_an"];
        }
    }
    self.kdaLabel.text = [NSString stringWithFormat:@"%@分",ave_score];
    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%@ 评价",[self.shopInfo string_ForKey:@"comment_num"]] forState:UIControlStateNormal];
    self.addressLabel.text = [self.shopInfo string_ForKey:@"address"];
    //营业时间和使用范围
    self.timeDesLabel.text = [self.shopInfo string_ForKey:@"business_hours"];
    self.shiyongDesTV.text = [self.shopInfo string_ForKey:@"use_range"];
    //营业执照和经营许可证
    [self.zhizhaoIV sd_setImageWithURL:[NSURL URLWithString:[self.shopInfo string_ForKey:@"business_license"]] placeholderImage:PLACEHOLDER_GENERAL];
    [self.xukezhengIV sd_setImageWithURL:[NSURL URLWithString:[self.shopInfo string_ForKey:@"business_permit"]] placeholderImage:PLACEHOLDER_GENERAL];
    UIView *tableFooterView =self.tableView.tableFooterView;
    self.tableView.tableFooterView.frame = CGRectMake( 0,  0,  SCREEN_WIDTH,  SCREEN_WIDTH*1.54);
    self.tableView.tableFooterView = tableFooterView;
    [self.tableView reloadData];
}
////    MARK: 进入评论列表
- (IBAction)goCommentList:(id)sender{
    ShopCommentListViewController *vc = [[ShopCommentListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//@IBAction func goCommentList(_ sender: Any) {
//    let vc = CommentListViewController()
//    vc.shopObj = shopDetailObj;
//    self.navigationController?.pushViewController(vc, animated: true)
//}
//    MARK: 打电话
- (IBAction)callToShop:(id)sender{
    NSString *mobile = [self.shopInfo string_ForKey:@"mobile"];
    NSString *tel = [NSString stringWithFormat:@"tel://%@",mobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

////    MARK: 地址导航
- (IBAction)goMap:(id)sender{}
//@IBAction func goMap(_ sender: Any) {
//    let loc = CLLocationCoordinate2D.init(latitude: shopDetailObj.latitude!, longitude: shopDetailObj.longitude!);
//    //检测地图app安装情况
//    let alertC = UIAlertController.init(title: "选择", message: nil, preferredStyle: UIAlertControllerStyle.alert);
//    //自带apple地图
//    alertC.addAction(UIAlertAction.init(title: "Apple地图", style: UIAlertActionStyle.default, handler: { (act) in
//        let currentMapItem = MKMapItem.forCurrentLocation();
//        let toMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: loc, addressDictionary: nil));
//        MKMapItem.openMaps(with: [currentMapItem,toMapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey:NSNumber.init(value: true)]);
//    }));
//    if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://")!) {
//        //高德地图
//        alertC.addAction(UIAlertAction.init(title: "高德地图", style: UIAlertActionStyle.default, handler: { (act) in
//            let urlStr = String.init(format: "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2","积分购","pointsbuy", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
//            } else {
//                UIApplication.shared.openURL(URL.init(string: urlStr!)!);
//            }
//        }));
//    }
//    if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://")!) {
//        //百度地图
//        alertC.addAction(UIAlertAction.init(title: "百度地图", style: UIAlertActionStyle.default, handler: { (act) in
//            let urlStr = String.init(format: "baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
//            } else {
//                UIApplication.shared.openURL(URL.init(string: urlStr!)!);
//            }
//        }));
//    }
//    if UIApplication.shared.canOpenURL(URL.init(string: "comgooglemaps://")!) {
//        //谷歌地图
//        alertC.addAction(UIAlertAction.init(title: "Google地图", style: UIAlertActionStyle.default, handler: { (act) in
//            let urlStr = String.init(format: "comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving","积分购","pointsbuy", loc.latitude,loc.longitude).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed);
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL.init(string: urlStr!)!, options: [:], completionHandler: nil);
//            } else {
//                UIApplication.shared.openURL(URL.init(string: urlStr!)!);
//            }
//        }));
//    }
//
//    alertC.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: nil));
//    self.present(alertC, animated: true, completion: nil);
//}


// MARK:UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.shopInfo ==nil) {
        return 0;
    }
    else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 )/*图片*/{
        ShopDetailSingleImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"image"];
        if (cell ==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ShopDetailSingleImageTableViewCell" owner:nil options:nil][0];
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.bannerImages[indexPath.section]] placeholderImage:PLACEHOLDER_GENERAL];
        return cell;
    }
    else /*文字*/ {
        ShopDetailSingleTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text"];
        if (cell ==nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"ShopDetailSingleTextTableViewCell" owner:nil options:nil][0];
        }
        cell.contentLabel.text = self.deses[indexPath.section];
        return cell;
    }

}
//MARK:UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.shopInfo ==nil) {
        return 0;
    }
    else{
        return MIN(self.bannerImages.count, self.deses.count);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 )/*图片高度*/{
        return SCREEN_WIDTH * 0.8;
    }
    else/*文字高度*/{
        NSString *des =self.deses[indexPath.section];
        return [des heightWithFont:[UIFont systemFontOfSize:15] Width: SCREEN_WIDTH - 10*2] +5;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ImageBrowserVC *vc = [[ImageBrowserVC alloc] initWithLinks:self.bannerImages CurrentIndex:indexPath.row];
        [vc show];
    }
}

// MARK: - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    ImageBrowserVC *vc = [[ImageBrowserVC alloc] initWithLinks:self.bannerImages CurrentIndex:index];
    [vc show];
}
@end
