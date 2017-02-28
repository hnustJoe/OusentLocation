//
//  CommonFunction.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CommonFunction.h"
#import "ProgressView.h"





@implementation CommonFunction



//网络
+ (void)GetDataFromUrl:(NSString *)urlStr

        SetCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject))completionBlock

        failureBlock:(void (^) (AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error))failure
{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSString *str = operation.responseString;
        NSLog(@"%@",str);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}


//颜色
+ (UIColor *)mainColor{
    return  [UIColor colorWithRed:193.0/255 green:75.0/255 blue:58.0/255 alpha:1];
}

+ (UIColor *)maskGrayColor{
    return [UIColor colorWithRed:187.0/255 green:186.0/255 blue:181.0/255 alpha:1];
}


//登录相关配置
+ (void)saveloginIP:(NSString *)loginIP{
    [[NSUserDefaults standardUserDefaults]setObject:loginIP forKey:@"loginIP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getloginIP{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"loginIP"];
}


+ (void)saveCurrentUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults]setObject:userName forKey:@"currentUserName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCurrentUsername{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"currentUserName"];
}


+ (void)saveCurrentPassword:(NSString *)password{
    [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCurrentPassword{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
}


+ (void)saveCurrentVehicleId:(NSString *)currentVehicleId{
    [[NSUserDefaults standardUserDefaults]setObject:currentVehicleId forKey:@"currentVehicleId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCurrentVehicleId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"currentVehicleId"];
}


+ (void)saveCurrentplateNo:(NSString *)CurrentplateNo{
    [[NSUserDefaults standardUserDefaults]setObject:CurrentplateNo forKey:@"CurrentplateNo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getCurrentplateNo{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"CurrentplateNo"];
}

+ (void)saveNotiArr:(NSArray *)NotiArr{
    [[NSUserDefaults standardUserDefaults]setObject:NotiArr forKey:@"NotiArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)getNotiArr{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"NotiArr"];
}


+ (void)saveSpeedlimitsettingTime:(NSString *)SpeedlimitsettingTime{
    NSString *vehicleId = [CommonFunction getCurrentVehicleId];
    [[NSUserDefaults standardUserDefaults]setObject:SpeedlimitsettingTime forKey:[NSString stringWithFormat:@"SpeedlimitsettingTime_%@",vehicleId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getSpeedlimitsettingTime{
    NSString *vehicleId = [CommonFunction getCurrentVehicleId];
    return [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"SpeedlimitsettingTime_%@",vehicleId]];
}

+ (void)saveDataReportingTime:(NSString *)DataReportingTime{
    NSString *vehicleId = [CommonFunction getCurrentVehicleId];
    [[NSUserDefaults standardUserDefaults]setObject:DataReportingTime forKey:[NSString stringWithFormat:@"DataReportingTime_%@",vehicleId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getDataReportingTime{
    NSString *vehicleId = [CommonFunction getCurrentVehicleId];
    return [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"DataReportingTime_%@",vehicleId]];
}





+ (BOOL)canAutoLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"canAutoLogin"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"canAutoLogin"] boolValue] == YES ) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)setCanAutoLogin:(BOOL)canAutoLogin{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:canAutoLogin] forKey:@"canAutoLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


+ (void)setIsAutoLogin:(BOOL)isAutoLogin{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isAutoLogin] forKey:@"isAutoLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



+ (BOOL)isAutoLogin{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isAutoLogin"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"isAutoLogin"] boolValue] == YES ) {
        return YES;
    }else{
        return NO;
    }
}


//+ (void)removeUsernameAndPassword{
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"currentUserName"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}



#pragma mark 提示框

//显示错误信息
+ (void)showWrongMessagewithtext:(NSString *)text completionBlock:(void (^)())completionBlock{
    [[ProgressView shareInstance]removeFromSuperview];
    
    UIView *bcView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:bcView];
    
    
    
    CGSize textSize = [text sizeWithFont:[CommonFunction MediumFont]];
    
    
    UIView *contentBgView = [[UIView alloc]initWithFrame:CGRectMake((WindowWidth - 36 - textSize.width - spaceWidth * 3)/2, WindowHeight - 150, 36 + spaceWidth*3 + textSize.width, 40)];
    contentBgView.backgroundColor =[UIColor colorWithRed:204/255.0 green:227/255.0 blue:255/255.0 alpha:1];
    contentBgView.layer.cornerRadius = 4;
    contentBgView.layer.masksToBounds = YES;
    [bcView addSubview:contentBgView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(spaceWidth, 2, 36, 36)];
    imageView.image = [UIImage imageNamed:@"toast_result_false"];
    [contentBgView addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(spaceWidth * 2 + 36, 0, textSize.width,40)];
    lable.font = [CommonFunction MediumFont];
    lable.text =text;
    lable.textColor =[CommonFunction blackTextFont1];
    [contentBgView addSubview:lable];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionBlock();
        [bcView removeFromSuperview];
    });
    
}



