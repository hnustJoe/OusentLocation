//
//  AccountManager.h
//  欧深特GPS
//
//  Created by joe on 2016/11/28.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

+ (AccountManager *)shareInstance;

@property (nonatomic,strong) NSMutableArray *selectArr;

@end
