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
#import <UMSocialCore/UMSocialCore.h>
#import <UMMobClick/MobClick.h>

#import "LJRegisterViewController1.h"
#import "LJNavigationController.h"
#import "LJForggetPasswordViewController.h"
#import "AppDelegate.h"

@interface LJLoginViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIView *inputBgView;
@property (nonatomic, strong) UIView *line;
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
    
    [self initSubviews];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}


#pragma mark - events
- (void)forgetPasswordClick {
    LJForggetPasswordViewController * forgetPassword = [[LJForggetPasswordViewController alloc] init];
    LJNavigationController * nav = [[LJNavigationController alloc] initWithRootViewController:forgetPassword];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)registerClick {
    LJRegisterViewController1 *registerVc = [[LJRegisterViewController1 alloc] init];
    LJNavigationController *nav = [[LJNavigationController alloc] initWithRootViewController:registerVc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)loginClick {
    if (self.phoneText.text.length != 11) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号"];
        return;
    } else if (self.passwordText.text.length == 0) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入密码"];
        return;
    }
    
    NSDictionary *param = @{@"username" : self.phoneText.text,
                            @"password" : [SMEncryptTool md5:self.passwordText.text],
                            @"last_login_ip" : [NSString getIpAddresses]};
    
    [NetWorkTool executePOST:@"/api/cuser/login" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            SMUserModel *userModel = [SMUserModel mj_objectWithKeyValues:responseObject];
            userModel.loginStatus = SCLoginStateOnline;
            
            
            [SMUserModel saveUserData:userModel];
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate jumpToInfoListVC];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"error>>>%@", error);
    }];
}

- (void)loginViaQQ {
    NSDictionary *param = @{@"mobile" : @"18514456698",
                            @"type" : @"reg"};
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loginViaWechet {
    
    //构造SendAuthReq结构体
//    SendAuthReq* req =[[[SendAuthReq alloc ] init ] autorelease ];
//    req.scope = @"snsapi_userinfo" ;
//    req.state = @"123" ;
//    [WXApi sendReq:req];
}

// 在需要进行获取登录信息的UIViewController中加入如下代码
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
    }];
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
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textBgView);
        make.centerY.equalTo(self.textBgView);
        make.height.mas_equalTo(1);
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
    [self.textBgView addSubview:self.line];
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

- (UIView *)line {
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = [UIColor whiteColor];
    }
    return _line;
}

- (UITextField *)phoneText {
    if (!_phoneText) {
        _phoneText = [UITextField new];
        _phoneText.placeholder = @"手机号";
        _phoneText.font = Font(15);
        _phoneText.textColor = [UIColor whiteColor];
        _phoneText.tintColor = [UIColor whiteColor];
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        
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
        _passwordText.font = Font(15);
        _passwordText.textColor = [UIColor whiteColor];
        _passwordText.tintColor = [UIColor whiteColor];
        _passwordText.secureTextEntry = YES;
        
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        leftView.enabled = NO;
        leftView.frame = CGRectMake(0, 0, 44, 44);
        [leftView setImage:Image(@"ico_lock") forState:UIControlStateDisabled];
        _passwordText.leftView = leftView;
        _passwordText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        rightView.frame = CGRectMake(0, 0, 100, 44);
        rightView.titleLabel.font = Font(15);
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
