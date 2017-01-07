//
//  LJMenuView.h
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/7.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJMenuView : UIImageView

@property (nonatomic, copy) void (^goConnectUs)(void);
@property (nonatomic, copy) void (^goInfoList)(void);
@property (nonatomic, copy) void (^goPersonInfo)(void);

@end
