//
//  LJPersonInfoViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJPersonInfoViewController.h"

#define rowHeight 50
#define headerHeight 140
#define headerImageHeight 98

@interface LJPersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation LJPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = ViewBGColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (kScreenHeight - rowHeight * 4 - headerHeight - 64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = ViewBGColor;
    headerView.frame = CGRectMake(0, 0, kScreenHeight, headerHeight);
    
    [headerView addSubview:self.headImageView];
    self.headImageView.frame = CGRectMake((kScreenWidth-headerImageHeight)/2, 21, headerImageHeight, headerImageHeight);
    
    return headerView;
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"姓名";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"QQ";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"微信";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"手机号";
    }
    
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor redColor];
        _headImageView.layer.cornerRadius = headerImageHeight/2;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
