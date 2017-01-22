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
#import "WXApi.h"
#import <AFNetworking.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import "LJRegisterViewController1.h"
#import "LJNavigationController.h"
#import "LJForggetPasswordViewController.h"
#import "AppDelegate.h"

@interface LJLoginViewController () <LJLoginDelegate, TencentSessionDelegate, UITextFieldDelegate>

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

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

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

- (void)QQClick {
    // QQ
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [_tencentOAuth authorize:permissions];
}

- (void)wechatClick {
    //构造SendAuthReq结构体
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"swordClient";
        [WXApi sendReq:req];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.loginDelegate = self;
    } else {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请先安装微信客户端"];
    }
}

#pragma mark - textField delegate
//当手机号码大于11位时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneText) {
        NSString *phoneStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        phoneStr  = [phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (phoneStr.length >11) {
            [self.phoneText resignFirstResponder];
            [self.passwordText becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Tencent delegate
- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken.length > 0) {
        BOOL b = [_tencentOAuth getUserInfo];
        NSLog(@"获取用户信息>>>%d", b);
    } else {
        NSLog(@"QQ登录不成功 没有获取accesstoken");
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"用户取消登录");
    } else {
        NSLog(@"登录失败");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"没有网络了， 怎么登录成功呢");
    [MBProgressHUD showHUDAddedTo:self.view withText:@"没有网络，请稍后再试"];
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (response && response.retCode == URLREQUEST_SUCCEED) {
        NSDictionary *userInfo = [response jsonResponse];
        NSLog(@"QQ用户信息>>>%@", userInfo);
        
        NSString *headImageUrl = [userInfo objectForKey:@"figureurl"];
        NSString *name = [userInfo objectForKey:@"nickname"];
        NSString *openId = self.tencentOAuth.openId;
        
        [self loginViaQQWithOpenID:openId avatar:headImageUrl name:name];
    } else {
        NSLog(@"获取QQ用户信息失败:%d---msg:%@", response.detailRetCode, response.errorMsg);
    }
}

#pragma mark - request QQ wechat login
- (void)loginViaQQWithOpenID:(NSString *)openID avatar:(NSString *)avatar name:(NSString *)name {
    NSDictionary *param = @{@"open_id" : openID,
                            @"type" : [NSNumber numberWithInt:1],
                            @"avatar" : avatar,
                            @"name" : name};
    [NetWorkTool executePOST:@"/api/cuser/oauthlogin" paramters:param success:^(id responseObject) {
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
        
    }];
}

- (void)loginViaWechetWithOpenID:(NSString *)openID avatar:(NSString *)avatar name:(NSString *)name {
    NSDictionary *param = @{@"open_id" : openID,
                            @"type" : [NSNumber numberWithInt:2],
                            @"avatar" : avatar,
                            @"name" : name};
    [NetWorkTool executePOST:@"/api/cuser/oauthlogin" paramters:param success:^(id responseObject) {
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
        
    }];
}

- (void)loginWXSuccessWithCode:(NSString *)code {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    NSString *accessUrlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", kWechatAppID, kWXAppSecret, code];
    [manager GET:accessUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求WX access的response = %@", dic);
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        [self requestWXUserInfoByToken:accessToken andOpenid:openID];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取微信授权信息失败>>>%@", error.userInfo);
        [MBProgressHUD showHUDAddedTo:self.view withText:@"获取微信授权失败"];
    }];
}

-(void)requestWXUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        NSString *openID = [dic objectForKey:@"openid"];
        NSString *name = [dic objectForKey:@"nickname"];
        NSString *headimgurl = [dic objectForKey:@"headimgurl"];
        [self loginViaWechetWithOpenID:openID avatar:headimgurl name:name];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取微信用户信息失败>>>error %ld",(long)error.code);
    }];
}

#pragma mark - layout
- (void)layout {
    CGFloat topOffset = 81.5;
    CGFloat btRegisterWidth = 140;
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
    
//    [self.btRegister mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.inputBgView).offset(20);
//        make.top.equalTo(self.textBgView.mas_bottom).offset(20);
//        make.width.mas_equalTo(btRegisterWidth);
//        make.height.mas_equalTo(btRegisterHeight);
//    }];
    
    [self.btLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inputBgView);
        make.height.mas_equalTo(btRegisterHeight);
        make.width.mas_equalTo(btRegisterWidth);
        make.top.equalTo(self.textBgView.mas_bottom).offset(25*RATIO);
    }];
    
    [self.orImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btLogin.mas_bottom).offset(20*RATIO);
        make.centerX.equalTo(self.bgImageView);
        make.left.equalTo(self.inputBgView).offset(20*RATIO);
        make.right.equalTo(self.inputBgView).offset(-20*RATIO);
    }];
    
    
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appdelegate isWechatInstalled]) {
        
        [self.btQQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@45);
            make.right.equalTo(self.inputBgView.mas_centerX).offset(-10);
            make.top.equalTo(self.orImageView.mas_bottom).offset(10*RATIO);
        }];
        
        
        [self.btWechat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.width.height.equalTo(self.btQQ);
            make.left.equalTo(self.inputBgView.mas_centerX).offset(10*RATIO);
        }];
    } else {
        [self.btQQ mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@45);
            make.centerX.equalTo(self.inputBgView.mas_centerX);
            make.top.equalTo(self.orImageView.mas_bottom).offset(10*RATIO);
        }];
    }
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
    [self.inputBgView addSubview:self.btLogin];
    [self.inputBgView addSubview:self.orImageView];
    [self.inputBgView addSubview:self.btQQ];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appdelegate isWechatInstalled]) {
        [self.inputBgView addSubview:self.btWechat];
    }
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
        _phoneText.delegate = self;
        
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
        [rightView setTitle:@"验证码登录" forState:UIControlStateNormal];
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
        [_btLogin setBackgroundImage:Image(@"btn_login") forState:UIControlStateNormal];
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
        [_btQQ addTarget:self action:@selector(QQClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btQQ;
}

- (UIButton *)btWechat {
    if (!_btWechat) {
        _btWechat = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btWechat setBackgroundImage:Image(@"ico_btn4") forState:UIControlStateNormal];
        [_btWechat addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btWechat;
}

- (void)dealloc {
    NSLog(@"%@释放了", [NSString stringWithUTF8String:object_getClassName(self)]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
