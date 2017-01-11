//
//  AppDelegate.h
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/4.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJLoginDelegate <NSObject>

@optional
- (void)loginWXSuccessWithCode:(NSString *)code;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) id<LJLoginDelegate>loginDelegate;

- (void)jumpToLoginVC;
- (void)jumpToInfoListVC;

@end

