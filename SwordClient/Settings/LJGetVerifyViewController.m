//
//  LJGetVerifyViewController.m
//  SwordClient
//
//  Created by songruihang on 2017/1/9.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJGetVerifyViewController.h"
#import "LJPersonInfoViewController.h"

@interface LJGetVerifyViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *codeText;
@property (nonatomic, strong) UIButton *btReGet;
@property (nonatomic, strong) UIButton *btDone;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger second;

@property (nonatomic, strong) SMUserModel *user;
@end

@implementation LJGetVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获取验证码";
    self.view.backgroundColor = ViewBGColor;
    self.second = 60;
    self.user = [SMUserModel getUserData];
    
    [self.view addSubview:self.codeText];
    [self.view addSubview:self.btDone];
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getVerifyCode];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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
    
    NSDictionary *param = @{@"mobile" : self.mobile,
                            @"type" : @"checkmobile"};
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] != 0) {
            [MBProgressHUD showHUDAddedTo:self.view withText:[responseObject objectForKey:@"msg"]];
        } else {
            self.btReGet.enabled = NO;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)doneClick {
    if (self.codeText.text.length == 0) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入验证码"];
        return;
    }
    
    NSDictionary *param = @{@"uid" : [NSNumber numberWithInteger:self.user.userId],
                            @"ver_code" : self.codeText.text,
                            @"mobile" : self.mobile};
    [NetWorkTool executePOST:@"/api/cuser/checkmobile" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            self.user.mobile = self.mobile;
            [SMUserModel saveUserData:self.user];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LJPersonInfoViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        } else {
            [MBProgressHUD showHUDAddedTo:self.view withText:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"修改失败，请稍后再试"];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.codeText) {
        if (range.location >= 6) {
            NSString *text = textField.text;
            self.codeText.text = [text substringToIndex:6];
            [self.codeText resignFirstResponder];
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
    
    [self.btDone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeText.mas_bottom).offset(50);
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
//        _btReGet.enabled = NO;
        [_btReGet addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [_btReGet setTitle:@"重新获取" forState:UIControlStateNormal];
        [_btReGet setTitleColor:[UIColor colorWithHexString:@"454545"] forState:UIControlStateNormal];
        [_btReGet setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
        [rightView addSubview:_btReGet];
        
    }
    return _codeText;
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
