//
//  LJPersonInfoViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJPersonInfoViewController.h"
#import "SMUserModel.h"

#import "LJSettViewController.h"
#import "LJChangePasswordViewController.h"
#import "LJChangeMobileViewController.h"
#import "LJChangeNameViewController.h"

#define rowHeight 50
#define headerHeight 140
#define headerImageHeight 98

@interface LJPersonInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) SMUserModel *user;

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *QQ;
@property (nonatomic, strong) UILabel *wechat;
@property (nonatomic, strong) UILabel *mobile;

@end

@implementation LJPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.view.backgroundColor = ViewBGColor;
    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
    
    self.user = [SMUserModel getUserData];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [SMUserModel getUserData];
    _name.text = self.user.name;
    _QQ.text = self.user.qqAccount;
    _wechat.text = self.user.wechat;
    _mobile.text = self.user.mobile;
}

#pragma mark - event
- (void)setClick {
    LJSettViewController *setVc = [[LJSettViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

- (void)changePasswordClick {
    LJChangePasswordViewController *changePass = [[LJChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:changePass animated:YES];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LJChangeNameViewController *changeName = [[LJChangeNameViewController alloc] init];
        changeName.name = self.user.name;
        changeName.changeType = LJTypeName;
        [self.navigationController pushViewController:changeName animated:YES];
        
    } else if (indexPath.row == 1) {
        LJChangeNameViewController *changeName = [[LJChangeNameViewController alloc] init];
        changeName.changeType = LJTypeQQ;
        changeName.name = self.user.qqAccount;
        [self.navigationController pushViewController:changeName animated:YES];
    } else if (indexPath.row == 2) {
        LJChangeNameViewController *changeName = [[LJChangeNameViewController alloc] init];
        changeName.changeType = LJTypeWechat;
        changeName.name = self.user.wechat;
        [self.navigationController pushViewController:changeName animated:YES];
    } else if (indexPath.row == 3) {
        LJChangeMobileViewController *changeMobile = [[LJChangeMobileViewController alloc] init];

        [self.navigationController pushViewController:changeMobile animated:YES];
    }
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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[SMUserModel getUserData].avatar] placeholderImage:Image(@"guest_default")];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = ViewBGColor;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    CGFloat gap = 20;
    CGFloat top = 50;
    CGFloat btWidth = (kScreenWidth - gap*3) / 2;
    CGFloat btHeight = 44;
    UIButton *btSet = [UIButton buttonWithType:UIButtonTypeCustom];
    btSet.frame = CGRectMake(gap, top, btWidth, btHeight);
    [btSet setBackgroundImage:Image(@"ico_btn6") forState:UIControlStateNormal];
    [btSet addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btSet];
    
    UIButton *btChangePassword = [UIButton buttonWithType:UIButtonTypeCustom];
    btChangePassword.frame = CGRectMake(kScreenWidth - gap - btWidth, top, btWidth, btHeight);
    [btChangePassword setBackgroundImage:Image(@"ico_btn7") forState:UIControlStateNormal];
    [btChangePassword addTarget:self action:@selector(changePasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btChangePassword];
    
    return footer;
}


#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"姓名";
        
        _name = [UILabel new];
        _name.frame = CGRectMake(0, 0, 200, rowHeight);
        _name.right = kScreenWidth - 40;
        _name.text = self.user.name;
        _name.textColor = [UIColor colorWithHexString:@"999999"];
        _name.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_name];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"QQ";
        
        _QQ = [UILabel new];
        _QQ.frame = CGRectMake(0, 0, 200, rowHeight);
        _QQ.right = kScreenWidth - 40;
        _QQ.text = self.user.qqAccount;
        _QQ.textColor = [UIColor colorWithHexString:@"999999"];
        _QQ.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_QQ];
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"微信";
        
        _wechat= [UILabel new];
        _wechat.frame = CGRectMake(0, 0, 200, rowHeight);
        _wechat.right = kScreenWidth - 40;
        _wechat.text = self.user.wechat;
        _wechat.textColor = [UIColor colorWithHexString:@"999999"];
        _wechat.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_wechat];
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"手机号";
        
        _mobile = [UILabel new];
        _mobile.frame = CGRectMake(0, 0, 200, rowHeight);
        _mobile.right = kScreenWidth - 40;
        _mobile.text = self.user.mobile;
        _mobile.textColor = [UIColor colorWithHexString:@"999999"];
        _mobile.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_mobile];
    }
    
    return cell;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = ViewBGColor;
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
