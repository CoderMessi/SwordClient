//
//  SMEncryptTool.h
//  SwordMembers
//
//  Created by 张淼 on 2016/12/24.
//  Copyright © 2016年 MayBee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMEncryptTool : NSObject
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)encryptWithText:(NSString *)sText;
+ (NSString *)decryptWithText:(NSString *)sText;
+ (NSString *) md5:(NSString *)str;
@end
