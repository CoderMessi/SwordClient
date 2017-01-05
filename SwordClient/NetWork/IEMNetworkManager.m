//
//  IEMNetworkManager.m
//  IermuV2
//
//  Created by alluo on 15/12/10.
//  Copyright © 2015年 iermu-xiaoqi.zhang. All rights reserved.
//

#import "IEMNetworkManager.h"

#import <SDVersion/SDVersion.h>

@interface IEMNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation IEMNetworkManager

#pragma mark - Create Singleton

+ (instancetype)sharedInstance {
    static IEMNetworkManager *networkManager = nil;
    IEMDISPATCH_ONCE_BLOCK(^{
        networkManager = [[self alloc] init];
    });
    
    return networkManager;
}

#pragma mark - Is Reachable

- (BOOL)isReachable {
    return self.httpSessionManager.reachabilityManager.isReachable;
}

#pragma mark - Cancel All Request

- (void)cancelAllRequest {
    [self.httpSessionManager.operationQueue cancelAllOperations];
}

#pragma mark - Get Method

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters 
                      success:(void (^)(NSURLSessionDataTask *, id))success 
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSURLSessionDataTask *dataTask =
    [self.httpSessionManager GET:URLString
                      parameters:parameters
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             if (success) {
                                 success(task, responseObject);
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             if (failure) {
                                 failure(task, error);
                             }
                         }];
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters 
                       success:(void (^)(NSURLSessionDataTask *, id))success 
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSURLSessionDataTask *dataTask =
    [self.httpSessionManager POST:URLString 
                       parameters:parameters 
                         progress:nil 
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              if (success) {
                                  success(task, responseObject);
                              }
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (error) {
                                  failure(task, error);
                              }
                          }];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                     fileParam:(NSDictionary *)fileParam
                       success:(void (^)(NSURLSessionDataTask *, id))success
                       failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSURLSessionDataTask *uploadTask =
    [self.httpSessionManager POST:URLString
                       parameters:parameters 
        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSArray * keys = [fileParam allKeys];
            for (NSString * key in keys) {
                [formData appendPartWithFileData:[fileParam objectForKey:key]
                                            name:key
                                        fileName:@"a.jpg"
                                        mimeType:@"image/jpeg"];
            }
        }
                         progress:^(NSProgress * _Nonnull uploadProgress) {
                            
                         }
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              if (success) {
                                  success(task, responseObject);
                              }
                          }
                          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              if (failure) {
                                  failure(task, error);
                              }
                          }];
    
    return uploadTask;
}

#pragma mark - User Agent

- (NSString *)userAgent {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
    NSString *appVersion = LJAPPBUILDVERSION;
    NSString *platform = stringFromDeviceVersion([SDVersion deviceVersion]);
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *userAgent =
    [NSString stringWithFormat:@"%@/%@(%@;iOS %@)", appName, appVersion, platform, systemVersion];
    
    return userAgent;
}

#pragma mark - Setters And Getters

- (AFHTTPSessionManager *)httpSessionManager {
    if (!_httpSessionManager) {
        _httpSessionManager = [AFHTTPSessionManager manager];
        
        //_httpSessionManager.securityPolicy.validatesDomainName = NO;
        //_httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
        
        _httpSessionManager.requestSerializer.timeoutInterval = 40.0f;
        [_httpSessionManager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
        
        // 接口返回text/html 、application/json两种类型数据
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        
        //_httpSessionManager.operationQueue.maxConcurrentOperationCount = 5;
        
        // 网络活动指示器
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 开始网络状态检测
        [_httpSessionManager.reachabilityManager startMonitoring];
        [_httpSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            BOOL reachable = NO;
            if (status == AFNetworkReachabilityStatusReachableViaWWAN
                || status == AFNetworkReachabilityStatusReachableViaWiFi) {
                reachable = YES;
            }
        }];
    }
    
    return _httpSessionManager;
}

@end
