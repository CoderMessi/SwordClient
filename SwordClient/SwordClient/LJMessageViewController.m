//
//  LJMessageViewController.m
//  SwordClient
//
//  Created by songruihang on 2017/3/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJMessageViewController.h"

@interface LJMessageViewController ()

@end

@implementation LJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://app.fxacn.tv/common/message/index"]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
