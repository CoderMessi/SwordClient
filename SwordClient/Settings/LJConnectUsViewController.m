//
//  LJConnectUsViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJConnectUsViewController.h"

#define rowHeight 50
#define headerHeight 162

@interface LJConnectUsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LJConnectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    self.view.backgroundColor = ViewBGColor;
    
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
    
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:Image(@"pic_logo2")];
    [headerView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(13);
        make.centerX.equalTo(headerView);
    }];
    
    UILabel *companyName = [UILabel new];
    companyName.text = @"亮剑集团公司全称";
    companyName.font = Font(14);
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.textColor = [UIColor colorWithHexString:@"454545"];
    [headerView addSubview:companyName];
    [companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.mas_bottom).offset(16);
        make.left.right.equalTo(headerView);
    }];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = ViewBGColor;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 400);
    
    UIImageView *QRCodeImage = [[UIImageView alloc] initWithImage:Image(@"pic_erweima")];
    [footer addSubview:QRCodeImage];
    [QRCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(18);
        make.centerX.equalTo(footer);
    }];
    
    UILabel *label1 = [UILabel new];
    label1.font = Font(12);
    label1.text = @"微信号：lianjian";
    label1.textColor = [UIColor colorWithHexString:@"0980d2"];
    label1.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(QRCodeImage.mas_bottom).offset(10);
        make.left.right.equalTo(footer);
        make.height.equalTo(@15);
    }];
    
    UILabel *label2 = [UILabel new];
    label2.font = Font(12);
    label2.text = @"打开微信，搜索“liangjian“联系客服";
    label2.textColor = [UIColor colorWithHexString:@"999999"];
    label2.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(12);
        make.left.right.equalTo(footer);
        make.height.equalTo(@15);
    }];
    
    return footer;
}


#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"QQ";
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, 200, cell.height);
        label.right = kScreenWidth - 10;
        label.text = @"87128w7r89";
        label.textColor = [UIColor colorWithHexString:@"0980d2"];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"服务热线";
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, 200, cell.height);
        label.right = kScreenWidth - 10;
        label.text = @"18798797876";
        label.textColor = [UIColor colorWithHexString:@"0980d2"];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"公司地址";
        
        UILabel *label = [UILabel new];
        label.frame = CGRectMake(0, 0, 200, cell.height);
        label.right = kScreenWidth - 10;
        label.text = @"中国湖南";
        label.textColor = [UIColor colorWithHexString:@"999999"];
        label.textAlignment = NSTextAlignmentRight;
        [cell addSubview:label];
    }
    
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ViewBGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
