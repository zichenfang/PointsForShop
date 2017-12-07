//
//  RechargeHistoryViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "RechargeHistoryViewController.h"
#import "RechargeHistoryTableViewCell.h"
#import "TTPointsHistoryObj.h"
#import "TTNullDataTableViewCell.h"

@interface RechargeHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;//数据
@property (assign, nonatomic) int page;
@end

@implementation RechargeHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    [self configTableView];
}

#pragma mark-configTableViewI
- (void)configTableView{
    self.datas = [NSMutableArray arrayWithCapacity:1];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self.datas removeAllObjects];
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = self.page + 1;
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark-获取记录
- (void)loadData{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:pageSize forKey:@"pagesize"];
    [para setObject:[NSNumber numberWithInt:self.page] forKey:@"p"];
    //    类型：1收入，2支出 3充值，4提现 5 退款支出 6.退款收入
    [para setObject:@"4" forKey:@"type"];
    [TTRequestOperationManager POST:API_USER_POINTS_HISTORY Parameters:para Success:^(NSDictionary *responseJsonObject) {
        if (self.page == 1) {
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSArray *items = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"])//
        {
            for (NSDictionary *dic in items) {
                TTPointsHistoryObj *obj = [[TTPointsHistoryObj alloc] initWithDic:dic];
                [self.datas addObject:obj];
            }
            if (self.datas.count < [pageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.datas.count == 0) {
                TTPointsHistoryObj *obj = [[TTPointsHistoryObj alloc] initWithNullDataMsg:@"亲，暂无数据～"];
                [self.datas addObject:obj];
            }
            [self.tableView reloadData];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        if (self.page == 1) {
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}
#pragma mark-UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTPointsHistoryObj *historyObj = (TTPointsHistoryObj *)[self.datas objectAtIndex:indexPath.row];
    if (historyObj.isNullData == YES) {
        TTNullDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nulldata"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TTNullDataTableViewCell" owner:self options:nil][0];
            [cell msg:historyObj.nullDataMsg];
        }
        return cell;
    }
    else{
        RechargeHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"points"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RechargeHistoryTableViewCell" owner:self options:nil][0];
        }
        [cell data:historyObj];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTPointsHistoryObj *historyObj = (TTPointsHistoryObj *)[self.datas objectAtIndex:indexPath.row];
    if (historyObj.isNullData == YES) {
        return SCREEN_HEIGHT - 64 - 50;
    }
    else{
        return 70;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
