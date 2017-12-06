//
//  MainMenuViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/11/13.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UserHeaderCollectionReusableView.h"
#import "UserCenterCollectionViewCell.h"
#import "ShopInfoViewController.h"
#import "TakeCashViewController.h"
#import "PoinstHistoryListViewController.h"
#import "RechargeViewController.h"
#import "DealViewController.h"
#import "SettingViewController.h"
#import "SetTakeCashAccountViewController.h"
#import "SetPayPasswordViewController.h"
#import "TuiDanListViewController.h"

@interface MainMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *cv;
@property (nonatomic,strong)NSArray *menus;//数组

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self prepareCV];
}
- (void)prepareCV{
    self.menus =@[@"店铺维护",@"积分记录",@"提现申请",@"充值",@"买单",@"设置",@"查看店铺",@"退单",@"联系我们"];
    UINib *nibHeader = [UINib nibWithNibName:@"UserHeaderCollectionReusableView" bundle:nil];
    [self.cv registerNib:nibHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"home"];
    
    UINib *nib = [UINib nibWithNibName:@"UserCenterCollectionViewCell" bundle:nil];
    [self.cv registerNib:nib forCellWithReuseIdentifier:@"home"];
}
- (void)updateUI{
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark -collectionview
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menus.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"home";
    UserCenterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *title = self.menus[indexPath.row];
    cell.iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercenter_%@",title]];
    cell.nameLabel.text = title;
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UserHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"home" forIndexPath:indexPath];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUserInfo)];
    [headerView.whiteBackView addGestureRecognizer:tap];
    //
    headerView.shopNameLabel.text = [[TTUserInfoManager userInfo] string_ForKey:@"name"];
    NSString *avatarUrl = [[TTUserInfoManager userInfo] string_ForKey:@"avatar"];
    [headerView.avatarIV sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:PLACEHOLDER_USER];
    return headerView;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float itemWidth =(SCREEN_WIDTH-3)/3;
    return CGSizeMake(itemWidth, itemWidth*1.12);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 225) ;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.menus[indexPath.row];
//    商户状态:0禁用 1审核中 2审核通过9注册未填写信息
    NSInteger state =[[[TTUserInfoManager userInfo] string_ForKey:@"state"] integerValue];
//    state =9;
    NSArray *disabledMenus= @[@"积分记录",@"提现申请",@"充值",@"买单",@"查看店铺"];//禁用掉的菜单
    NSString *errMsg =@"";//禁用弹窗描述
    if (state ==0) {
        errMsg = @"当前账户已被禁用";
        disabledMenus= @[@"店铺维护",@"积分记录",@"提现申请",@"充值",@"买单",@"查看店铺"];
    }
    else if (state ==1){
        errMsg = @"店铺信息审核中";
    }
    else if (state ==9){
        errMsg = @"店铺信息不完整，前往店铺维护中完善信息";
    }
    else if (state ==2){
        disabledMenus =@[];
    }
//    //在禁用菜单当中
//    if ([disabledMenus indexOfObject:title]!=NSNotFound) {
//        if (state ==9) {
//            //信息不完整，则弹出alert，提示进入设置信息维护页面
//            [self presentAlertWithTitle:errMsg Handler:^{
//                [self goUserInfo];
//            } Cancel:nil];
//        }
//        else{
//            //信息不完整，则弹出alert
//            [self presentToastAlertWithTitle:errMsg Handler:nil];
//        }
//        return;
//    }
    if ([title isEqualToString:@"店铺维护"]) {
        [self goUserInfo];
    }
    else if ([title isEqualToString:@"积分记录"]){
        [self goPointsHistory];
    }
    else if ([title isEqualToString:@"提现申请"]){
        [self takeCash];
    }
    else if ([title isEqualToString:@"充值"]){
        [self recharge];
    }
    else if ([title isEqualToString:@"买单"]){
        [self deal];
    }
    else if ([title isEqualToString:@"设置"]){
        [self goSetting];
    }
    else if ([title isEqualToString:@"查看店铺"]){}
    else if ([title isEqualToString:@"退单"]){
        [self goTuiDan];
    }
    else if ([title isEqualToString:@"联系我们"]){
    }
    NSLog(@"%@",title);
}
//MARK:店铺维护 用户资料
- (void)goUserInfo{
    ShopInfoViewController *vc = [[ShopInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:积分纪录
- (void)goPointsHistory{
    PoinstHistoryListViewController *vc = [[PoinstHistoryListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:提现
- (void)takeCash{
    //检测是否设置过支付账号，没有的话则进入支付账号设置页面
    if ([[TTUserInfoManager userInfo] string_ForKey:@"withdraw_password"].length<=4) {
        [self presentAlertWithTitle:@"您尚未设置支付密码" Handler:^{
            [self goSettingPayPassword];
        } Cancel:^{
        }];
    }
    //检查是否有设置过支付密码，没有则进入支付密码设置界面
    else if ([[TTUserInfoManager userInfo] string_ForKey:@"withdraw_account"].length<=4) {
        [self presentAlertWithTitle:@"您尚未设置提现账号" Handler:^{
            [self goSettingPayAccount];
        } Cancel:^{
        }];
    }
    else{
        TakeCashViewController *vc = [[TakeCashViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//MARK:积分充值
- (void)recharge{
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goSettingPayAccount{
    SetTakeCashAccountViewController *vc = [[SetTakeCashAccountViewController alloc] init];
    vc.hidesBottomBarWhenPushed  =NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)goSettingPayPassword{
    SetPayPasswordViewController *vc = [[SetPayPasswordViewController alloc] init];
    vc.hidesBottomBarWhenPushed  =NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
//MARK:买单
- (void)deal{
    DealViewController *vc = [[DealViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:设置
- (void)goSetting{
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//MARK:退单
- (void)goTuiDan{
    TuiDanListViewController *vc = [[TuiDanListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
