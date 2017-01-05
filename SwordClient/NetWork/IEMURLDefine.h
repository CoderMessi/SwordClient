//
//  IEMURLDefine.h
//  IermuV2
//
//  Created by alluo on 16/2/15.
//  Copyright © 2016年 iermu-xiaoqi.zhang. All rights reserved.
//

#ifndef IEMURLDefine_h
#define IEMURLDefine_h

#define kIEMHTTP                    @"http://"
#define kIEMHTTPs                   @"https://"

/**
 *  Iermu相关接口
 */
#define kIEMAPIDomainName           @"api.iermu.com"
#define kIEMFSVDomainName           @"upload.iermu.com"

#define kIEMAPIVersion              @"v2"
#define kIEMOAuthVersion            @"oauth2"

#define kIEMOAuthPath               @"/" kIEMOAuthVersion
#define kIEMPassportUserPath        @"/" kIEMAPIVersion @"/passport/user"
#define kIEMHomeUserPath            @"/" kIEMAPIVersion @"/home/user"
#define kIEMDeviceInfoPath          @"/" kIEMAPIVersion @"/pcs/device"
#define kIEMPushPath                @"/" kIEMAPIVersion @"/push"
#define kIEMActivityPath            @"/" kIEMAPIVersion @"/app/client"
#define kIEMSearchPath              @"/" kIEMAPIVersion @"/search"
#define kIEMUploadAvatarPath        @"/user/avatar"

#define kIEMBaseOAuthURL            kIEMHTTPs kIEMAPIDomainName kIEMOAuthPath
#define kIEMBasePassportUserURL     kIEMHTTPs kIEMAPIDomainName kIEMPassportUserPath
#define kIEMBaseHomeUserURL         kIEMHTTPs kIEMAPIDomainName kIEMHomeUserPath
#define kIEMBaseDeviceInfoURL       kIEMHTTPs kIEMAPIDomainName kIEMDeviceInfoPath
#define kIEMBasePushURL             kIEMHTTPs kIEMAPIDomainName kIEMPushPath
#define kIEMBaseActivityURL         kIEMHTTPs kIEMAPIDomainName kIEMActivityPath
#define kIEMBaseSearchURL           kIEMHTTPs kIEMAPIDomainName kIEMSearchPath
#define kIEMBaseUploadAvatarURL     kIEMHTTP kIEMFSVDomainName kIEMUploadAvatarPath

//  OAuth
#define kIEMRequestBaiDuOAuthCode   kIEMBaseOAuthURL @"/authorize"  //  获取百度授权码
#define kIEMGetAccessTokenURL       kIEMBaseOAuthURL @"/token"      //  获取AccessToken
#define kIEMGetScanOAuthInfoURL     kIEMBaseOAuthURL @"/qrcode/scan"//  获取扫码登录信息
#define kIEMScanLoginAuthURL        kIEMBaseOAuthURL @"/qrcode/auth"//  获取扫码登录信息

//  用户
#define kIEMGetPassportUserInfoURL  kIEMBasePassportUserURL         //  获取用户信息
#define kIEMGetHomeUserInfoURL      kIEMBaseHomeUserURL
#define kIEMUploadAvatarURL         kIEMBaseUploadAvatarURL         //  上传头像

//  分享订阅
#define kIEMSubscribeURL            kIEMBaseDeviceInfoURL

//  授权
#define kIEMGrantURL                kIEMBaseDeviceInfoURL

//  流媒体
#define kIEMStreamMediaURL          kIEMBaseDeviceInfoURL

//  设备
#define kIEMDeviceInfoURL           kIEMBaseDeviceInfoURL
#define kIEMGetADURL                kIEMHTTPs kIEMAPIDomainName @"/" kIEMAPIVersion @"/ad"
                                                                    //  获取首页图
//  搜索
#define kIEMSearchURL               kIEMBaseSearchURL

//  设置
#define kIEMSettingURL              kIEMBaseDeviceInfoURL

//  推送
#define kIEMRegisterPushURL         kIEMBasePushURL @"/client"      //  app推送信息注册接口

//  工具（活动）
#define kIEMGetActivityURL          kIEMBaseActivityURL             //  获取活动海报


/**
 *  BaiDu相关接口
 */
#define kBaiDuDominName             @"pcs.baidu.com"

#define kBaiDuAPIVersion            @"rest/2.0"

#define kBaiDuFilePath              @"/" kBaiDuAPIVersion @"/pcs/file"
#define kBaiDuDeviceInfoPath        @"/" kBaiDuAPIVersion @"/pcs/device"
#define kBaiDuThumbnailPath         @"/" kBaiDuAPIVersion @"/pcs/thumbnail"

#define kBaiDuBaseFileURL           kIEMHTTPs kBaiDuDominName kBaiDuFilePath
#define kBaiDuBaseDeviceURL         kIEMHTTPs kBaiDuDominName kBaiDuDeviceInfoPath
#define kBaiDuBaseThumbnailURL      kIEMHTTPs kBaiDuDominName kBaiDuThumbnailPath

#define kBaiDuFileURL               kBaiDuBaseFileURL
#define kBaiDuDeviceURL             kBaiDuBaseDeviceURL
#define kBaiDuThumbnailURL          kBaiDuBaseThumbnailURL

#endif /* IEMURLDefine_h */
