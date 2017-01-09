//
//  LJRegisterViewController1.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJRegisterViewController1.h"
#import "LJRegisterViewController2.h"

@interface LJRegisterViewController1 ()

@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *tintLabel;
@property (nonatomic, strong) UIButton *btNext;

@property (nonatomic, copy) NSString *verifyCode;

@end

@implementation LJRegisterViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.tintLabel];
    [self.view addSubview:self.btNext];
    [self layout];
}

- (void)goNextView {
    if (self.phoneText.text.length != 11) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号"];
        return;
    }
    
    LJRegisterViewController2 *vc = [[LJRegisterViewController2 alloc] init];
    vc.verifyCode = self.verifyCode;
    vc.phoneNumber = self.phoneText.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)popClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getVerifyCode {
    if (self.phoneText.text.length != 11) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号"];
        return;
    }
    NSDictionary *param = @{@"mobile" : self.phoneText.text,
                            @"type" : @"reg"};
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
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
        _phoneText.placeholder = @"请输入手机号";
        _phoneText.font = Font(15);
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _phoneText.leftView = leftView;
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [rightView setImage:Image(@"ico_btn9") forState:UIControlStateNormal];
        rightView.frame = CGRectMake(0, 0, 50, 100);
        rightView.right = kScreenWidth - 30;
        _phoneText.rightView = rightView;
        _phoneText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _phoneText;
}

- (UILabel *)tintLabel {
    if (!_tintLabel) {
        _tintLabel = [UILabel new];
        _tintLabel.text = @"请输入手机号获取验证码";
        _tintLabel.font = Font(12);
        _tintLabel.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _tintLabel;
}

- (UIButton *)btNext {
    if (!_btNext) {
        _btNext = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btNext setBackgroundImage:Image(@"ico_btn12") forState:UIControlStateNormal];
        [_btNext setBackgroundImage:Image(@"ico_btn12") forState:UIControlStateHighlighted];
        [_btNext addTarget:self action:@selector(goNextView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btNext;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
