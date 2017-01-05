//
//  BusError.m
//  IermuV2TestDemo
//
//  Created by iermu-xiaoqi.zhang on 15/9/10.
//  Copyright (c) 2015年 iermu-xiaoqi.zhang. All rights reserved.
//

#import "BusError.h"

@implementation BusError

- (instancetype)init {
    self = [super init];
    if (self) {
        _errorCode = 0;
        _errorMsg = @"未定义的错误";
        _requestID = 0;
    }
    
    return self;
}

@end
