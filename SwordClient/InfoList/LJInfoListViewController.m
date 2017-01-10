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
#import "LJInfo2TableViewCell.h"

#import "LJPersonInfoViewController.h"
#import "LJConnectUsViewController.h"
#import "LJInfoDetailViewController.h"

#import <UMMobClick/MobClick.h>

@interface LJInfoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) LJMenuView *menuView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArray2;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) int listType;   //1 列表  2 图标


@end

@implementation LJInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.navigationController.navigationBar.translucent=NO;
    
    self.dataArray = [NSMutableArray array];
    self.dataArray2 = [NSMutableArray array];
    self.page = 1;
    self.listType = 1;
    
    [self.view addSubview:self.listView];
    [self.view addSubview:self.menuView];
    [self subViewEvent];
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
                            @"show_type" : @"1"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.dataArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_header endRefreshing];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary *param2 = @{@"uid" : [NSNumber numberWithInteger:user.userId],
                            @"page" : [NSNumber numberWithInteger:self.page],
                            @"num" : @"15",
                            @"show_type" : @"1"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param2 success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.dataArray2 = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_header endRefreshing];
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
                            @"show_type" : @"1"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self.dataArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_footer endRefreshing];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary *param2 = @{@"uid" : [NSNumber numberWithInteger:user.userId],
                            @"page" : [NSNumber numberWithInteger:self.page],
                            @"num" : @"15",
                            @"show_type" : @"2"};
    [NetWorkTool executePOST:@"/api/message/notice" paramters:param2 success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:nil];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [self.dataArray2 addObjectsFromArray:[responseObject objectForKey:@"data"]];
            [self.listView reloadData];
            [self.listView.mj_footer endRefreshing];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
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
        if (weakSelf.listType == 1) {
            weakSelf.listType = 2;
        } else {
            weakSelf.listType =1;
        }
        [weakSelf.listView reloadData];
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
    if (self.listType == 1) {
        detail.urlString = [self.dataArray[indexPath.row] objectForKey:@"url"];
    } else {
        detail.urlString = [self.dataArray2[indexPath.row] objectForKey:@"url"];
    }
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == 1) {
        return 70;
    } else {
        return 225;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listType == 1) {
        return self.dataArray.count;
    } else {
        return self.dataArray2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == 1) {
        LJInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[LJInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NSDictionary *data = self.dataArray[indexPath.row];
        [cell configUIWithDic:data];
        return cell;
    } else {
        LJInfo2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[LJInfo2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        NSDictionary * data = self.dataArray2[indexPath.row];
        [cell configUIWithDic:data];
        return cell;
    }
    return nil;
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

- (LJMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[LJMenuView alloc] initWithFrame:CGRectMake(0, 0, 215, 168)];
        _menuView.right = kScreenWidth - 9;
        _menuView.top = 4.5;
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
