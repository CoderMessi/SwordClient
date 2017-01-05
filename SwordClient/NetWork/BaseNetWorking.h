//
//  IermuNetWorking.h
//  IermuV2TestDemo
//
//  Created by iermu-xiaoqi.zhang on 15/9/6.
//  Copyright (c) 2015年 iermu-xiaoqi.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BusError.h"

@interface BaseNetWorking : NSObject

+ (BaseNetWorking *)api;

/**
 *  get请求
 *
 *  @param urlStr  urlStr
 *  @param param   param
 *  @param success success
 *  @param failed  failed
 */
- (void)get:(NSString *)urlStr
      param:(NSDictionary *)param
responseSuccessBlock:(void (^)(id responseData))success failed:(void (^)(BusError *error))failed;

/**
 *  post请求
 *
 *  @param urlStr  urlStr
 *  @param param   param
 *  @param success success
 *  @param failed  failed
 */
- (void)post:(NSString *)urlStr
       param:(NSDictionary *)param
responseSuccessBlock:(void (^)(id responseData))success failed:(void (^)(BusError *error))failed;

/**
 *  上传数据
 *
 *  @param urlStr    urlStr
 *  @param param     param
 *  @param fileParam fileParam
 *  @param success   success
 *  @param failed    failed
 */
- (void)post:(NSString *)urlStr
       param:(NSDictionary *)param
   fileParam:(NSDictionary *)fileParam
     success:(void(^)(id responseData))success failure:(void(^)(BusError * error))failed;

@end
