//
//  LJForggetPasswordViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJForggetPasswordViewController.h"
#import "LJForgetPasswordViewController2.h"
#import "SMEncryptTool.h"

@interface LJForggetPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *tintLabel;
@property (nonatomic, strong) UIButton *btNext;

@end

@implementation LJForggetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"验证码登录";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.tintLabel];
    [self.view addSubview:self.btNext];
    [self layout];
}


- (void)goNextView {
    [self.phoneText resignFirstResponder];
    if (self.phoneText.text.length != 11) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号"];
        return;
    } else if (![SMEncryptTool isValidPhoneNumber:self.phoneText.text]) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"手机号不合法"];
    }
    
    [self getVerifyCode];
}

- (void)getVerifyCode {
//    NSDictionary *param = @{@"mobile" : self.phoneText.text,
//                            @"type" : @"codelogin"};
//    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    NSDictionary *param = @{@"mobile" : self.phoneText.text,
                            @"type" : @"codelogin"};
    __weak typeof(self) weakSelf = self;
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            
            LJForgetPasswordViewController2 *vc = [[LJForgetPasswordViewController2 alloc] init];
            vc.phoneNumber = weakSelf.phoneText.text;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [MBProgressHUD showHUDAddedTo:weakSelf.view withText:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view withText:@"获取验证码失败，请稍后再试"];
    }];
}

//当手机号码大于11位时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneText) {
        NSString *phoneStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        phoneStr  = [phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        UIButton *btRight = (UIButton *)[self.view viewWithTag:100];
        if (phoneStr.length == 11 && [SMEncryptTool isValidPhoneNumber:phoneStr]) {
            
            btRight.hidden = NO;
        } else {
            btRight.hidden = YES;
        }
        if (phoneStr.length >11) {
            return NO;
        }
    }
    return YES;
}


- (void)popClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layout {
    CGFloat topOffset = 30;
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
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.delegate = self;
        
        UIView *leftView = [UIView new];
        leftView.frame = CGRectMake(0, 0, 10, 1);
        _phoneText.leftView = leftView;
        _phoneText.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView addTarget:self action:@selector(getVerifyCode) forControlEvents:UIControlEventTouchUpInside];
        [rightView setImage:Image(@"ico_btn9") forState:UIControlStateDisabled];
        rightView.enabled = NO;
        rightView.frame = CGRectMake(0, 0, 50, 100);
        rightView.right = kScreenWidth - 30;
        rightView.tag = 100;
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
