//
//  FAQViewController.m
//  PointsForShop
//
//  Created by 殷玉秋 on 2017/12/7.
//  Copyright © 2017年 Heizi. All rights reserved.
//

#import "FAQViewController.h"
#import "TTFAQObj.h"
#import "FAQIssueTableViewCell.h"
#import "FAQAnswerTableViewCell.h"

@interface FAQViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datas;//数据

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    [self configTableView];
    [self loadData];
}
- (void)configTableView{
    self.datas = [NSMutableArray arrayWithCapacity:1];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
}
#pragma mark-获取记录
- (void)loadData{
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [TTRequestOperationManager POST:API_USER_FAQ_LIST Parameters:para Success:^(NSDictionary *responseJsonObject) {
        [self.tableView.mj_header endRefreshing];
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSArray *items = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"200"]){
            [self.datas removeAllObjects];
            for (NSDictionary *dic in items) {
                TTFAQObj *obj = [[TTFAQObj alloc] initWithDic:dic];
                [self.datas addObject:obj];
            }
            [self.tableView reloadData];
        }
        else{
            [ProgressHUD showError:msg Interaction:NO];
        }
    } Failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark-UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFAQObj *obj = (TTFAQObj *)[self.datas objectAtIndex:indexPath.section];
    if (indexPath.row ==0) {
        //问题
        FAQIssueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"issue"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FAQIssueTableViewCell" owner:self options:nil][0];
        }
        [cell data:obj];
        return cell;
    }
    else{
        FAQAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answer"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"FAQAnswerTableViewCell" owner:self options:nil][0];
        }
        [cell data:obj];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTFAQObj *obj = (TTFAQObj *)[self.datas objectAtIndex:indexPath.section];
    if (indexPath.row == 0){
        float height = [obj.issue heightWithFont:[UIFont systemFontOfSize:15] Width:SCREEN_WIDTH -50] + 20;
        return MAX(50, height);
    }
    else{
        float height = [obj.answer heightWithFont:[UIFont systemFontOfSize:15] Width:SCREEN_WIDTH -20] + 20;
        return MAX(50, height);
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TTFAQObj *obj = (TTFAQObj *)[self.datas objectAtIndex:section];
    if (obj.isOpen == YES){
        return 2;
    }
    else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datas.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTFAQObj *obj = (TTFAQObj *)[self.datas objectAtIndex:indexPath.section];
    obj.isOpen = !obj.isOpen;
    [self.tableView reloadData];
}
@end
