//
//  MBProgressHUD+LJToast.h
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (LJToast)

/**
 *  显示loading和文字提示
 *
 *  @param view 在哪个View上显示
 *  @param text 显示的文字
 */
+ (void)showLoadingHUDAddedTo:(UIView *)view withText:(NSString *)text;

/**
 *  显示提示性的hud, 没有loading状态
 *
 *  @param view 在哪个View上显示
 *  @param text 显示的文字
 */
+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text;

@end
