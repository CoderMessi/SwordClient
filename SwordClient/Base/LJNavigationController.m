//
//  LJNavigationController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/6.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJNavigationController.h"

@interface LJNavigationController ()

@end

@implementation LJNavigationController

+ (void)load{
    /** 设置UINavigationBar的默认属性 */
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    NSDictionary *titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [navigationBar setTitleTextAttributes:titleTextAttributes];
    /** 设置UIBarButtonItem的默认属性 */
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[self imageWithColor:ColorBlue]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    __weak __typeof(self) weakSelf = self;
    self.interactivePopGestureRecognizer.enabled = YES ;
//    self.interactivePopGestureRecognizer.delegate = weakSelf;
    self.navigationBar.translucent = YES;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
