//
//  HomeViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/12.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "MKMapView+MapViewUtil.h"


#import <MapKit/MapKit.h>
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "CarlistViewController.h"
#import "HistoryTrackViewController.h"
#import "ProtectSettingViewController.h"
#import "OneKeyTestingViewController.h"
#import "AlertCenterViewController.h"
#import "CarCareViewController.h"
#import "InstructionViewController.h"
#import "HomeBottomView.h"







@interface HomeViewController ()<HomeBottomViewDelegate>

@property (nonatomic,strong) MKMapView *mapview;
@property (nonatomic,strong) HomeBottomView *bottomView;
@property (nonatomic,strong) NSTimer *autoGetLocationTimer;

@end

@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HomeViewController_CurrentLocation", "当前位置");
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapview = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapview];
    [self setupView];
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:@"applicationDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(swithCurrentCarNoti:) name:@"swithCurrentCarNoti" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:@"applicationDidEnterBackground" object:nil];

    

    //自动登录或者获取车辆信息
    if ([CommonFunction isAutoLogin]) {
        //自动登录
        [self autoLogin];
    }else{
        //获取车辆信息
        [self getVehicleInfoAndShow];
    }
    
    
    //添加自动获取位置的timer
    self.autoGetLocationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoGetLocation) userInfo:nil repeats:YES];
    [self.autoGetLocationTimer fire];
}

#pragma mark private
- (void)setupView{
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_setting_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn_clicked)];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_list_normal"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn_clicked)];

    
    
    NSMutableArray *cellArr = [NSMutableArray array];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_route"] forKey:@"历史轨迹"]];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_ctr"] forKey:@"设防控制"]];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_test"] forKey:@"一键检测"]];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_alarm"] forKey:@"报警中心"]];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_condition"] forKey:@"车况养护"]];
    [cellArr addObject:[NSMutableDictionary dictionaryWithObject:[UIImage imageNamed:@"home_order"] forKey:@"指令设置"]];
    self.bottomView = [[HomeBottomView alloc]initWithFrame:CGRectMake(0, WindowHeight - bottomHeight, WindowWidth, bottomHeight) DataArr:cellArr];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bottomView];
    self.bottomView.delegate = self;

    
}


- (void)autoLogin{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileHome.mvc/Login?username=%@&password=%@",[CommonFunction getloginIP],[CommonFunction getCurrentUsername],[CommonFunction getCurrentPassword]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
                AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                [appDelegate enterLoginVC];
                
            }];
            
        }else{
            
            
            NSLog(@"自动登录成功");
            [self getVehicleInfoAndShow];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}


//获取车辆的位置信息
- (void)getVehicleInfoAndShow{
    if ([CommonFunction getCurrentVehicleId]) {
        
        [self getVehicleInfoWithVehicleID:[CommonFunction getCurrentVehicleId]];
        
        
        
    }else{
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/List?pageNo=0&pageSize=1",[CommonFunction getloginIP]]];
        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] boolValue] == NO) {
                if ([[dic objectForKey:@"message"] hasPrefix:@"网页已经过期"]) {
                    [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                        AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                        [appDelegate enterLoginVC];
                    }];
                    return ;
                }
                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                    [appDelegate enterLoginVC];
                }];
                
            }else{
                NSLog(@"获取车辆信息成功");
                NSDictionary *data = [dic objectForKey:@"data"];
                NSDictionary *result = [data objectForKey:@"results"][0];
                [CommonFunction saveCurrentVehicleId:[result objectForKey:@"vehicleId"]];
                [CommonFunction saveCurrentplateNo:[data objectForKey:@"plateNo"]];

                
                NSString *title =[result objectForKey:@"location"];
                NSString *lat =[result objectForKey:@"lat"];
                NSString *lng =[result objectForKey:@"lng"];
                
                self.title = [result objectForKey:@"plateNo"];
                [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue]];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperation:operation];
        
    }
}

