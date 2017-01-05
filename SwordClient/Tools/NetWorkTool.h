//
//  NetWorkTool.h
//  PearPsyEnterprise
//
//  Created by zhangyun on 15/4/28.
//  Copyright (c) 2015年 Brightease. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^RequestSucceedBlock)(id responseObject);
typedef void(^RequestFailBlock)(NSError *error);
typedef void(^ResponseOKBlock)(id responseObject);

@interface NetWorkTool : NSObject <NSURLConnectionDelegate>
@property(nonatomic,copy)RequestSucceedBlock requestSucceedBlock;
@property(nonatomic,copy)RequestFailBlock requestFailBlock;
@property(nonatomic,copy)ResponseOKBlock responseBlock;

/**
 *  POST请求网络 完整返回请求到的数据
 *
 *  @param url            请求URL
 *  @param parameter      请求参数
 *  @param requestSuccess 请求成功返回信息
 *  @param requestFail    请求失败信息
 */
#pragma mark - POST请求网络 完整返回请求到的数据
+ (void)executePOST:(NSString *)url
          paramters:(id)parameter
            success:(RequestSucceedBlock)requestSuccess
            failure:(RequestFailBlock)requestFail;
/**
 *  POST请求网络 过滤返回正确码得到的数据
 *
 *  @param url         请求URL
 *  @param parameter   请求参数
 *  @param responseOK  获取正确码得到的数据
 *  @param requestFail 请求失败信息
 */
#pragma mark - POST请求网络 过滤返回正确码得到的数据
//+ (void)executePOST:(NSString *)url
//          paramters:(id)parameter
//           response:(ResponseOKBlock)responseOK
//            failure:(RequestFailBlock)requestFail;
/**
 *  GET请求
 */
#pragma mark - GET请求网络 过滤返回正确码得到的数据
+ (void)executeGET:(NSString *)url
         paramters:(id)parameter
          response:(ResponseOKBlock)responseOK
           failure:(RequestFailBlock)requestFail;

#pragma mark - GET 返回完全数据
+ (void)executeGET:(NSString *)url
         paramters:(id)parameter
           success:(RequestSucceedBlock)requestSuccess
           failure:(RequestFailBlock)requestFail;

#pragma mark - GET请求网络 过滤返回正确码得到的数据(没有KeyUrl)

+ (void)executeGETNoParamNoKeyUrl:(NSString *)url
                          success:(RequestSucceedBlock)requestSuccess
                          failure:(RequestFailBlock)requestFail;
#pragma mark - 上传图片
+(void)uploadImageWithUrl:(NSString*)url
                   params:(NSMutableDictionary*)params
              imageParams:(NSMutableArray *)imageParams
               httpMethod:(NSString *)httpMethod
                  success:(ResponseOKBlock)responseOK
                  failure:(RequestFailBlock)responseFail;
/**
 *  监控当前网络变化
 */
#pragma mark - 监控当前网络变化
+ (void)checkNetworkStatus;
@end