//显示菊花不可以点击信息
+ (void)showProgressMessageToView:(UIView *)view text:(NSString *)text {
    [self showProgressMessageToView:view text:text userInteractionEnabled:YES];
}

//显示句话信息（带时间的）
+ (void)showProgressMessage:(NSString *)text time:(NSInteger)time{
    [[ProgressView shareInstance]showWithContent:text time:time];
    
}

//显示菊花可以点击信息
+ (void)showProgressMessageToView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)userInteractionEnabled{
    
    [[ProgressView shareInstance]showWithContent:text];
}
//显示正确信息
+ (void)showRightMessageToView:(UIView *)view text:(NSString *)text completionBlock:(void (^)())completionBlock{
    [[ProgressView shareInstance]removeFromSuperview];
    
    UIView *bcView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:bcView];
    
    
    
    CGSize textSize = [text sizeWithFont:[CommonFunction MediumFont]];
    
    
    UIView *contentBgView = [[UIView alloc]initWithFrame:CGRectMake((WindowWidth - 36 - textSize.width - spaceWidth * 3)/2, WindowHeight - 150, 36 + spaceWidth*3 + textSize.width, 40)];
    contentBgView.backgroundColor =[UIColor colorWithRed:204/255.0 green:227/255.0 blue:255/255.0 alpha:1];
    contentBgView.layer.cornerRadius = 4;
    contentBgView.layer.masksToBounds = YES;
    [bcView addSubview:contentBgView];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(spaceWidth, 2, 36, 36)];
    imageView.image = [UIImage imageNamed:@"toast_result_success"];
    [contentBgView addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(spaceWidth * 2 + 36, 0, textSize.width,40)];
    lable.font = [CommonFunction MediumFont];
    lable.text =text;
    lable.textColor =[CommonFunction blackTextFont1];
    [contentBgView addSubview:lable];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completionBlock();
        [bcView removeFromSuperview];
    });
}

+ (void)removeProgress{
    [[ProgressView shareInstance] removeFromKeyWindow];
}

#pragma mark 字体大小
+ (UIFont *)BigFont{
    return [UIFont systemFontOfSize:18.0];
}

+ (UIFont *)MediumFont{
    return [UIFont systemFontOfSize:16.0];
}

+ (UIFont *)SmallFont{
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)SmallSmallFont{
    return [UIFont systemFontOfSize:12.0];
}

+ (UIFont *)SmallSmallSmallFont{
    return [UIFont systemFontOfSize:10.0];
}


#pragma mark 文字颜色
+ (UIColor *)blackTextFont1{
    return  [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1];
}

+ (UIColor *)grayTextFont1{
    return  [UIColor colorWithRed:111.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1];
}

+ (UIColor *)grayTextFont2{
    return  [UIColor colorWithRed:155.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1];
}

+ (UIColor *)LineGrayColor{
    return [UIColor colorWithRed:238.0/255 green:238.0/255 blue:238.0/255 alpha:1];
}


@end
