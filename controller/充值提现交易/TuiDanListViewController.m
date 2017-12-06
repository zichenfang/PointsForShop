//
//  RechargeHistoryViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/4.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "TuiDanListViewController.h"
#import "TuiDanTableViewCell.h"
#import "TTTuiDanObj.h"
#import "TTNullDataTableViewCell.h"

/*存放消费类型、列表数据、分页页码的object*/
@interface OrderContainerObj :NSObject
@property (nonatomic,strong)NSString *orderType;//订单分类标示
@property (nonatomic,strong)NSString *orderTypeName;//订单分类名称
@property (nonatomic,strong)NSMutableArray *datas;//订单列表
@property (nonatomic,assign)int page;//订单分页页码
@property (nonatomic,assign)BOOL hasMore;//是否还有更多

@end
@implementation OrderContainerObj
- (instancetype)initWithType :(NSString *)type
{
    self = [super init];
    if (self) {
        self.orderType = type;
        self.datas = [NSMutableArray array];
        self.page = 1;
        self.hasMore = YES;
    }
    return self;
}
@end


@interface TuiDanListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *segView;
@property (strong, nonatomic) IBOutlet UIView *flagView;
@property (nonatomic,strong)NSArray *containerDatas;//二维数组
@end

@implementation TuiDanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费积分";
    [self configTableView];
}
#pragma mark-configTableViewI
- (void)configTableView{
    [self updateTypeUI];
    //数据容器 2-冻结中 3-退款中 5-已完成  9-已退款
    self.containerDatas = @[[[OrderContainerObj alloc] initWithType:@"2"],
                   [[OrderContainerObj alloc] initWithType:@"3"],
                   [[OrderContainerObj alloc] initWithType:@"9"],
                   [[OrderContainerObj alloc] initWithType:@"5"]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
        container.page = container.page + 1;
        [self loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)refreshData{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    //数据容器，包含hasmore ,page ,list
    container.hasMore =YES;
    container.page = 1;
    [container.datas removeAllObjects];
    [self loadData];
}
//MARK:分类
- (IBAction)switchType:(UIButton *)sender {
    if (sender.selected ==YES) {
        return;
    }
    self.typeSelectedIndex = sender.tag -100;
    [self updateTypeUI];
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    [self.tableView reloadData];
    if (container.datas.count<=0) {
        [self.tableView.mj_header beginRefreshing];
    }
    else{
        [self.tableView reloadData];
    }
}
//MARK:更新选中的按钮以及游标的位置
- (void)updateTypeUI{
    for (int i=0; i<4; i++) {
        UIButton *btn =[self.segView viewWithTag:100+i];
        if (i==self.typeSelectedIndex) {
            btn.selected = YES;
            float btnWidth =300/4;
            [UIView animateWithDuration:0.2 animations:^{
                self.flagView.frame = CGRectMake(i*btnWidth, self.flagView.frame.origin.y, btnWidth, self.flagView.frame.size.height);
            }];
        }
        else{
            btn.selected = NO;
        }
    }
}

#pragma mark-获取记录
- (void)loadData{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:pageSize forKey:@"pagesize"];
    [para setObject:[NSNumber numberWithInt:container.page] forKey:@"p"];
    // 2-冻结中 3-退款中 5-已完成  9-已退款
    if (container.orderType) {
        [para setObject:container.orderType forKey:@"state"];
    }
    [TTRequestOperationManager POST:API_USER_POINTS_TUIDAN_HISTORY Parameters:para Success:^(NSDictionary *responseJsonObject) {
        if (container.page == 1) {
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        NSArray *items = [result array_ForKey:@"items"];
        if ([code isEqualToString:@"200"])//
        {
            for (NSDictionary *dic in items) {
                TTTuiDanObj *obj = [[TTTuiDanObj alloc] initWithDic:dic];
                [container.datas addObject:obj];
            }
            if (container.datas.count < [pageSize integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                container.hasMore = NO;
            }
            if (container.datas.count == 0) {
                TTTuiDanObj *obj = [[TTTuiDanObj alloc] initWithNullDataMsg:@"亲，暂无数据～"];
                [container.datas addObject:obj];
            }
            [self.tableView reloadData];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        if (container.page == 1) {
            [self.tableView.mj_header endRefreshing];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark-UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    TTTuiDanObj *historyObj = (TTTuiDanObj *)[container.datas objectAtIndex:indexPath.row];
    if (historyObj.isNullData == YES) {
        TTNullDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nulldata"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TTNullDataTableViewCell" owner:self options:nil][0];
            [cell msg:historyObj.nullDataMsg];
        }
        return cell;
    }
    else{
        TuiDanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"points"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"RechargeHistoryTableViewCell" owner:self options:nil][0];
            [cell.agreeBtn addTarget:self action:@selector(agreeTuiDan:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.agreeBtn.tag = indexPath.row;
        [cell data:historyObj];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    TTTuiDanObj *historyObj = (TTTuiDanObj *)[container.datas objectAtIndex:indexPath.row];
    if (historyObj.isNullData == YES) {
        return SCREEN_HEIGHT - 64 - 50;
    }
    else{
        return 70;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    return container.datas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//MARK:退单
- (void)agreeTuiDan :(UIButton*)sender{
    OrderContainerObj *container = self.containerDatas[self.typeSelectedIndex];
    TTTuiDanObj *historyObj = (TTTuiDanObj *)[container.datas objectAtIndex:sender.tag];
    [self presentDestructiveAlertWithTitle:@"是否同意退单?" Handler:^{
        [self requesAagreeTuiDan:historyObj];
    }];
}
- (void)requesAagreeTuiDan :(TTTuiDanObj *)historyObj{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    if (historyObj.order_id) {
        [para setObject:historyObj.order_id forKey:@"order_id"];//
    }
    [ProgressHUD show:nil Interaction:NO];
    [TTRequestOperationManager POST:API_USER_AGREE_TUIDAN Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        if ([code isEqualToString:@"1"])//
        {
            [ProgressHUD showSuccess:msg Interaction:NO];
            [self performSelector:@selector(refreshData) withObject:nil afterDelay:1.2];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
    }];
}

@end


