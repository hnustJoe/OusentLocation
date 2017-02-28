//
//  ProtectModel.h
//  欧深特GPS
//
//  Created by joe on 16/11/9.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ProtectModel : NSObject

@property (nonatomic,copy) NSString *enclosureId;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@property (nonatomic,assign) NSInteger type;//0画圆 1 画方形
@property (nonatomic,assign) NSInteger radius;
@property (nonatomic,assign) CLLocationCoordinate2D centerCoo;

@property (nonatomic,strong) NSString *points;

@end
