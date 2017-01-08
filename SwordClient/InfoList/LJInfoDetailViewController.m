//
//  LJInfoDetailViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/8.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJInfoDetailViewController.h"

@interface LJInfoDetailViewController ()

@end

@implementation LJInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息详情";
    self.view.backgroundColor = ViewBGColor;
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//    [web loadHTMLString:self.urlString baseURL:nil];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:web];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
