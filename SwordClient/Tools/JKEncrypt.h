//
//  main.m
//  3DES研究
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 apple. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface JKEncrypt : NSObject

-(NSString *)doEncrypt:(NSString *)plainText;

-(NSString*)doDecEncrypt:(NSString *)encryptText;

@end
