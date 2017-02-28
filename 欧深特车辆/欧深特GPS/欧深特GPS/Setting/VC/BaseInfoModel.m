//
//  BaseInfoModel.m
//  欧深特GPS
//
//  Created by joe on 16/9/19.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "BaseInfoModel.h"


@implementation BaseInfoModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        self.nickName = [dic objectForKey:@"nickName"];
        self.carNumber = [dic objectForKey:@"carNumber"];
        self.carFrameNumber = [dic objectForKey:@"carFrameNumber"];
        self.engineNumber = [dic objectForKey:@"engineNumber"];
        self.insuranceDate = [dic objectForKey:@"insuranceDate"];
        self.annualDate = [dic objectForKey:@"annualDate"];
    }
    
    return self;
    
}


+(instancetype)BaseInfoModelWithDic:(NSDictionary *)dic{
    return [[self alloc] initWithDic:dic];
}



@end
