//
//  AppDelegate.m
//  欧深特GPS
//
//  Created by joe on 16/9/12.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘设置
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;
    keyboardManager.enableAutoToolbar = YES;
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor] ];
    [UINavigationBar appearance].barTintColor = [CommonFunction mainColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    
    
    UIWindow *window =  [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ManualLoginOK:) name:@"ManualLoginOK" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ManulLogoutOK:) name:@"ManulLogoutOK" object:nil];
    
    
    [self setAlertNoti];

    if ([CommonFunction canAutoLogin]) {
        [CommonFunction setIsAutoLogin:YES];
        [self enterHomeVC];
    }else{
        [CommonFunction setIsAutoLogin:NO];
        [self enterLoginVC];
    }

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidEnterBackground" object:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if ([CommonFunction canAutoLogin]) {
        [CommonFunction setIsAutoLogin:YES];
    }else{
        [CommonFunction setIsAutoLogin:NO];
    }

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidBecomeActive" object:nil];
    
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark sender 
- (void)ManualLoginOK:(NSNotification *)noti{
    [CommonFunction setCanAutoLogin:YES];
    [CommonFunction setIsAutoLogin:NO];
    [self enterHomeVC];
}


- (void)ManulLogoutOK:(NSNotification *)noti{
    [CommonFunction setCanAutoLogin:NO];
    [self enterLoginVC];
}

#pragma mark private
- (void)enterHomeVC{
    HomeViewController *vc = [[HomeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)enterLoginVC{
    LoginViewController *vc = [[LoginViewController alloc]init];
    self.window.rootViewController = vc;
}


//报警通知设置
- (void)setAlertNoti{
    if (![CommonFunction getNotiArr]) {
        NSMutableArray *notiArr = [NSMutableArray array];
        [notiArr addObject:@{@"Parking":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"GpsOffline":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"OffsetRoute":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"CrossBorder":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"Gather":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"0":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"1":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"2":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"3":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"4":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"5":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"6":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"7":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"8":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"9":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"10":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"11":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"12":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"18":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"19":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"20":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"21":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"22":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"23":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"24":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"25":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"26":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"27":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"28":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"29":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"InArea":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"Parking":[NSNumber numberWithBool:NO]}];
        [notiArr addObject:@{@"Acc":[NSNumber numberWithBool:NO]}];
        [CommonFunction saveNotiArr:notiArr];
    }
    
}

@end
