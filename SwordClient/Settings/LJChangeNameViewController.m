//
//  LJChangeNameViewController.m
//  SwordClient
//
//  Created by songruihang on 2017/1/9.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJChangeNameViewController.h"
#import "NetWorkTool.h"

@interface LJChangeNameViewController ()

@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *tintLabel;
@property (nonatomic, strong) UIButton *btNext;

@property (nonatomic, strong) SMUserModel *user;


@end

@implementation LJChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息修改";
    self.view.backgroundColor = ViewBGColor;
    self.user = [SMUserModel getUserData];
    
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.tintLabel];
    [self.view addSubview:self.btNext];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.phoneText.text = self.name;
}

- (void)sureClick {
    if (self.phoneText.text.length < 2 || self.phoneText.text.length > 8) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的姓名"];
        return;
    }
    NSDictionary *param = @{@"name" : self.phoneText.text,
                            @"uid": [NSNumber numberWithInteger:self.user.userId]};
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    [NetWorkTool executePOST:@"/api/cuser/update" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.user.name = self.phoneText.text;
            [SMUserModel saveUserData:self.user];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:@"修改失败，请稍后重试"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"修改失败，请稍后重试"];
    }];
}

- (void)layout {
    CGFloat topOffset = 30 + 64;
    CGFloat textHeight = 50;
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(textHeight);
    }];
    
    [self.tintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    [self.btNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).offset(75);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@44);
    }];
}

- (UITextField *)phoneText {
    if (!_phoneText) {
        _phoneText = [UITextField new];
        _phoneText.backgroundColor = [UIColor whiteColor];
        _phoneText.placeholder = @"请输入姓名";
        _phoneText.text = self.name;
        _phoneText.font = Font(15);
        
        UILabel *leftView = [UILabel new];
        leftView.frame = CGRectMake(0, 0, 80, 50);
        leftView.text = @"姓名：";
        leftView.textColor = [UIColor colorWithHexString:@"454545"];
        leftView.font = Font(15);
        leftView.textAlignment = NSTextAlignmentCenter;
        _phoneText.leftView = leftView;
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneText;
}

- (UILabel *)tintLabel {
    if (!_tintLabel) {
        _tintLabel = [UILabel new];
        _tintLabel.text = @"请输入姓名，限制为4-16个字符，一个汉字为两个字符";
        _tintLabel.font = Font(12);
        _tintLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _tintLabel;
}

- (UIButton *)btNext {
    if (!_btNext) {
        _btNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btNext setBackgroundImage:Image(@"ico_btn5") forState:UIControlStateNormal];
        [_btNext setBackgroundImage:Image(@"ico_btn5") forState:UIControlStateHighlighted];
        [_btNext addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btNext;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
