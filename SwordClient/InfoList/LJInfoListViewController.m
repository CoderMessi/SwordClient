//
//  LJInfoListViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/5.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoListViewController.h"
#import "LJMenuView.h"

#import "LJPersonInfoViewController.h"
#import "LJConnectUsViewController.h"

@interface LJInfoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) LJMenuView *menuView;

@end

@implementation LJInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    [self.view addSubview:self.listView];
    [self.view addSubview:self.menuView];
    [self subViewEvent];
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"aaa";
    cell.detailTextLabel.text = @"bbb";
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
