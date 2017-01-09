//
//  LJSettViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJSettViewController.h"
#import "AppDelegate.h"

#define rowHeight 50
#define headerHeight 30

@interface LJSettViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) SMUserModel *userModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISwitch *infoSwitch;
@property (nonatomic, strong) UISwitch *shakeSwitch;
@property (nonatomic, strong) UISwitch *voiceSwitch;

@end

@implementation LJSettViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = ViewBGColor;
    self.userModel = [SMUserModel getUserData];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)logoutClick {
    NSDictionary *param = @{@"uid" : [NSNumber numberWithInteger:self.userModel.userId]};
    [NetWorkTool executePOST:@"/api/cuser/signout" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            SMUserModel *userModel = [[SMUserModel alloc]init];
            userModel.loginStatus = SCLoginStateDropped;
            [SMUserModel saveUserData:userModel];
            
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate jumpToLoginVC];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"登出失败，请稍后再试"];
    }];
}

- (void)infoClick:(UISwitch *)sender {
    NSLog(@"消息提示：%d", sender.on);
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    NSDictionary *param = @{@"is_open" : [NSNumber numberWithInteger:sender.on]};
    [NetWorkTool executePOST:@"/api/system/csetting" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.userModel.isOpenNotice = sender.on;
            [SMUserModel saveUserData:self.userModel];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view withText:@"设置失败，请稍后再试"];
    }];
}

- (void)shakeClick:(UISwitch *)sender {
    NSLog(@"震动：%d", sender.on);
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    
    NSDictionary *param = @{@"is_shake" : [NSNumber numberWithInteger:sender.on]};
    [NetWorkTool executePOST:@"/api/system/csetting" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.userModel.isOpenShake = sender.on;
            [SMUserModel saveUserData:self.userModel];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view withText:@"设置失败，请稍后再试"];
    }];
}

- (void)voiceClick:(UISwitch *)sender {
    NSLog(@"声音：%d", sender.on);
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    
    NSDictionary *param = @{@"is_music" : [NSNumber numberWithInteger:sender.on]};
    [NetWorkTool executePOST:@"/api/system/csetting" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.userModel.isOpenMusic = sender.on;
            [SMUserModel saveUserData:self.userModel];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showHUDAddedTo:self.view withText:@"设置失败，请稍后再试"];
    }];
}

#pragma mark - tableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (kScreenHeight - rowHeight * 3 - headerHeight - 64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = ViewBGColor;
    headerView.frame = CGRectMake(0, 0, kScreenHeight, headerHeight);
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = ViewBGColor;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    
    CGFloat btWidth = 240;
    CGFloat left = (kScreenWidth - btWidth)/2;
    UIButton *btLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btLogout.frame = CGRectMake(left, 50, btWidth, 44);
    [btLogout setBackgroundImage:Image(@"ico_btn8") forState:UIControlStateNormal];
    [btLogout addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btLogout];
    
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
        cell.textLabel.text = @"消息提示";
        
        self.infoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 9, 60, 32)];
        self.infoSwitch.right = kScreenWidth - 25;
        [self.infoSwitch setOn:self.userModel.isOpenNotice];
        [self.infoSwitch addTarget:self action:@selector(infoClick:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:self.infoSwitch];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"震动";
        
        self.shakeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 9, 60, 32)];
        self.shakeSwitch.right = kScreenWidth - 25;
        self.shakeSwitch.on = self.userModel.isOpenShake;
//        [self.shakeSwitch setOn:self.userModel.isOpenShake];
        [self.shakeSwitch addTarget:self action:@selector(shakeClick:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:self.shakeSwitch];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"声音";
        
        self.voiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 9, 60, 32)];
        self.voiceSwitch.right = kScreenWidth - 25;
        self.voiceSwitch.on = self.userModel.isOpenMusic;
        [self.voiceSwitch addTarget:self action:@selector(voiceClick:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:self.voiceSwitch];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
