//
//  NetWorkTool.m
//  PearPsyEnterprise
//
//  Created by zhangyun on 15/4/28.
//  Copyright (c) 2015年 Brightease. All rights reserved.
//

#import "NetWorkTool.h"
#import "MJExtension.h"
#import "SvUDIDTools.h"
#import <AFNetworking.h>
#import <CoreFoundation/CoreFoundation.h>
#import "SMEncryptTool.h"
#import "SMUserModel.h"
NSString * const mbUpdateEmotion = @"v3_3/saveMood";
#define KCheckNetworkUrl    @"http://www.baidu.com"
#define platformStr @"ios"
#define RequestJSOMPrint 1
@implementation NetWorkTool

#pragma mark - POST请求网络 完整返回请求到的数据
+ (void)executePOST:(NSString *)url
          paramters:(id)parameter
            success:(RequestSucceedBlock)requestSuccess
            failure:(RequestFailBlock)requestFail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    url = [NSString stringWithFormat:@"%@%@",KServerUrl,url];
    [NetWorkTool changeSerializerHeader:manager];
    
    NSString *jsonStr = [SMEncryptTool encryptWithText:[parameter JSONString]];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObject:jsonStr forKey:@"param"];
    NSLog(@"url -- %@  param -- %@ encodeParam -- %@",url,parameter,paramDic);
    [manager POST:url parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (requestSuccess) {
            NSString *realJson = [SMEncryptTool decryptWithText:[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[realJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
#if RequestJSOMPrint == 1
            NSLog(@"requestSuccess : %@", dic);
#endif
            if([[dic valueForKey:@"code"]integerValue] == 1099){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToLoginVC" object:nil];
            }
            requestSuccess(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (requestFail) {
            [MBProgressHUD showHint:@"网络出错了，请稍后重试" toView:nil offset:CGPointZero];
            requestFail(error);
#if RequestJSOMPrint == 1
            NSLog(@"RequestErrorMesg : %@", error);
#endif
        }
    }];
}
#pragma mark - 指定GET请求获取 的完整数据
+ (void)executeGET:(NSString *)url
         paramters:(id)parameter
           success:(RequestSucceedBlock)requestSuccess
           failure:(RequestFailBlock)requestFail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [NetWorkTool changeSerializerHeader:manager];
    
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",KServerUrl,url];
    //不需要传参数的情况
    if (parameter == nil) {
        [manager GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (requestSuccess) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                requestSuccess(dict);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (requestFail) {
                requestFail(error);
            }
        }];
        return;
    }
    NSString *jsonStr  = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *completeParameters = @{@"json":jsonStr};
#if RequestJSOMPrint == 1
    NSLog(@"%@%@?json=%@",KServerUrl,url,[parameter JSONString]);
#endif
    [manager GET:completeUrl parameters:completeParameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (requestSuccess) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            requestSuccess(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (requestFail) {
            requestFail(error);
        }
    }];
}
#pragma mark - GET请求网络 过滤返回正确码得到的数据
+ (void)executeGET:(NSString *)url
         paramters:(id)parameter
          response:(ResponseOKBlock)responseOK
           failure:(RequestFailBlock)requestFail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [NetWorkTool changeSerializerHeader:manager];
    
    NSDictionary *parameters = [parameter keyValues];
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",KServerUrl,url];
    [manager GET:completeUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseOK) {
            responseOK(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (requestFail) {
        requestFail(error);
        }
    }];
}
+(void)uploadImageWithUrl:(NSString*)url
                                      params:(NSMutableDictionary*)params
                                 imageParams:(NSMutableArray *)imageParams
                                  httpMethod:(NSString *)httpMethod
                                     success:(ResponseOKBlock)responseOK
                                     failure:(RequestFailBlock)responseFail
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    //get请求
    NSComparisonResult compResult1 =[httpMethod caseInsensitiveCompare:@"GET"];
    if (compResult1 == NSOrderedSame) {
        [request setHTTPMethod:@"GET"];
        NSString *jsonStr = [params JSONString];
        NSLog(@"%@",[NSString stringWithFormat:@"%@?json=%@",url,jsonStr]);
        NSString *urlStr = [NSString stringWithFormat:@"%@?json=%@",url,[jsonStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (urlStr.length > 0)
        {
            [request setURL:[NSURL URLWithString:urlStr]];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [NetWorkTool changeSerializerHeader:manager];
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseOK != nil) {
                responseOK(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (responseFail != nil) {
                responseFail(error);
            }
        }];
    }
    NSLog(@"***%@",request);
    //post请求
    NSComparisonResult compResult2 = [httpMethod caseInsensitiveCompare:@"POST"];
    if (compResult2 == NSOrderedSame) {
        [request setHTTPMethod:@"POST"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [NetWorkTool changeSerializerHeader:manager];
        NSString *jsonStr = [params JSONString];
        NSDictionary *paramDic = [NSDictionary dictionaryWithObject:jsonStr forKey:@"json"];
        NSString *urlString=[NSString stringWithFormat:@"%@%@",KServerUrl,url];
        [manager POST:urlString parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (int j = 0;j<imageParams.count;j++)  {
                if ([imageParams[j] isKindOfClass:[UIImage class]]) {
                    NSData *eachImgData = UIImageJPEGRepresentation(imageParams[j], 0.7);
                    NSString *str;
                    if ([url isEqualToString:@"saveUserInfo"]) {
                        str = @"NSLogo";
                    }else if([url isEqualToString:mbUpdateEmotion]){
                        str = @"moodPic";
                    }
                    [formData appendPartWithFileData:eachImgData name:str fileName:[NSString stringWithFormat:@"img%d.jpg", j+2] mimeType:@"image/jpeg"];
                }
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseOK) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                responseOK(dict);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (responseFail!=nil) {
                responseFail(error);
            }
        }];
    }
}
+ (void)checkNetworkStatus
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark - 指定GET请求获取 的完整数据
+ (void)executeGETNoParamNoKeyUrl:(NSString *)url
           success:(RequestSucceedBlock)requestSuccess
           failure:(RequestFailBlock)requestFail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [NetWorkTool changeSerializerHeader:manager];
    
    NSString *completeUrl =(NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)url,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    [manager GET:completeUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (requestSuccess) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            requestSuccess(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (requestFail) {
            requestFail(error);
        }
    }];
}
#pragma Support NSURLCONNECTION HTTPS
+(void)changeSerializerHeader:(AFHTTPSessionManager *)manager{
//    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
//    NSSet *certSet = [NSSet setWithObject:certData];
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:certSet];
////    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    policy.allowInvalidCertificates = YES;
//    policy.validatesDomainName = NO;
//    manager.securityPolicy = policy;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
    NSString *verstring=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //  保存设备唯一标示
    [manager.requestSerializer setValue:platformStr forHTTPHeaderField:@"os"];
    [manager.requestSerializer setValue:verstring forHTTPHeaderField:@"v"];
    [manager.requestSerializer setValue:[[UIDevice currentDevice] identifierForVendor].UUIDString forHTTPHeaderField:@"deviceid"];
    [manager.requestSerializer setValue:[SMUserModel getUserData].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
}
@end
