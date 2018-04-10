//
//  SettingViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/1.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "SettingViewController.h"
#import "SetTakeCashAccountViewController.h"
#import "SetPayPasswordViewController.h"
#import "SetLoginPasswordViewController.h"
#import "SettingTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menus;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.menus = @[@"设置提现密码",@"设置提现账号",@"修改登录密码"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"setting"];
}

#pragma mark-UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    NSString *menu = self.menus[indexPath.row];
    cell.nameLabel.text =menu;
    cell.iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"setting_%@",menu]];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menus.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            SetPayPasswordViewController *vc = [[SetPayPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            SetTakeCashAccountViewController *vc = [[SetTakeCashAccountViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            SetLoginPasswordViewController *vc = [[SetLoginPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
