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
#import "LoginViewController.h"

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
    self.menus =@[@"店铺维护",@"积分记录",@"提现申请",@"充值",@"买单",@"设置",@"查看店铺",@"退出登录"];
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
    float itemWidth =(SCREEN_WIDTH-2)/3;
    return CGSizeMake(itemWidth, itemWidth*1.12);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 225) ;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.menus[indexPath.row];
    if ([title isEqualToString:@"店铺维护"]) {
        
    }
    else if ([title isEqualToString:@"积分纪录"]){}
    else if ([title isEqualToString:@"提现申请"]){}
    else if ([title isEqualToString:@"充值"]){}
    else if ([title isEqualToString:@"买单"]){}
    else if ([title isEqualToString:@"设置"]){}
    else if ([title isEqualToString:@"查看店铺"]){}
    else if ([title isEqualToString:@"退出登录"]){
        [self presentAlertWithTitle:@"退出登录" Handler:^{
            [self loginOut];
        } Cancel:nil];
    }

    NSLog(@"%@",title);
}
//MARK:用户资料
- (void)goUserInfo{
    NSLog(@"用户资料");
}
//MARK:退出登录
- (void)loginOut{
    [TTUserInfoManager setLogined:NO];
    [TTUserInfoManager setUserInfo:@{}];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UIWindow *keyWindow =[[UIApplication sharedApplication] delegate].window;
    [UIView transitionWithView:keyWindow duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];;
    } completion:nil];
}
@end
