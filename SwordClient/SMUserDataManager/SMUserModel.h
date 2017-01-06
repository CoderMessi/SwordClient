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
    SCLoginStateOnline = 200,/** 在线 */
    SCLoginStateDropped /** 掉线 */
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
@property (nonatomic, copy)NSString *fullname;
/** QQ */
@property (nonatomic, copy)NSString *qqAccount;
/** 公司名 */
@property (nonatomic, copy) NSString *departmentName;
/** 身份 */
@property (nonatomic,assign) NSInteger role;
/** token */
@property (nonatomic,copy) NSString *token;
/** 制度链接 */
@property (nonatomic,copy) NSString *zhiduurl;
/** IB */
@property (nonatomic,copy) NSString *ib;
/** 登录的状态 */
@property (nonatomic, assign) SCLoginState loginState;

//获取用户信息
+ (SMUserModel *)getUserData;

//存储用户信息
+ (void)saveUserData:(SMUserModel *)model;
@end
