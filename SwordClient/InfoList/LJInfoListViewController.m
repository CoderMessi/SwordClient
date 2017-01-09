//
//  LJInfoListViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/5.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoListViewController.h"
#import "LJMenuView.h"
#import "LJInfoTableViewCell.h"

#import "LJPersonInfoViewController.h"
#import "LJConnectUsViewController.h"
#import "LJInfoDetailViewController.h"

@interface LJInfoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) LJMenuView *menuView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation LJInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    
    [self.view addSubview:self.listView];
    [self.view addSubview:self.menuView];
    [self subViewEvent];
    [self requestData];
    
    self.listView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.listView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)requestData {
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    SMUserModel *user = [SMUserModel getUserData];
    self.page = 1;
    NSDictionary *param = @{@"uid" : [NSNumber numberWithInteger:user.userId],
                            @"page" : [NSNumber numberWithInteger:self.page],
                            @"num" : @"15",
                            @"show_type" : @"1"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_header endRefreshing];
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
                            @"show_type" : @"1"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self.dataArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - events
- (void)rightItemClick {
    self.menuView.hidden = !self.menuView.hidden;
}

- (void)subViewEvent {
    __weak typeof(self) weakSelf = self;
    self.menuView.goConnectUs = ^ {
        LJConnectUsViewController *connectUs = [[LJConnectUsViewController alloc] init];
        [weakSelf.navigationController pushViewController:connectUs animated:YES];
    };
    
    self.menuView.goInfoList = ^ {
        
    };
    
    self.menuView.goPersonInfo = ^ {
        LJPersonInfoViewController *presonInfo = [[LJPersonInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:presonInfo animated:YES];
    };
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.menuView.hidden = YES;
    LJInfoDetailViewController *detail = [[LJInfoDetailViewController alloc] init];
    detail.urlString = [self.dataArray[indexPath.row] objectForKey:@"url"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
    LJInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[LJInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *data = self.dataArray[indexPath.row];
    [cell configUIWithDic:data];
    return cell;
}

#pragma mark - UI
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
    }
    return _listView;
}

- (LJMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[LJMenuView alloc] initWithFrame:CGRectMake(0, 0, 215, 168)];
        _menuView.right = kScreenWidth - 9;
        _menuView.top = 4.5 + 64;
        _menuView.image = Image(@"pic_menuBg");
        _menuView.userInteractionEnabled = YES;
        _menuView.hidden = YES;
    }
    return _menuView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
