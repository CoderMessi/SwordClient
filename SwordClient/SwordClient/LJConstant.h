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

#define KServerUrl @"http://api.loulan360.com"


// app版本
#define LJAPPBUILDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// dispath one block
#define IEMDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width


#define Image(imageName) [UIImage imageNamed:imageName]
#define HexColor(hexColor, alpha) [UIColor colorWithHexString:hexColor withAlpha:alpha]
#define Font(fontSize) [UIFont systemFontOfSize:fontSize]


#endif /* LJConstant_h */
