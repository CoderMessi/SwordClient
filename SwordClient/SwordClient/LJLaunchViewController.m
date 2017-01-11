//
//  LJLaunchViewController.m
//  SwordClient
//
//  Created by songruihang on 2017/1/11.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJLaunchViewController.h"
#import "AppDelegate.h"

@interface LJLaunchViewController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIButton *btBack;
@property (nonatomic, strong) UIWebView *web;
@end

@implementation LJLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [self.view addSubview:self.web];
    [self getLaunchInfo];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)getLaunchInfo {
    NSDictionary *param = @{@"type" : [NSNumber numberWithInt:1]};
    [NetWorkTool executePOST:@"/api/system/startpic" paramters:param success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSString *launchUrl = [data objectForKey:@"start_url"];
            NSInteger time = [[data objectForKey:@"start_time"] integerValue];
            self.time = time;
            
            [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:launchUrl]]];
            
            [self.view addSubview:self.btBack];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            
        } else {
            [self backClick];
        }
    } failure:^(NSError *error) {
        [self backClick];
    }];
}

- (void)countDown {
    self.time--;
    [self.btBack setTitle:[NSString stringWithFormat:@"跳过(%ld)", self.time] forState:UIControlStateNormal];
    if (self.time == -1) {
        
        
        [self backClick];
    }
}

- (void)backClick {
    [self.timer invalidate];
    self.timer = nil;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate goAppController];
}

- (UIButton *)btBack {
    if (!_btBack) {
        _btBack = [UIButton buttonWithType:UIButtonTypeCustom];
        _btBack.frame = CGRectMake(kScreenWidth - 17 - 77, 45*RATIO, 77, 25);
        [_btBack setBackgroundImage:Image(@"btn") forState:UIControlStateNormal];
//        _btBack.backgroundColor = [UIColor colorWithRed:69 green:156 blue:208 alpha:1.0];
        _btBack.layer.masksToBounds = YES;
        _btBack.layer.cornerRadius = 25.0/2;
        [_btBack setTitle:[NSString stringWithFormat:@"跳过(%ld)", self.time] forState:UIControlStateNormal];
        [_btBack setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _btBack.titleLabel.font = Font(15);
        [_btBack addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btBack;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
