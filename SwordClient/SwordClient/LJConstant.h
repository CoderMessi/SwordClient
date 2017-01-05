//
//  LJConstant.h
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/5.
//  Copyright © 2017年 SRH. All rights reserved.
//

#ifndef LJConstant_h
#define LJConstant_h

// app版本
#define LJAPPBUILDVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// dispath one block
#define IEMDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//获取物理屏幕的尺寸
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#endif /* LJConstant_h */
