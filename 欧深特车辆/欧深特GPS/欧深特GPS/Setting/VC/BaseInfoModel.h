//
//  BaseInfoModel.h
//  欧深特GPS
//
//  Created by joe on 16/9/19.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfoModel : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)BaseInfoModelWithDic:(NSDictionary *)dic;

@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *carNumber;
@property (nonatomic,copy) NSString *carFrameNumber;
@property (nonatomic,copy) NSString *engineNumber;
@property (nonatomic,copy) NSString *insuranceDate;
@property (nonatomic,copy) NSString *annualDate;//年审过期


@end
