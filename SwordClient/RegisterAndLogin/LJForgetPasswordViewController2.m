//
//  LJForgetPasswordViewController2.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJForgetPasswordViewController2.h"

@interface LJForgetPasswordViewController2 ()

@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *btReGet;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *rePasswordText;
@property (nonatomic, strong) UIButton *btDone;

@end

@implementation LJForgetPasswordViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.codeText];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.rePasswordText];
    [self.view addSubview:self.btDone];
    [self layout];
}


- (void)getVerifyCode {
    NSDictionary *param = @{@"mobile" : self.phoneNumber,
                            @"type" : @"reg"};
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)doneClick {
    
}


- (void)layout {
    CGFloat topOffset = 30 + 64;
    CGFloat textHeight = 50;
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(textHeight);
    }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeText.mas_bottom).offset(1);
        make.left.right.height.equalTo(self.codeText);
    }];
    
    [self.rePasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordText.mas_bottom).offset(1);
        make.left.right.height.equalTo(self.codeText);
    }];
    
    [self.btDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rePasswordText.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@44);
    }];
}

- (UITextField *)codeText {
    if (!_codeText) {
        _codeText = [UITextField new];
        _codeText.backgroundColor = [UIColor whiteColor];
        _codeText.placeholder = @"请输入验证码";
        _codeText.font = Font(15);
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _codeText.leftView = leftView;
        _codeText.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [UIView new];
        rightView.frame = CGRectMake(0, 0, 140, 50);
        _codeText.rightView = rightView;
        _codeText.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [UIView new];
        line.frame = CGRectMake(0, 5, 1, 40);
        line.backgroundColor = ViewBGColor;
        [rightView addSubview:line];
        
        _btReGet = [UIButton buttonWithType:UIButtonTypeCustom];
        _btReGet.frame = CGRectMake(5, 0, 129, 50);
        _btReGet.titleLabel.font = Font(15);
        [_btReGet addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [_btReGet setTitle:@"重新获取(59秒)" forState:UIControlStateNormal];
        [_btReGet setTitleColor:[UIColor colorWithHexString:@"454545"] forState:UIControlStateNormal];
        [rightView addSubview:_btReGet];
        
    }
    return _codeText;
}

- (UITextField *)passwordText {
    if (!_passwordText) {
        _passwordText = [UITextField new];
        _passwordText.backgroundColor = [UIColor whiteColor];
        _passwordText.placeholder = @"请输入新密码";
        _passwordText.font = Font(15);
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _passwordText.leftView = leftView;
        _passwordText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordText;
}

- (UITextField *)rePasswordText {
    if (!_rePasswordText) {
        _rePasswordText = [UITextField new];
        _rePasswordText.clearButtonMode = UITextFieldViewModeAlways;
        _rePasswordText.backgroundColor = [UIColor whiteColor];
        _rePasswordText.placeholder = @"请再次输入密码";
        _rePasswordText.font = Font(15);
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _rePasswordText.leftView = leftView;
        _rePasswordText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _rePasswordText;
}

- (UIButton *)btDone {
    if (!_btDone) {
        _btDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btDone setBackgroundImage:Image(@"ico_btn10") forState:UIControlStateNormal];
        [_btDone addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btDone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
