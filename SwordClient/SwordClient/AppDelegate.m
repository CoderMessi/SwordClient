//
//  AppDelegate.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/4.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "AppDelegate.h"
#import "LJLoginViewController.h"
#import "LJNavigationController.h"
#import "LJInfoListViewController.h"
#import "LJInfoListViewController2.h"
#import <sys/utsname.h>

#import <UMMobClick/MobClick.h>
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>

#import "SMUserModel.h"
#import "LJPageViewController.h"
#import "LJLaunchViewController.h"


@interface AppDelegate () <UNUserNotificationCenterDelegate, WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    
    //友盟统计
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 友盟推送
    [UMessage startWithAppkey:kUMAppKey launchOptions:launchOptions];
    
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
            
        }
    }];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    
    // 微信
    [WXApi registerApp:kWechatAppID withDescription:@"wechat"];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToLoginVC:) name:@"jumpToLoginVC" object:nil];
    
//    [self goAppController];
    LJLaunchViewController *launchVc = [[LJLaunchViewController alloc] init];
    self.window.rootViewController = launchVc;

    return YES;
}


- (void) jumpToLoginVC:(NSNotification *)noti {
    SMUserModel *userModel = [[SMUserModel alloc]init];
    userModel.loginStatus = SCLoginStateDropped;
    [SMUserModel saveUserData:userModel];
    [self jumpToLoginVC];
}


- (void)jumpToLoginVC {
    LJLoginViewController *loginVc = [[LJLoginViewController alloc] init];
    self.window.rootViewController = loginVc;
}

- (void)jumpToInfoListVC {
    NSArray *viewControllers = @[[LJInfoListViewController class], [LJInfoListViewController2 class]];
    LJPageViewController *pageVc = [[LJPageViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:@[@"",@""]];
    pageVc.title = @"消息列表";
    pageVc.menuHeight = 0;
    LJNavigationController *nav = [[LJNavigationController alloc] initWithRootViewController:pageVc];
    self.window.rootViewController = nav;
}

- (void)goAppController {
    SMUserModel *user = [SMUserModel getUserData];
    if (user.loginStatus == SCLoginStateOnline) {
        [self jumpToInfoListVC];
    } else {
        [self jumpToLoginVC];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[url absoluteString] hasPrefix:@"tencent"]) {
        [TencentOAuth HandleOpenURL:url];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        // 微信登录授权的类
        SendAuthResp *temp = (SendAuthResp *)resp;
        if (temp.errCode == 0) {
            if ([self.loginDelegate respondsToSelector:@selector(loginWXSuccessWithCode:)]) {
                [self.loginDelegate loginWXSuccessWithCode:temp.code];
            }
        } else {
            NSLog(@"微信登录失败>>>%@", temp.errStr);
        }
    }
    else {
        //
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    // [UMessage registerDeviceToken:deviceToken];
    [self initDataWithDeviceToken:[self stringDevicetoken:deviceToken]];
    
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self initDataWithDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)initDataWithDeviceToken:(NSString *)token{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[[UIDevice currentDevice]systemVersion] forKey:@"sv"];
    [dic setValue:[[UIDevice currentDevice]systemVersion] forKey:@"version"];
    [dic setValue:[self iphoneType] forKey:@"hw"];
    [dic setValue:@"1" forKey:@"type"];
    [dic setValue:token forKey:@"device_token"];
    [NetWorkTool executePOST:@"/api/system/cinfo" paramters:dic success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

-(NSString *)stringDevicetoken:(NSData *)deviceToken{
    NSString *tokenDes = [deviceToken description];
    NSString *pushToken = [[[tokenDes stringByReplacingOccurrencesOfString:@"<"withString:@""]stringByReplacingOccurrencesOfString:@">"withString:@""] stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

- (NSString *)iphoneType {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}

@end
