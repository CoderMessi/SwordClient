//
//  IEMNetworkManager.h
//  IermuV2
//
//  Created by alluo on 15/12/10.
//  Copyright © 2015年 iermu-xiaoqi.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface IEMNetworkManager : NSObject

/**
 *  创建单例
 *
 *  @return self
 */
+ (instancetype)sharedInstance;

/**
 *  检测外网联通性
 *
 *  @return BOOL
 */
- (BOOL)isReachable;

/**
 *  取消全部请求
 */
- (void)cancelAllRequest;

/**
 *  Get请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters 
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Post请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters 
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  Post上传图片
 *
 *  @param URLString  URLString description
 *  @param parameters parameters description
 *  @param fileParam  fileParam description
 *  @param success    success description
 *  @param failure    failure description
 *
 *  @return NSURLSessionUploadTask
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                       fileParam:(NSDictionary *)fileParam
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
