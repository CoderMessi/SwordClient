//
//  LJForgetPasswordViewController2.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJForgetPasswordViewController2.h"
#import "SMEncryptTool.h"
#import "AppDelegate.h"

@interface LJForgetPasswordViewController2 () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *btReGet;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *rePasswordText;
@property (nonatomic, strong) UIButton *btDone;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;
@end

@implementation LJForgetPasswordViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证码登录";
    self.view.backgroundColor = ViewBGColor;
    self.second = 59;
    
    [self.view addSubview:self.codeText];
//    [self.view addSubview:self.passwordText];
//    [self.view addSubview:self.rePasswordText];
    [self.view addSubview:self.btDone];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)dealloc {
    
}

- (void)countDown {
    self.second--;
    [self.btReGet setTitle:[NSString stringWithFormat:@"重新获取(%ld秒)", self.second] forState:UIControlStateNormal];
    if (self.second == 0) {
        self.second = 60;
        [self.timer invalidate];
        self.timer = nil;
        self.btReGet.enabled = YES;
        [self.btReGet setTitle:@"重新获取" forState:UIControlStateNormal];
    }
}


- (void)getVerifyCode {
    self.btReGet.enabled = NO;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [MBProgressHUD showLoadingHUDAddedTo:self.view withText:nil];
    NSDictionary *param = @{@"mobile" : self.phoneNumber,
                            @"type" : @"codelogin"};
    __weak typeof(self) weakSelf = self;
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            
            
        } else {
            [MBProgressHUD showHUDAddedTo:weakSelf.view withText:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view withText:@"获取验证码失败，请稍后再试"];
    }];
}


- (void)doneClick {
    [self.codeText resignFirstResponder];
    if (self.codeText.text.length == 0) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入验证码"];
        return;
    }
    
    NSDictionary *param = @{@"mobile": self.phoneNumber,
                            @"verify_code" : self.codeText.text};
    __weak typeof(self) weakSelf = self;
    [NetWorkTool executePOST:@"/api/cuser/codelogin" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            
            SMUserModel *userModel = [SMUserModel mj_objectWithKeyValues:responseObject];
            userModel.loginStatus = SCLoginStateOnline;
            
            
            [SMUserModel saveUserData:userModel];
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self dismissViewControllerAnimated:NO completion:nil];
            
            [appdelegate jumpToInfoListVC];
            
        } else {
            [MBProgressHUD showHUDAddedTo:weakSelf.view withText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)backToLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeText) {
        if (range.location >= 6) {
            NSString *text = textField.text;
            self.codeText.text = [text substringToIndex:6];
            [self.codeText resignFirstResponder];
            [self.passwordText becomeFirstResponder];
        }
    }
    return YES;
}


- (void)layout {
    CGFloat topOffset = 30;
    CGFloat textHeight = 50;
    [self.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(topOffset);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(textHeight);
    }];
    
//    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.codeText.mas_bottom).offset(1);
//        make.left.right.height.equalTo(self.codeText);
//    }];
//    
//    [self.rePasswordText mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.passwordText.mas_bottom).offset(1);
//        make.left.right.height.equalTo(self.codeText);
//    }];
    
    [self.btDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeText.mas_bottom).offset(60);
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
        _codeText.keyboardType = UIKeyboardTypeNumberPad;
        _codeText.delegate = self;
        
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
        _btReGet.enabled = NO;
        [_btReGet addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [_btReGet setTitle:@"重新获取(59秒)" forState:UIControlStateNormal];
        [_btReGet setTitleColor:[UIColor colorWithHexString:@"454545"] forState:UIControlStateNormal];
        [_btReGet setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
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
        _passwordText.secureTextEntry = YES;
        
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
        _rePasswordText.secureTextEntry = YES;
        
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
