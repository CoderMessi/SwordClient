//
//  LJPersonInfoViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJPersonInfoViewController.h"

@interface LJPersonInfoViewController ()

@end

@implementation LJPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popClick)];
}

- (void)popClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
