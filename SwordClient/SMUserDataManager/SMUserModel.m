//
//  SMUserModel.m
//  ScienceCommission
//
//  Created by ios on 16/9/19.
//  Copyright © 2016年 SC. All rights reserved.
//

#import "SMUserModel.h"
//#import <LKDBHelper/LKDBHelper.h>
//#import "NSDate+Utilities.h"

@implementation SMUserModel
MJCodingImplementation
+(NSDictionary*)replacedKeyFromPropertyName
{
    return @{
             @"name":@"data.name",
             @"qqAccount":@"data.qq",
             @"userId":@"data.uid",
             @"departmentName":@"data.com_name",
             @"isOpenMusic":@"data.is_music",
             @"isOpenNotice":@"data.is_open",
             @"isOpenShake":@"data.is_shake",
             @"wechat":@"data.wechat",
             @"token":@"data.token",
             @"avatar":@"data.avatar",
             @"mobile":@"data.mobile"
             };
}
//获取用户信息
+ (SMUserModel *)getUserData{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"userdataWXL.archiver"];
    SMUserModel *userDataModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (userDataModel==nil) {
        userDataModel = [[SMUserModel alloc]init];
        [SMUserModel saveUserData:userDataModel];
    }
    return userDataModel;
}

//存储用户信息
+ (void)saveUserData:(SMUserModel *)model{
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"userdataWXL.archiver"];
    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}

@end