- (void)getVehicleInfoWithVehicleID:(NSString *)vehicleID{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/GetVehicleById?vehicleId=%@",[CommonFunction getloginIP],vehicleID]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            if ([[dic objectForKey:@"message"] hasPrefix:@"网页已经过期"]) {
                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                    [appDelegate enterLoginVC];
                }];
                return ;
            }
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                [appDelegate enterLoginVC];
            }];
            
        }else{
            
            NSLog(@"获取车辆信息成功");
            
            NSDictionary *data = [dic objectForKey:@"data"];
            [CommonFunction saveCurrentVehicleId:[data objectForKey:@"vehicleId"]];
            [CommonFunction saveCurrentplateNo:[data objectForKey:@"plateNo"]];
            
            
            
            NSString *title =[data objectForKey:@"location"];
            NSString *lat =[data objectForKey:@"lat"];
            NSString *lng =[data objectForKey:@"lng"];
            
            self.title = [data objectForKey:@"plateNo"];
            [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue]];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

//设置标注
- (void)setCenterAnnonationWithTItle:(NSString *)title lat:(double)lat lng:(double)lng{
    
    [self.mapview removeAnnotations:self.mapview.annotations];
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    pointAnnotation.title = title;
    [self.mapview addAnnotation:pointAnnotation];
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(lat,lng) zoomLevel:14 animated:YES];
}


#pragma mark noti
//引用程序进入后台
- (void)applicationDidEnterBackground:(NSNotification *)noti{
    NSLog(@"stop");
    [self.autoGetLocationTimer invalidate];
    self.autoGetLocationTimer = nil;
}


//应用程序变得活跃
- (void)applicationDidBecomeActive:(NSNotification *)noti{
    self.autoGetLocationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoGetLocation) userInfo:nil repeats:YES];
    [self.autoGetLocationTimer fire];
    if ([CommonFunction isAutoLogin]) {
        [self autoLogin];
    }
}

//切换手表通知
- (void)swithCurrentCarNoti:(NSNotification *)noti{
    NSString *vehicleId = [noti.userInfo objectForKey:@"vehicleId"];
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", "正在加载") time:8];
    [self getVehicleInfoWithVehicleID:vehicleId];
}

#pragma mark sender
- (void)leftBtn_clicked{
    SettingViewController *vc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtn_clicked{
    CarlistViewController *vc = [[CarlistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)autoGetLocation{
    
    if ([CommonFunction getCurrentVehicleId]) {
        
        
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileRealData.mvc/refreshRealData?vehicleId=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId]]];
        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] boolValue] == YES) {
                
                NSLog(@"事实监听接口成功");
                NSDictionary *data = [dic objectForKey:@"data"];
                
                NSString *title =[data objectForKey:@"location"];
                NSString *lat =[data objectForKey:@"lat"];
                NSString *lng =[data objectForKey:@"lng"];
                
                self.title = [data objectForKey:@"plateNo"];
                [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue]];
            }
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperation:operation];
    }
}


#pragma mark HomeBottomViewDelegate
- (void)HomeBottomViewpullBtn_clicked:(UIButton *)sender{
    
    if (sender.selected) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = CGRectMake(0, WindowHeight - 44, WindowWidth, bottomHeight);
            self.bottomView.pullArrowImageView.image = [UIImage imageNamed:@"home_arrow_pressed"];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.frame = CGRectMake(0,WindowHeight - bottomHeight, WindowWidth, bottomHeight);
            self.bottomView.pullArrowImageView.image = [UIImage imageNamed:@"home_arrow_normal"];

        }];
    }
    sender.selected = !sender.selected;
    
}


- (void)HomeBottomViewcellBTn_clicked:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            HistoryTrackViewController * vc = [[HistoryTrackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            ProtectSettingViewController * vc = [[ProtectSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            OneKeyTestingViewController * vc = [[OneKeyTestingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            AlertCenterViewController * vc = [[AlertCenterViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            CarCareViewController * vc = [[CarCareViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            InstructionViewController * vc = [[InstructionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
