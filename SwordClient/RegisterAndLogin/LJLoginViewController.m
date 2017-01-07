//
//  LJLoginViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/6.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJLoginViewController.h"
#import "NetWorkTool.h"
#import "SMEncryptTool.h"
#import "NSString+MD5.h"
#import "SMUserModel.h"

@interface LJLoginViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *inputBgView;
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UIButton *btRegister;
@property (nonatomic, strong) UIButton *btLogin;
@property (nonatomic, strong) UIImageView *orImageView;
@property (nonatomic, strong) UIButton *btQQ;
@property (nonatomic, strong) UIButton *btWechat;

@end

@implementation LJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self initSubviews];
    [self layout];
}

#pragma mark - events
- (void)forgetPasswordClick {
    
}

- (void)registerClick {
    
}

- (void)loginClick {
    NSDictionary *param = @{@"username" : @"13499999999",
                            @"password" : [SMEncryptTool md5:@"123456"],
                            @"last_login_ip" : [NSString getIpAddresses]};
    [NetWorkTool executePOST:@"/api/cuser/login" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            SMUserModel *userModel = [SMUserModel mj_objectWithKeyValues:responseObject];
            userModel.loginStatus = SCLoginStateOnline;
            
            NSLog(@"%ld\n%@\n%@\n%@\n%@\n%@\n%ld\n%ld\n%d\n%d\n%d",userModel.userId,userModel.name,userModel.mobile,userModel.avatar,userModel.qqAccount,userModel.token,userModel.userStatus, userModel.loginStatus, userModel.isOpenMusic, userModel.isOpenShake, userModel. isOpenNotice);
        }
    } failure:^(NSError *error) {
        NSLog(@"error>>>%@", error);
    }];
}

- (void)loginViaQQ {
    
}

- (void)loginViaWechet {
    
}

- (void)keyboardShow:(NSNotification *)notification {
    self.bgImageView.top -= 300;
}

- (void)keyboardHide:(NSNotification *)notification {
    self.inputBgView.top += 300;
}

#pragma mark - layout
- (void)layout {
    CGFloat topOffset = 81.5;
    CGFloat btRegisterWidth = 130;
    CGFloat btRegisterHeight = 43;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView).offset(topOffset);
        make.centerX.equalTo(self.bgImageView);
    }];
    
    [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_bottom);
        make.left.right.bottom.equalTo(self.bgImageView);
    }];
    
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputBgView).offset(60);
        make.left.equalTo(self.bgImageView).offset(20);
        make.right.equalTo(self.bgImageView).offset(-20);
        make.height.equalTo(@88);
    }];
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.textBgView);
        make.height.equalTo(@44);
    }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.textBgView);
        make.height.equalTo(@44);
    }];
    
    [self.btRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputBgView).offset(20);
        make.top.equalTo(self.textBgView.mas_bottom).offset(20);
        make.width.mas_equalTo(btRegisterWidth);
        make.height.mas_equalTo(btRegisterHeight);
    }];
    
    [self.btLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputBgView).offset(-20);
        make.top.width.height.equalTo(self.btRegister);
    }];
    
    [self.orImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btRegister.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgImageView);
        make.left.equalTo(self.inputBgView).offset(20);
        make.right.equalTo(self.inputBgView).offset(-20);
    }];
    
    [self.btQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@45);
        make.right.equalTo(self.inputBgView.mas_centerX).offset(-10);
        make.top.equalTo(self.orImageView.mas_bottom).offset(10);
    }];
    
    [self.btWechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.btQQ);
        make.left.equalTo(self.inputBgView.mas_centerX).offset(10);
    }];
}

#pragma mark - init subviews
- (void)initSubviews {
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.iconView];
    [self.bgImageView addSubview:self.inputBgView];
    [self.inputBgView addSubview:self.textBgView];
    [self.textBgView addSubview:self.phoneText];
    [self.textBgView addSubview:self.passwordText];
    [self.inputBgView addSubview:self.btRegister];
    [self.inputBgView addSubview:self.btLogin];
    [self.inputBgView addSubview:self.orImageView];
    [self.inputBgView addSubview:self.btQQ];
    [self.inputBgView addSubview:self.btWechat];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:Image(@"pic_bg")];
        _bgImageView.frame = self.view.frame;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = Image(@"LOGO");
    }
    return _iconView;
}

- (UIView *)inputBgView {
    if (!_inputBgView) {
        _inputBgView = [UIView new];
    }
    return _inputBgView;
}

- (UIView *)textBgView {
    if (!_textBgView) {
        _textBgView = [UIView new];
        _textBgView.layer.borderColor = [UIColor colorWithHexString:@"ffffff"].CGColor;
        _textBgView.layer.borderWidth = 1;
        _textBgView.layer.masksToBounds = YES;
        _textBgView.layer.cornerRadius = 3.0;
    }
    return _textBgView;
}

- (UITextField *)phoneText {
    if (!_phoneText) {
        _phoneText = [UITextField new];
        _phoneText.placeholder = @"手机号";
        
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftView.enabled = NO;
        leftView.frame = CGRectMake(0, 0, 44, 44);
        [leftView setImage:Image(@"ico_phone") forState:UIControlStateDisabled];
        _phoneText.leftView = leftView;
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneText;
}

- (UITextField *)passwordText {
    if (!_passwordText) {
        _passwordText = [UITextField new];
        _passwordText.placeholder = @"密码";
        
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftView.enabled = NO;
        leftView.frame = CGRectMake(0, 0, 44, 44);
        [leftView setImage:Image(@"ico_lock") forState:UIControlStateDisabled];
        _passwordText.leftView = leftView;
        _passwordText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        rightView.frame = CGRectMake(0, 0, 100, 44);
        [rightView setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [rightView setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [rightView addTarget:self action:@selector(forgetPasswordClick) forControlEvents:UIControlEventTouchUpInside];
        _passwordText.rightView = rightView;
        _passwordText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _passwordText;
}

- (UIButton *)btRegister {
    if (!_btRegister) {
        _btRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btRegister setBackgroundImage:Image(@"ico_btn1") forState:UIControlStateNormal];
        [_btRegister addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btRegister;
}

- (UIButton *)btLogin {
    if (!_btLogin) {
        _btLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btLogin setBackgroundImage:Image(@"ico_btn2") forState:UIControlStateNormal];
        [_btLogin addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btLogin;
}

- (UIImageView *)orImageView {
    if (!_orImageView) {
        _orImageView = [[UIImageView alloc] initWithImage:Image(@"pic_or")];
    }
    return _orImageView;
}

- (UIButton *)btQQ {
    if (!_btQQ) {
        _btQQ = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btQQ setBackgroundImage:Image(@"ico_btn3") forState:UIControlStateNormal];
        [_btQQ addTarget:self action:@selector(loginViaQQ) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btQQ;
}

- (UIButton *)btWechat {
    if (!_btWechat) {
        _btWechat = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btWechat setBackgroundImage:Image(@"ico_btn4") forState:UIControlStateNormal];
        [_btWechat addTarget:self action:@selector(loginViaWechet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btWechat;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
