//
//  ShopCommentListViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/8.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "ShopCommentListViewController.h"
#import "CommentTableViewCell.h"
#import "TTCommentObj.h"

@interface ShopCommentListViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic,strong) IBOutlet UITableView *tableView;
//服务
@property (nonatomic,strong) IBOutlet UIView *fuwuView;

@property (nonatomic,strong) IBOutlet UILabel *fuwuPointsLabel;
//产品
@property (nonatomic,strong) IBOutlet UIView *chanpinView;
@property (nonatomic,strong) IBOutlet UILabel *chanpinPointsLabel;
@property (nonatomic,strong) IBOutlet UIView *huanjingView;
@property (nonatomic,strong) IBOutlet UILabel *huanjingPointsLabel;

@property (strong, nonatomic) NSMutableArray *datas;//数据
@property (assign, nonatomic) int page;
@end

@implementation ShopCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self configTableView];
}

#pragma mark-configTableViewI
- (void)configTableView{
    self.datas = [NSMutableArray arrayWithCapacity:1];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
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
    [para setObject:[[TTUserInfoManager userInfo] string_ForKey:@"id"] forKey:@"seller_id"];
    [para setObject:pageSize forKey:@"pagesize"];
    [para setObject:[NSNumber numberWithInt:self.page] forKey:@"p"];
    //    类型：1收入，2支出 3充值，4提现 5 退款支出 6.退款收入
    [para setObject:@"4" forKey:@"type"];
    [TTRequestOperationManager POST:API_SHOP_COMMENTS Parameters:para Success:^(NSDictionary *responseJsonObject) {
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
            if (self.page ==1) {
                [self.datas removeAllObjects];
            }
            for (NSDictionary *dic in items) {
                TTCommentObj *obj = [[TTCommentObj alloc] initWithDic:dic];
                [self.datas addObject:obj];
            }
            if (self.datas.count < [pageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    TTCommentObj *obj = (TTCommentObj *)[self.datas objectAtIndex:indexPath.row];
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil][0];
    }
    [cell data:obj];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTCommentObj *obj = (TTCommentObj *)[self.datas objectAtIndex:indexPath.row];
    //包含图片
    if (obj.images.count>0) {
        return 74 + SCREEN_WIDTH * 0.2 + [obj.comment heightWithFont:[UIFont systemFontOfSize:14] Width:SCREEN_WIDTH - 10*2];
    }
    //不包含图片，只有文字
    else{
        return 74 + [obj.comment heightWithFont:[UIFont systemFontOfSize:14] Width:SCREEN_WIDTH - 10*2];
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
