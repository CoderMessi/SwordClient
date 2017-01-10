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
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *companyName;
@property (nonatomic, strong) UILabel *QQ;
@property (nonatomic, strong) UILabel *mobile;
@property (nonatomic, strong) UILabel *dizhi;
@property (nonatomic, strong) UIImageView *QRCodeView;
@property (nonatomic, strong) UILabel *weixin;
@property (nonatomic, strong) UILabel *tintLabel;

@end

@implementation LJConnectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我们";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.tableView];
    [self getCompanyInfo];
}

- (void)getCompanyInfo {
    NSDictionary *param = @{@"type" : [NSNumber numberWithInt:1],
                            @"uid" : [NSNumber numberWithInteger:[SMUserModel getUserData].userId]};
    
    [NetWorkTool executePOST:@"/api/system/kefu" paramters:param success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [_headImageView sd_setImageWithURL:[NSURL URLWithString:[responseObject[@"data"] objectForKey:@"com_pic"]]];
            _companyName.text = [responseObject[@"data"] objectForKey:@"com_name"];
            _QQ.text = [responseObject[@"data"] objectForKey:@"qq"];
            _mobile.text = [responseObject[@"data"] objectForKey:@"phone"];
            _dizhi.text = [responseObject[@"data"] objectForKey:@"address"];
            [_QRCodeView sd_setImageWithURL:[NSURL URLWithString:[responseObject[@"data"] objectForKey:@"qrcode"]]];
            _weixin.text = [NSString stringWithFormat:@"微信号：%@", [responseObject[@"data"] objectForKey:@"wechat"]];
            _tintLabel.text = [NSString stringWithFormat:@"打开微信，搜索“%@“联系客服", [responseObject[@"data"] objectForKey:@"wechat"]];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
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
    
    _headImageView = [[UIImageView alloc] initWithImage:Image(@"pic_logo2")];
    [headerView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(13);
        make.centerX.equalTo(headerView);
        make.width.mas_equalTo(83);
        make.height.mas_equalTo(100);
    }];
    
    _companyName = [UILabel new];
    _companyName.text = @"亮剑集团";
    _companyName.font = Font(14);
    _companyName.textAlignment = NSTextAlignmentCenter;
    _companyName.textColor = [UIColor colorWithHexString:@"454545"];
    [headerView addSubview:_companyName];
    [_companyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(16);
        make.left.right.equalTo(headerView);
    }];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.backgroundColor = ViewBGColor;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 400);
    
    _QRCodeView = [[UIImageView alloc] initWithImage:Image(@"pic_erweima")];
    [footer addSubview:_QRCodeView];
    [_QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer).offset(18);
        make.centerX.equalTo(footer);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(104);
    }];
    
    _weixin = [UILabel new];
    _weixin.font = Font(12);
    _weixin.text = @"微信号：lianjian";
    _weixin.textColor = [UIColor colorWithHexString:@"0980d2"];
    _weixin.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:_weixin];
    [_weixin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_QRCodeView.mas_bottom).offset(10);
        make.left.right.equalTo(footer);
        make.height.equalTo(@15);
    }];
    
    _tintLabel = [UILabel new];
    _tintLabel.font = Font(12);
    _tintLabel.text = @"打开微信，搜索“liangjian“联系客服";
    _tintLabel.textColor = [UIColor colorWithHexString:@"999999"];
    _tintLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:_tintLabel];
    [_tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weixin.mas_bottom).offset(12);
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
        
        _QQ = [UILabel new];
        _QQ.frame = CGRectMake(0, 0, 200, cell.height);
        _QQ.right = kScreenWidth - 10;
        _QQ.text = @"87128w7r89";
        _QQ.textColor = [UIColor colorWithHexString:@"0980d2"];
        _QQ.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_QQ];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"服务热线";
        
        _mobile = [UILabel new];
        _mobile.frame = CGRectMake(0, 0, 200, cell.height);
        _mobile.right = kScreenWidth - 10;
        _mobile.text = @"18798797876";
        _mobile.textColor = [UIColor colorWithHexString:@"0980d2"];
        _mobile.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_mobile];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"公司地址";
        
        _dizhi = [UILabel new];
        _dizhi.frame = CGRectMake(0, 0, 200, cell.height);
        _dizhi.right = kScreenWidth - 10;
        _dizhi.text = @"中国湖南";
        _dizhi.textColor = [UIColor colorWithHexString:@"999999"];
        _dizhi.textAlignment = NSTextAlignmentRight;
        [cell addSubview:_dizhi];
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
