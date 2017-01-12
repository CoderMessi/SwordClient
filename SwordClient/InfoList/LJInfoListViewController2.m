//
//  LJInfoListViewController2.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/10.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoListViewController2.h"
#import "LJInfoDetailViewController.h"
#import "LJInfo2TableViewCell.h"
#import <UMMobClick/MobClick.h>

@interface LJInfoListViewController2 ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) int hasMoreData;

@end

@implementation LJInfoListViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBGColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.navigationController.navigationBar.translucent=NO;
    
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    
    [self.view addSubview:self.listView];
    [self requestData];
    
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


- (void)requestData {
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    SMUserModel *user = [SMUserModel getUserData];
    self.page = 1;
    NSDictionary *param = @{@"uid" : [NSNumber numberWithInteger:user.userId],
                            @"page" : [NSNumber numberWithInteger:self.page],
                            @"num" : @"15",
                            @"show_type" : @"2"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_header endRefreshing];
            self.hasMoreData = [[responseObject objectForKey:@"hasnext"] intValue];
            if (self.hasMoreData == 0) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadMoreData {
    SMUserModel *user = [SMUserModel getUserData];
    self.page++;
    NSDictionary *param = @{@"uid" : [NSNumber numberWithInteger:user.userId],
                            @"page" : [NSNumber numberWithInteger:self.page],
                            @"num" : @"15",
                            @"show_type" : @"2"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self.dataArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_footer endRefreshing];
            self.hasMoreData = [[responseObject objectForKey:@"hasnext"] intValue];
            if (self.hasMoreData == 0) {
                [self.listView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideMenuView" object:nil];
    
    LJInfoDetailViewController *detail = [[LJInfoDetailViewController alloc] init];
    detail.urlString = [self.dataArray[indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 225;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJInfo2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
    if (!cell) {
        cell = [[LJInfo2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
    }
    NSDictionary * data = self.dataArray[indexPath.row];
    [cell configUIWithDic:data];
    return cell;
}

#pragma mark - UI
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
