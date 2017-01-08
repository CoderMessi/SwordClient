//
//  MBProgressHUD+LJToast.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "MBProgressHUD+LJToast.h"

@implementation MBProgressHUD (LJToast)

+ (void)showLoadingHUDAddedTo:(UIView *)view withText:(NSString *)text {
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    hud.minSize = CGSizeMake(100.0f, 100.0f);
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)showHUDAddedTo:(UIView *)view withText:(NSString *)text {
    [MBProgressHUD hideAllHUDsForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15.0f];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
