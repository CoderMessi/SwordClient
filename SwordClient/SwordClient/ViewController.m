//
//  ViewController.m
//  SwordClient
//
//  Created by 宋瑞航 on 2017/1/4.
//  Copyright © 2017年 SRH. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MD5.h"
#import "JKEncrypt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *password = @"123456";
    NSString *md5Password = [NSString stirngToMD5:password];
    NSLog(@"md5>>>%@", md5Password);
    
    NSDictionary *param = @{}
//    NSString *param = 
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
