//
//  LJMenuView.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJMenuView.h"

@interface LJMenuView ()

@property (nonatomic, strong) UIButton *btConnectUs;
@property (nonatomic, strong) UIButton *btInfoList;
@property (nonatomic, strong) UIButton *btPersonInfo;

@end

@implementation LJMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.btConnectUs];
        [self addSubview:self.btInfoList];
        [self addSubview:self.btPersonInfo];
        [self initLines];
        
        [self layout];
    }
    return self;
}

#pragma mark event
- (void)connectUsClick {
    if (self.goConnectUs) {
        self.hidden = YES;
        self.goConnectUs();
    }
}

- (void)infoListClick {
    if (self.goInfoList) {
        self.hidden = YES;
        self.goInfoList();
    }
}

- (void)personInfoClick {
    if (self.goPersonInfo) {
        self.hidden = YES;
        self.goPersonInfo();
    }
}

#pragma mark - layout
- (void)layout {
    CGFloat btHeight = 50;
    [self.btPersonInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(btHeight);
    }];
    
    [self.btInfoList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.btPersonInfo);
        make.bottom.equalTo(self.btPersonInfo.mas_top);
    }];
    
    [self.btConnectUs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(btHeight);
        make.bottom.equalTo(self.btInfoList.mas_top);
    }];
}

#pragma mark - UI
- (void)initLines {
    CGFloat offset = 10;
    CGFloat btHeight = 51;
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor whiteColor];
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(offset);
        make.right.equalTo(self).offset(-offset);
        make.bottom.equalTo(self).offset(- 2*btHeight);
        make.height.mas_equalTo(0.5);
    }];
    
    UIView *line2 = [UIView new];
    line2.backgroundColor = [UIColor whiteColor];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(line1);
        make.bottom.equalTo(self).offset(-btHeight);
    }];
}


- (UIButton *)btConnectUs {
    if (!_btConnectUs) {
        _btConnectUs = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btConnectUs setImage:Image(@"ico_phone2") forState:UIControlStateNormal];
        [_btConnectUs setTitle:@"联系我们" forState:UIControlStateNormal];
        [_btConnectUs setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_btConnectUs addTarget:self action:@selector(connectUsClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_btConnectUs setImageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        [_btConnectUs setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
    return _btConnectUs;
}

- (UIButton *)btInfoList {
    if (!_btInfoList) {
        _btInfoList = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btInfoList setImage:Image(@"ico_cope") forState:UIControlStateNormal];
        [_btInfoList setTitle:@"消息列表" forState:UIControlStateNormal];
        [_btInfoList setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_btInfoList addTarget:self action:@selector(infoListClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_btInfoList setImageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        [_btInfoList setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
    return _btInfoList;
}

- (UIButton *)btPersonInfo {
    if (!_btPersonInfo) {
        _btPersonInfo = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btPersonInfo setImage:Image(@"ico_admin") forState:UIControlStateNormal];
        [_btPersonInfo setTitle:@"个人信息" forState:UIControlStateNormal];
        [_btPersonInfo setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_btPersonInfo addTarget:self action:@selector(personInfoClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_btPersonInfo setImageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
        [_btPersonInfo setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
    return _btPersonInfo;
}
@end
