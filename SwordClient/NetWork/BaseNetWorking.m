//
//  IermuNetWorking.m
//  IermuV2TestDemo
//
//  Created by iermu-xiaoqi.zhang on 15/9/6.
//  Copyright (c) 2015年 iermu-xiaoqi.zhang. All rights reserved.
//

#import "BaseNetWorking.h"
#import "IEMNetworkManager.h"

@interface BaseNetWorking ()

@property (nonatomic, strong) IEMNetworkManager *networkManager;

@end

@implementation BaseNetWorking

+ (BaseNetWorking *)api{
    BaseNetWorking *network = [[BaseNetWorking alloc] init];
    return network;
}

#pragma mark - Get Method

- (void)get:(NSString *)urlStr param:(NSDictionary *)param responseSuccessBlock:(void (^)(id responseData))success failed:(void (^)(NSError *error))failed
{
    [self.networkManager GET:urlStr
                  parameters:param
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         if (success) {
                             success(responseObject);
                         }
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         if (failed) {
                             failed(error);
                         }
                     }];
}

#pragma mark - Post Method

- (void)post:(NSString *)urlStr param:(NSDictionary *)param responseSuccessBlock:(void (^)(id))success
      failed:(void (^)(NSError *))failed
{
    [self.networkManager POST:urlStr
                   parameters:param
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          if (success) {
                              success(responseObject);
                          }
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          if (failed) {
                              failed(error);
                          }
                      }];
}

- (void)post:(NSString *)urlStr param:(NSDictionary *)param fileParam:(NSDictionary *)fileParam success:(void (^)(id))success failure:(void(^)(NSError * error))failed
{
    [self.networkManager POST:urlStr
                   parameters:[self paramsWithDict:param] 
                    fileParam:fileParam 
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          if (success) {
                              success(responseObject);
                          }
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          if (failed) {
                              failed(error);
                          }
                      }];
}

#pragma mark - Private Method

- (NSMutableDictionary *)paramsWithDict:(NSDictionary *)parameters {
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    return dictParams;
}

- (void)handleFailure:(NSURLSessionDataTask *)task error:(NSError *)error failedBlock:(void(^)(BusError * error))failed
{
    BusError *busError = [BusError new];
    NSString* respDataError = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    
    
    if (failed) {
        failed(busError);
    }
}

#pragma mark - Setters And Getters

- (IEMNetworkManager *)networkManager {
    return [IEMNetworkManager sharedInstance];
}

@end
