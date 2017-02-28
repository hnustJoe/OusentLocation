//
//  AccountManager.m
//  欧深特GPS
//
//  Created by joe on 2016/11/28.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+ (AccountManager *)shareInstance
{
    static AccountManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[AccountManager alloc]init];
    });
    return shareInstance;
}


@end
