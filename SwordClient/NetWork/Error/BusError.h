//
//  BusError.h
//  IermuV2TestDemo
//
//  Created by iermu-xiaoqi.zhang on 15/9/10.
//  Copyright (c) 2015年 iermu-xiaoqi.zhang. All rights reserved.
//o
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IEMAPIErrorCode) {
    IEMAPIErrorCode_NotKnown                        = -1010, //未匹配到的错误码
    IEMAPIErrorCode_Timeout                         = -2102, // 超时
    IEMAPIErrorCode_4GStreamError                   = 50,    //4G断网
    IEMAPIErrorCode_StreamError                     = 8,     // 断网
    IEMAPIErrorCode_NoReachable                     = -1009, // 没网
    
    // 注册
    IEMAPIErrorCode_Register_UserNameInvalid        = 40031, // 用户名无效
    IEMAPIErrorCode_Register_UserNameBadWord        = 40032, // 用户名禁用
    IEMAPIErrorCode_Register_UserNameExists         = 40033, // 用户名已存在
    IEMAPIErrorCode_Register_UserEmailFormatInvalid = 40034, // 邮箱格式非法
    IEMAPIErrorCode_Register_UserEmailAccessIllegal = 40035, // 邮箱禁用
    IEMAPIErrorCode_Register_UserEmailExists        = 40036, // 邮箱已存在
    IEMAPIErrorCode_Register_UserAddFailed          = 40038, // 注册用户失败
    IEMAPIErrorCode_Register_InvalidClientRequest   = 40101, // 无效的用户请求
    
    // 登录
    IEMAPIErrorCode_LogIn_InvalidClientRequest      = 40014, // 无效的用户请求
    IEMAPIErrorCode_LogIn_UserNotExist              = 40120, // 用户不存在
    IEMAPIErrorCode_LogIn_UserPasswordError         = 40121, // 用户密码错误
    
    // 修改用户名
    IEMAPIErrorCode_ChangeUserName_NoAuth           = 40102, // 无权限
    IEMAPIErrorCode_ChangeUserName_Failed           = 400411,// 修改用户名失败（服务端内部错误）
    
    // 修改密码
    IEMAPIErrorCode_ChangeUserPassword_Failed       = 40039, // 修改密码失败（服务端内部错误）
    
    // 完善用户资料
    IEMAPIErrorCode_CompleteProfile_AlreadyComplted = 40050, // 资料完整不需要完善
    IEMAPIErrorCode_CompleteProfile_Failed          = 40051, // 完善资料失败（服务端内部错误）    
};

@interface BusError : NSObject

@property (nonatomic, assign) NSInteger requestID;

@property (nonatomic, assign) int connectType;

@property (nonatomic, assign) IEMAPIErrorCode errorCode;
@property (nonatomic,   copy) NSString *errorMsg;

@property (nonatomic,   copy) NSString *userName; // 不一定都有

@end
