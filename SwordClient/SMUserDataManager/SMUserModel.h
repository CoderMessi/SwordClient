//
//  SMUserModel.h
//  ScienceCommission
//
//  Created by ios on 16/9/19.
//  Copyright © 2016年 SC. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "SMDBBaseModel.h"
#import <MJExtension.h>
//#import "SCOrgStructModel.h"

typedef NS_ENUM(NSUInteger, SCLoginState) {
    SCLoginStateGenjin = 1,         /** 跟进中 */
    SCLoginStateOpening = 2,        /** 开户中 */
    SCLoginStateNewRegister = 3,    /** 新注册 */
    SCLoginStateExpired = 4         // 已过期
};

@interface SMUserModel : NSObject
/** userID */
@property (nonatomic, assign) NSInteger userId;
/** 是否开启勿扰 */
@property (nonatomic, assign) BOOL isOpenNotice;
/** 是否打开震动 */
@property (nonatomic, assign) BOOL isOpenShake;
/** 是否打开声音 */
@property (nonatomic, assign) BOOL isOpenMusic;
/** 头像地址 */
@property (nonatomic, copy) NSString *avatar;
/** 手机号 */
@property (nonatomic, copy) NSString *mobile;
/** 用户名 */
@property (nonatomic, copy)NSString *name;
/** QQ */
@property (nonatomic, copy)NSString *qqAccount;
/** 微信 */
@property (nonatomic, copy) NSString *wechat;
/** token */
@property (nonatomic,copy) NSString *token;

/** 登录的状态 */
@property (nonatomic, assign) SCLoginState status;

//获取用户信息
+ (SMUserModel *)getUserData;

//存储用户信息
+ (void)saveUserData:(SMUserModel *)model;
@end
