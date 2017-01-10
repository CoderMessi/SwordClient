//
//  LJChangeNameViewController.h
//  SwordClient
//
//  Created by songruihang on 2017/1/9.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "LJBaseViewController.h"

typedef NS_ENUM(NSUInteger, LJChangeType) {
    LJTypeName,
    LJTypeQQ,
    LJTypeWechat,
};

@interface LJChangeNameViewController : LJBaseViewController

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) LJChangeType changeType;

@end
