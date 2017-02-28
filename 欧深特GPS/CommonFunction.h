//
//  CommonFunction.h
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface CommonFunction : NSObject

//根据url获取数据
+ (void)GetDataFromUrl:( NSString * _Nonnull )urlStr

SetCompletionBlockWithSuccess:(void  (^ _Nonnull )(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) )completionBlock

          failureBlock:(void (^ _Nonnull) (AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error))failure;


//颜色
+ (UIColor *_Nonnull)mainColor;
+ (UIColor *_Nonnull)maskGrayColor;



//登录相关配置
+ (void)saveloginIP:(NSString *_Nonnull)loginIP;
+ (NSString *_Nonnull)getloginIP;
+ (void)saveCurrentUserName:(NSString *_Nonnull)userName;
+ (void)saveCurrentPassword:(NSString *_Nonnull)password;
+ (NSString * __nullable)getCurrentUsername;
+ (NSString * __nullable)getCurrentPassword;
+ (void)saveCurrentVehicleId:(NSString *__nullable)currentVehicleId;
+ (NSString *__nullable)getCurrentVehicleId;//+ (void)removeUsernameAndPassword;
+ (void)saveCurrentplateNo:(NSString *__nullable)CurrentplateNo;
+ (NSString *__nullable)getCurrentplateNo;
+ (void)saveNotiArr:(NSArray *__nullable)NotiArr;
+ (NSArray *__nullable)getNotiArr;
+ (void)saveSpeedlimitsettingTime:(NSString *__nullable)SpeedlimitsettingTime;
+ (NSString *__nullable)getSpeedlimitsettingTime;
+ (void)saveDataReportingTime:(NSString *__nullable)DataReportingTime;
+ (NSString *__nullable)getDataReportingTime;

+ (void)saveCurrentdriver:(NSString *)driver;
+ (NSString *)getCurrentdriver;

+ (void)saveCurrenttermNo:(NSString *)termNo;
+ (NSString *)getCurrenttermNo;

+ (BOOL)canAutoLogin;
+ (void)setCanAutoLogin:(BOOL)canAutoLogin;
+ (void)setIsAutoLogin:(BOOL)isAutoLogin;
+ (BOOL)isAutoLogin;


+ (void)saveCarListSelectIndex:(NSInteger)selectIndex;
+ (NSInteger)getCarListSelectIndex;

+ (void)saveCurrentVehicleLat:(NSString *)lat;
+ (NSString *)getCurrentVehicleLat;
+ (void)saveCurrentVehicleLng:(NSString *)lng;
+ (NSString *)getCurrentVehicleLng;

#pragma mark 提示框
//显示错误信息
+ (void)showWrongMessagewithtext:(NSString *_Nonnull)text completionBlock:(void (^_Nonnull)())completionBlock;
//显示菊花不可以点击信息
+ (void)showProgressMessageToView:(UIView *_Nonnull)view text:(NSString *_Nonnull)text;
//显示句话信息（带时间的）
+ (void)showProgressMessage:(NSString *_Nonnull)text time:(NSInteger)time;
//显示菊花可以点击信息
+ (void)showProgressMessageToView:(UIView *_Nonnull)view text:(NSString *_Nonnull)text userInteractionEnabled:(BOOL)userInteractionEnabled;//显示正确信息
+ (void)showRightMessageToView:(UIView *_Nonnull)view text:(NSString *_Nonnull)text completionBlock:(void (^_Nonnull)())completionBlock;
+ (void)removeProgress;

//+ (void)saveCarListArr:(NSMutableArray *)arr;
//+ (NSMutableArray *)getCarListArr;

#pragma mark 字体大小
+ (UIFont *_Nonnull)BigFont;
+ (UIFont *_Nonnull)MediumFont;
+ (UIFont *_Nonnull)SmallFont;
+ (UIFont *_Nonnull)SmallSmallFont;
+ (UIFont *_Nonnull)SmallSmallSmallFont;

#pragma mark 文字颜色
+ (UIColor *_Nonnull)blackTextFont1;
+ (UIColor *_Nonnull)grayTextFont1;
+ (UIColor *_Nonnull)grayTextFont2;
+ (UIColor *_Nonnull)LineGrayColor;
@end
