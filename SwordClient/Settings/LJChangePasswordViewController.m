//
//  LJChangePasswordViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJChangePasswordViewController.h"
#import "SMEncryptTool.h"

@interface LJChangePasswordViewController ()

@property (nonatomic,strong) UITextField *passwordText;
@property (nonatomic,strong) UITextField *rePasswordText;
@property (nonatomic, strong) UIButton *btDone;

@end

@implementation LJChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.rePasswordText];
    [self.view addSubview:self.btDone];
    [self layout];
}

- (void)doneClick {
    NSDictionary *param = @{@"uid" : @"137",
                            @"old_pwd" : [SMEncryptTool md5:@"123456"],
                            @"new_pwd" : [SMEncryptTool md5:@"1234567"]};
    [NetWorkTool executePOST:@"/api/cuser/pwd" paramters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)layout {
    CGFloat topOffset = 64+30;
    CGFloat textHeight = 50;
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(textHeight);
    }];
    
    [self.rePasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordText.mas_bottom).offset(1);
        make.left.right.height.equalTo(self.passwordText);
    }];
    
    [self.btDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rePasswordText.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@280);
        make.height.equalTo(@44);
    }];
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
        _rePasswordText.backgroundColor = [UIColor whiteColor];
        _rePasswordText.placeholder = @"请再次输入密码";
        _rePasswordText.font = Font(15);
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _rePasswordText.leftView = leftView;
        _rePasswordText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        rightView.enabled = NO;
        [rightView setImage:Image(@"ico_btn9") forState:UIControlStateDisabled];
        rightView.frame = CGRectMake(0, 0, 50, 100);
        rightView.right = kScreenWidth - 30;
        _rePasswordText.rightView = rightView;
        _rePasswordText.rightViewMode = UITextFieldViewModeAlways;
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
    
}

@end
