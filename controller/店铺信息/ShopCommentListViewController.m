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
#import "ImageBrowserVC.h"

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
        [self loadCommentListData];
        [self loadCommentScore];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page = self.page + 1;
        [self loadCommentListData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
//MARK:获取评论列表记录
- (void)loadCommentListData{
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
//MARK:获取评论评分
- (void)loadCommentScore{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[[TTUserInfoManager userInfo] string_ForKey:@"id"] forKey:@"seller_id"];
    [TTRequestOperationManager POST:API_SHOP_COMMENTS_TRIBLE_SCORE Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        if ([code isEqualToString:@"200"]) {
            float fuwuPoints = [[result string_ForKey:@"server_average"] floatValue];
            float chanpinPoints = [[result string_ForKey:@"product_average"] floatValue];
            float huanjingPoints = [[result string_ForKey:@"milieu_average"] floatValue];
            self.fuwuPointsLabel.text = [NSString stringWithFormat:@"%.1f分",fuwuPoints];
            self.chanpinPointsLabel.text = [NSString stringWithFormat:@"%.1f分",chanpinPoints];
            self.huanjingPointsLabel.text = [NSString stringWithFormat:@"%.1f分",huanjingPoints];
            [self updateStarOnStarView:self.fuwuView withScore:fuwuPoints];
            [self updateStarOnStarView:self.chanpinView withScore:chanpinPoints];
            [self updateStarOnStarView:self.huanjingView withScore:huanjingPoints];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
    }];
}
- (void)updateStarOnStarView :(UIView *)starView withScore:(float)score{
    for (int index =0;index<5;index++) {
        UIImageView *starIV = [starView viewWithTag:100+index];
        if (index+1 <= score){
            starIV.image = [UIImage imageNamed:@"xiaolian_huang"];
        }
        else{
            starIV.image = [UIImage imageNamed:@"xiaolian_hui"];
        }
    }

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
        return 90 + SCREEN_WIDTH * 0.2 + [obj.comment heightWithFont:[UIFont systemFontOfSize:14] Width:SCREEN_WIDTH - 10*2];
    }
    //不包含图片，只有文字
    else{
        return 90 + [obj.comment heightWithFont:[UIFont systemFontOfSize:14] Width:SCREEN_WIDTH - 10*2];
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
    TTCommentObj *obj = (TTCommentObj *)[self.datas objectAtIndex:indexPath.row];
    //包含图片
    if (obj.images.count>0) {
        ImageBrowserVC *vc = [[ImageBrowserVC alloc] initWithLinks:obj.images CurrentIndex:0];
        [vc show];
    }
}
@end
