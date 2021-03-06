//
//  LJChangeMobileViewController.m
//  SwordClient
//
//  Created by songruihang on 2017/1/9.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJChangeMobileViewController.h"
#import "LJGetVerifyViewController.h"
#import "SMEncryptTool.h"

@interface LJChangeMobileViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneText;
@property (nonatomic, strong) UILabel *tintLabel;
@property (nonatomic, strong) UIButton *btNext;

@end

@implementation LJChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"信息修改";
    self.view.backgroundColor = ViewBGColor;
    
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.tintLabel];
    [self.view addSubview:self.btNext];
    [self layout];
}

- (void)sureClick {
    [self.phoneText resignFirstResponder];
    if (self.phoneText.text.length != 11) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确手机号"];
        return;
    } else if (![SMEncryptTool isValidPhoneNumber:self.phoneText.text]) {
        [MBProgressHUD showHUDAddedTo:self.view withText:@"手机号不合法"];
        return;
    }
    
    NSDictionary *param = @{@"mobile" : self.phoneText.text,
                            @"type" : @"checkmobile"};
    [NetWorkTool executePOST:@"/api/system/sendsms" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] != 0) {
            [MBProgressHUD showHUDAddedTo:self.view withText:[responseObject objectForKey:@"msg"]];
        } else {
            
            LJGetVerifyViewController *getCode = [[LJGetVerifyViewController alloc] init];
            getCode.mobile = self.phoneText.text;
            [self.navigationController pushViewController:getCode animated:YES];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - textField delegate
//当手机号码大于11位时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.phoneText) {
        NSString *phoneStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        phoneStr  = [phoneStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (phoneStr.length >11) {
            [self.phoneText resignFirstResponder];
            return NO;
        }
    }
    return YES;
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
        _phoneText.text = self.mobile;
        _phoneText.font = Font(15);
        _phoneText.keyboardType = UIKeyboardTypeNumberPad;
        _phoneText.delegate = self;
        
        UILabel *leftView = [UILabel new];
        leftView.frame = CGRectMake(0, 0, 80, 50);
        leftView.text = @"手机号：";
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
        _tintLabel.text = @"请输入手机号";
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
