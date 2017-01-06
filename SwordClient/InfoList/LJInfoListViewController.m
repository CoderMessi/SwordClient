//
//  LJInfoListViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/5.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoListViewController.h"

@interface LJInfoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *listView;

@end

@implementation LJInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:Image(@"ico_menu") style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    [self.view addSubview:self.listView];
}

#pragma mark - events
- (void)rightItemClick {
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
