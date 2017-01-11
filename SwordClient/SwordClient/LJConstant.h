//
//  LJConstant.h
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/5.
//  Copyright © 2017年 SRH. All rights reserved.
//

#ifndef LJConstant_h
#define LJConstant_h

static const char kKeyChainUDIDAccessGroup[] = "com.sword.client";

static NSString *const kQQAppID = @"101373221";
static NSString *const kWechatAppID = @"wx01f4645ef3ae442c";
static NSString *const kUMAppKey = @"5870e981aed17974510018ef";
static NSString *const kWXAppSecret = @"bea7f2d08f757bf2e6665d5a6a278a2f";

#define KServerUrl @"http://api.loulan360.com"


// app版本
#define LJAPPBUILDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// dispath one block
#define IEMDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


#define Image(imageName) [UIImage imageNamed:imageName]
#define HexColor(hexColor, alpha) [UIColor colorWithHexString:hexColor alpha:alpha]
#define Font(fontSize) [UIFont systemFontOfSize:fontSize]

//color
#define ColorBlue [UIColor colorWithHexString:@"1882ce"]
#define ViewBGColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]

#endif /* LJConstant_h */
