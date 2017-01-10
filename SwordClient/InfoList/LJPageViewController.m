//
//  LJPageViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/10.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJPageViewController.h"
#import "LJConnectUsViewController.h"
#import "LJPersonInfoViewController.h"
#import "LJMenuView.h"

@interface LJPageViewController ()

@property (nonatomic, strong) LJMenuView *menusView;

@end

@implementation LJPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[Image(@"ico_menu") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.navigationController.navigationBar.translucent=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuView) name:@"HideMenuView" object:nil];
    
    [self.view addSubview:self.menusView];
    [self subViewEvent];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - events
- (void)rightItemClick {
    self.menusView.hidden = !self.menusView.hidden;
}

- (void)hideMenuView {
    self.menusView.hidden = YES;
}

- (void)subViewEvent {
    __weak typeof(self) weakSelf = self;
    self.menusView.goConnectUs = ^ {
        LJConnectUsViewController *connectUs = [[LJConnectUsViewController alloc] init];
        [weakSelf.navigationController pushViewController:connectUs animated:YES];
    };
    
    self.menusView.goInfoList = ^ {
//        if (weakSelf.listType == 1) {
//            weakSelf.listType = 2;
//        } else {
//            weakSelf.listType =1;
//        }
//        [weakSelf.listView reloadData];
    };
    
    self.menusView.goPersonInfo = ^ {
        LJPersonInfoViewController *presonInfo = [[LJPersonInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:presonInfo animated:YES];
    };
}

- (LJMenuView *)menusView {
    if (!_menusView) {
        _menusView = [[LJMenuView alloc] initWithFrame:CGRectMake(0, 0, 215, 168)];
        _menusView.right = kScreenWidth - 9;
        _menusView.top = 4.5;
        _menusView.image = Image(@"pic_menuBg");
        _menusView.userInteractionEnabled = YES;
        _menusView.hidden = YES;
    }
    return _menusView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
