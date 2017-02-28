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
#import "HDViewController.h"

@interface AppDelegate ()<HDViewControllerDelegate>

@property (nonatomic,assign) NSInteger enterAppTime;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //离线通知
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
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
    [UINavigationBar appearance].translucent = NO;

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    
    
    UIWindow *window =  [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ManualLoginOK:) name:@"ManualLoginOK" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ManulLogoutOK:) name:@"ManulLogoutOK" object:nil];
    
    
//    [self setAlertNoti];

    
    NSString *enterMainLoop =  [[NSUserDefaults standardUserDefaults]objectForKey:@"enterMainLoop"];
    if([enterMainLoop boolValue]){
        [self enterMainLoop];
    }else{
        [self enterStartVc];
        
    }
    


    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSInteger current = [[NSDate date] timeIntervalSince1970];
    if (current - self.enterAppTime < 60) {
        return;
    }
    
 

    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if (![vc isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoteAlertNoti" object:nil userInfo:userInfo];
    
    NSString *str = [userInfo objectForKey:@"key3"];
    NSArray *arr = [str componentsSeparatedByString:@","];
    
    NSString *str3 = arr[0];

    
    if (arr && arr.count > 0) {
        if ([str3 isEqualToString:@"CrossBorder"]) {
            str3 = @"电子围栏报警";
        }else if([str3 isEqualToString:@"7"]){
            str3 = @"低压报警";
        }else if([str3 isEqualToString:@"30"]){
            str3 = @"摔倒报警";
        }

    }
    
    
    NSString *notiMessage = [NSString stringWithFormat:@"%@在%@产生警报：%@",[userInfo objectForKey:@"key1"],[userInfo objectForKey:@"key2"],str3];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:notiMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:nil];
    [alertView show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    NSString *deviceToken = [[[[devToken description]
                              stringByReplacingOccurrencesOfString:@"<"withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
    stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults]setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //    OnetalkingSocket *socket =  [OnetalkingSocket shareInstance];
    //    socket.socketHost =  [CommonFunction getOriginalIp];
    //    socket.socketPort =  [CommonFunction getOriginalPort];
    //    socket.isLoginAllocateServer = YES;
    //    [socket socketConnectHost];
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidEnterBackground" object:nil];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    self.enterAppTime = [[NSDate date]timeIntervalSince1970];
    
    
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
    [CommonFunction setCanAutoLogin:1];
    [CommonFunction setIsAutoLogin:NO];
    [self enterHomeVC];
}


- (void)ManulLogoutOK:(NSNotification *)noti{
    [CommonFunction setCanAutoLogin:0];
    [self enterLoginVC];
}

#pragma mark private
- (void)enterMainLoop{
    if ([CommonFunction canAutoLogin]) {
        [CommonFunction setIsAutoLogin:YES];
        [self enterHomeVC];
    }else{
        [CommonFunction setIsAutoLogin:NO];
        [self enterLoginVC];
    }
 
}


- (void)enterHomeVC{
    HomeViewController *vc = [[HomeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
}

- (void)enterLoginVC{
    LoginViewController *vc = [[LoginViewController alloc]init];
    self.window.rootViewController = vc;
}

- (void)enterStartVc{
    HDViewController *vc = [[HDViewController alloc]init];
    vc.delegate = self;
    self.window.rootViewController = vc;
    
}

#pragma  mark startVCDelegate
- (void)lastPageClicked:(HDViewController *)vc{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"enterMainLoop"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self enterMainLoop];
    
        

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
