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
#import "CarDetailViewController.h"
#import "HistoryTrackViewController.h"
#import "ProtectSetViewController.h"

#import "OneKeyTestingViewController.h"
#import "AlertCenterViewController.h"
#import "CarCareViewController.h"
#import "InstructionViewController.h"
#import "HomeBottomView.h"
#import "AddDeviceViewController.h"

#import <objc/runtime.h>

#import "CustomAnnotationView.h"
#import "KGStatusBar.h"


@interface HomeViewController ()<HomeBottomViewDelegate,MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapview;
@property (nonatomic,strong) HomeBottomView *bottomView;
@property (nonatomic,strong) NSTimer *autoGetLocationTimer;
@property (nonatomic,strong) UIView *toolView;


@property (nonatomic,assign) BOOL isManycarsModel;
@property (nonatomic,strong) NSMutableArray *manyCarArr;


@property (nonatomic,assign) NSInteger zommlever;

@end

@implementation HomeViewController

- (void)setIsManycarsModel:(BOOL)isManycarsModel{
    _isManycarsModel = isManycarsModel;
    
    
    if (isManycarsModel) {
        self.toolView.hidden = YES;
    }else{
        self.toolView.hidden = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    
    
    self.zommlever = 14;
    self.title = NSLocalizedString(@"HomeViewController_CurrentLocation", "当前位置");
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapview = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapview];
    self.mapview.delegate = self;

    
    [self setupView];
    
  
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:@"applicationDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(swithCurrentCarNoti:) name:@"swithCurrentCarNoti" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unbinddevice) name:@"unbinddevice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changenameOK) name:@"changenameOK" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getVehicleInfo) name:@"addfirstDeviceOK" object:nil];


    
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCar:) name:@"selectCar" object:nil];
    

    //自动登录或者获取车辆信息
    if ([CommonFunction isAutoLogin]) {
        //自动登录
        [self autoLogin];
    }else{
        
        //获取车辆信息
        if ([CommonFunction getCurrentVehicleId]) {
            //根据id获取车辆的位置信息
            [self getVehicleInfoWithVehicleID:[CommonFunction getCurrentVehicleId]];
        }else{
            //先获取所有的选第一个车辆
            [self getVehicleInfo];
        }
    }
    
    
    //添加自动获取位置的timer
    self.autoGetLocationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoGetLocation) userInfo:nil repeats:YES];
    [self.autoGetLocationTimer fire];
}


#pragma mark private
- (void)setupView{
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"home_setting_normal"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [btn addTarget:self action:@selector(leftBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:btn];
    
//    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_setting_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn_clicked)];
//    self.navigationItem.leftBarButtonItem

    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn1 setImage:[UIImage imageNamed:@"home_list_normal"] forState:UIControlStateNormal];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [btn1 addTarget:self action:@selector(rightBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];

//    [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_list_normal"]  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn_clicked)];

    

    
    
    UIView *toolView = [[UIView alloc]initWithFrame:CGRectMake(0, WindowHeight - 50 - 64, WindowWidth, 50)];
    [self.view addSubview:toolView];
    toolView.backgroundColor = [CommonFunction mainColor];
    self.toolView = toolView;
    
    
    UIButton *locationBtn =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, WindowWidth/5.0, 50)];
    [locationBtn setImage:[UIImage imageNamed:@"home_location_normal"] forState:UIControlStateNormal];
    [toolView addSubview:locationBtn];
    [locationBtn addTarget:self action:@selector(locationBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *trackBtn =[[UIButton alloc]initWithFrame:CGRectMake(WindowWidth/5.0, 0, WindowWidth/5.0, 50)];
    [trackBtn setImage:[UIImage imageNamed:@"home_route_normal"] forState:UIControlStateNormal];
    [toolView addSubview:trackBtn];
    [trackBtn addTarget:self action:@selector(trackBtn_clicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *protectBtn =[[UIButton alloc]initWithFrame:CGRectMake(2*WindowWidth/5.0, 0, WindowWidth/5.0, 50)];
    [protectBtn setImage:[UIImage imageNamed:@"home_control_normal"] forState:UIControlStateNormal];
    [toolView addSubview:protectBtn];
    [protectBtn addTarget:self action:@selector(protectBtn_clicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *notiBtn =[[UIButton alloc]initWithFrame:CGRectMake(3*WindowWidth/5.0, 0, WindowWidth/5.0, 50)];
    [notiBtn setImage:[UIImage imageNamed:@"home_alarm_normal"] forState:UIControlStateNormal];
    [toolView addSubview:notiBtn];
    [notiBtn addTarget:self action:@selector(notiBtn_clicked) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *setBtn =[[UIButton alloc]initWithFrame:CGRectMake(4*WindowWidth/5.0, 0, WindowWidth/5.0, 50)];
    [setBtn setImage:[UIImage imageNamed:@"home_order_normal"] forState:UIControlStateNormal];
    [toolView addSubview:setBtn];
    [setBtn addTarget:self action:@selector(setBtn_clicked) forControlEvents:UIControlEventTouchUpInside];


    
    UIImageView *scaleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WindowWidth - 60, WindowHeight - 170 -64, 40, 80)];
    scaleImageView.image = [UIImage imageNamed:@"map_btn_normal@3x_03"];
    [self.view addSubview:scaleImageView];
    
    
    UIButton *enlargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(scaleImageView.frame.origin.x, scaleImageView.frame.origin.y, 40, 40)];
    enlargeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:enlargeBtn];
    [enlargeBtn addTarget:self action:@selector(enlargeBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(scaleImageView.frame.origin.x, scaleImageView.frame.origin.y + 40, 40, 40)];
    reduceBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:reduceBtn];
    [reduceBtn addTarget:self action:@selector(reduceBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)autoLogin{
    
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/Login?username=%@&password=%@",[CommonFunction getloginIP],[CommonFunction getCurrentUsername],[CommonFunction getCurrentPassword]];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
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
            
            
            
            if ([CommonFunction getCurrentVehicleId] && [[CommonFunction getCurrentVehicleId] integerValue] != 0) {
                //根据id获取车辆的位置信息
                [self getVehicleInfoWithVehicleID:[CommonFunction getCurrentVehicleId]];
            }else{
                //先获取所有的选第一个车辆
                [self getVehicleInfo];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}




//获取车辆的位置信息
//- (void)getVehicleInfoAndShow{
//    if ([CommonFunction getCurrentVehicleId]) {
//        
//        
//        //根据id获取车辆的位置信息
//        [self getVehicleInfoWithVehicleID:[CommonFunction getCurrentVehicleId]];
//        
//        
//        
//    }else{
//        
//        
//        //先获取所有的选第一个车辆
//        [self getVehicleInfo];
//        
//        
//    }
//}

//根据id获取车辆的位置信息
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
        }else{
            
            NSLog(@"获取车辆信息成功");
            
            NSDictionary *data = [dic objectForKey:@"data"];
            [CommonFunction saveCurrentVehicleId:[NSString stringWithFormat:@"%@",[data objectForKey:@"vehicleId"]]];
            [CommonFunction saveCurrentplateNo:[data objectForKey:@"plateNo"]];
            [CommonFunction saveCurrentdriver:[data objectForKey:@"driver"]];
            [CommonFunction saveCurrenttermNo:[data objectForKey:@"plateNo"]];
            [CommonFunction saveCurrentVehicleLat:[data objectForKey:@"lat"]];
            [CommonFunction saveCurrentVehicleLng:[data objectForKey:@"lng"]];

            
            NSString *title =[data objectForKey:@"location"];
            NSString *lat =[data objectForKey:@"lat"];
            NSString *lng =[data objectForKey:@"lng"];
            
            if (![[data objectForKey:@"plateNo"] isKindOfClass:[NSNull class]]) {
                self.title = [data objectForKey:@"plateNo"];
            }
            
            [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue] dic:data];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

//先获取所有的选第一个车辆
- (void)getVehicleInfo{
    
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
               
            }];
            
        }else{
            NSLog(@"获取车辆信息成功");
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSArray *carArr = [data objectForKey:@"results"];
            
            if (carArr.count > 0) {
                NSDictionary *result = [data objectForKey:@"results"][0];
                [CommonFunction saveCurrentVehicleId:[NSString stringWithFormat:@"%@",[result objectForKey:@"vehicleId"]]];
                [CommonFunction saveCurrentplateNo:[result objectForKey:@"plateNo"]];
                [CommonFunction saveCurrentdriver:[result objectForKey:@"driver"]];
                [CommonFunction saveCurrenttermNo:[result objectForKey:@"plateNo"]];
                [CommonFunction saveCurrentVehicleLat:[result objectForKey:@"lat"]];
                [CommonFunction saveCurrentVehicleLng:[result objectForKey:@"lng"]];

                
                NSString *title =[result objectForKey:@"location"];
                NSString *lat =[result objectForKey:@"lat"];
                NSString *lng =[result objectForKey:@"lng"];
                
                if (![[result objectForKey:@"plateNo"] isKindOfClass:[NSNull class]]) {
                    self.title = [data objectForKey:@"plateNo"];
                }
                
                [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue] dic:result];
            }else{
                AddDeviceViewController *vc = [[AddDeviceViewController alloc]init];
                vc.isfistADD = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

//设置标注
- (void)setCenterAnnonationWithTItle:(NSString *)title lat:(double)lat lng:(double)lng dic:(NSDictionary *)showDic{
    
    [self.mapview removeAnnotations:self.mapview.annotations];
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    pointAnnotation.title = title;
    
    
    objc_setAssociatedObject(pointAnnotation, @"showDic", showDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self.mapview addAnnotation:pointAnnotation];
    [self.mapview setCenterCoordinate:CLLocationCoordinate2DMake(lat,lng) zoomLevel:self.zommlever animated:YES];
}


#pragma mark noti
- (void)changenameOK{
    self.title = [CommonFunction getCurrentplateNo];
}


- (void)selectCar:(NSNotification *)noti{
    NSMutableArray *selectArr = [noti.userInfo objectForKey:@"selectedCar"];
    
    [self.mapview removeAnnotations:self.mapview.annotations];
    
    
    for (NSMutableDictionary *dic in selectArr) {
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] doubleValue], [[dic objectForKey:@"lng"] doubleValue]);
        pointAnnotation.title = [dic objectForKey:@"location"];
//        objc_setAssociatedObject(pointAnnotation,@"vehicleId", dic,
//                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(pointAnnotation, @"showDic", dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.mapview addAnnotation:pointAnnotation];

    }

    
    [self.mapview showAnnotations:self.mapview.annotations animated:YES];
    
    
    if (selectArr.count != 1) {
        self.isManycarsModel = YES;
        self.manyCarArr = selectArr;
    }else{
        self.isManycarsModel = NO;
        
        NSMutableDictionary *dic = selectArr[0];
        
        [CommonFunction saveCurrentVehicleId:[dic objectForKey:@"vehicleId"]];
        [CommonFunction saveCurrentplateNo:[dic objectForKey:@"plateNo"]];
        [CommonFunction saveCurrentdriver:[dic objectForKey:@"driver"]];
        [CommonFunction saveCurrenttermNo:[dic objectForKey:@"plateNo"]];
        [CommonFunction saveCurrentVehicleLat:[dic objectForKey:@"lat"]];
        [CommonFunction saveCurrentVehicleLng:[dic objectForKey:@"lng"]];

        self.isManycarsModel = NO;
        
        if (![[dic objectForKey:@"plateNo"] isKindOfClass:[NSNull class]]) {
            self.title = [dic objectForKey:@"plateNo"];
        };

        
    }
    
    
    [self.autoGetLocationTimer invalidate];
    self.autoGetLocationTimer = nil;
    self.autoGetLocationTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(autoGetLocation) userInfo:nil repeats:YES];
    [self.autoGetLocationTimer fire];
   
}


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

//解绑设备
- (void)unbinddevice{
    [self getVehicleInfo];
}

#pragma mark sender
- (void)enlargeBtn_clicked{
    if (self.zommlever < 28) {
        self.zommlever = self.zommlever + 2;
    }
    [self.mapview setCenterCoordinate:self.mapview.centerCoordinate zoomLevel:self.zommlever animated:YES];

    
}

- (void)reduceBtn_clicked{
    
    if (self.zommlever > 2) {
        self.zommlever =  self.zommlever - 2;
    }
    [self.mapview setCenterCoordinate:self.mapview.centerCoordinate zoomLevel:self.zommlever animated:YES];
    
}


- (void)locationBtn_clicked{
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    [self updatelocatoinWithvehicleId:[CommonFunction getCurrentVehicleId]];
    
    
    
}




- (void)trackBtn_clicked{

    HistoryTrackViewController * vc = [[HistoryTrackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}
- (void)protectBtn_clicked{
        ProtectSetViewController * vc = [[ProtectSetViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

}

- (void)notiBtn_clicked{
        AlertCenterViewController * vc = [[AlertCenterViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
}

- (void)setBtn_clicked{
        InstructionViewController * vc = [[InstructionViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

}


- (void)leftBtn_clicked{
    SettingViewController *vc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtn_clicked{
    CarDetailViewController *vc = [[CarDetailViewController alloc]init];
    vc.isManycarsModel = self.isManycarsModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)autoGetLocation{
    
    if (self.isManycarsModel) {
        
        //更新所有车辆的位置信息
        for (NSMutableDictionary *dic in self.manyCarArr) {
            [self updatelocatoinWithvehicleId:[dic objectForKey:@"vehicleId"]];//更新所有车辆
        }
        
        //更新所有车辆的报警信息
//        [self updateAllAlert];

        
        
        
    }else{
        
        [self updatelocatoinWithvehicleId:[CommonFunction getCurrentVehicleId]];//更新当前车辆的位置信息
//        [self updateCurrentAlert];//更新当前车辆的报警信息
        
    }
    
}

- (void)updateCurrentAlert{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileAlarm.mvc/alarm?vehicleIds=%@&alarmTypes=CrossBorder,7,30",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            
            if ([dic objectForKey:@"data"]) {
                
                NSMutableString *content = [NSMutableString string];
                
                
                for (NSDictionary *contentDic in [dic objectForKey:@"data"]) {
                    
                    [content appendString:[NSString stringWithFormat:@"%@ %@ %@\n",[contentDic objectForKey:@"plateNo"],[contentDic objectForKey:@"alarmTime"],[contentDic objectForKey:@"alarmTypeDescr"]]];
                    
                    
                }
                
                if (content.length > 1) {
                    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:nil message:content delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                }
                
//                NSDictionary *dataDic = [dic objectForKey:@"data"];
//                [KGStatusBar showSuccessWithStatus:[dataDic objectForKey:@"alarmTypeDescr"]];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

- (void)updateAllAlert{
    
    
    NSMutableArray *paramsArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.manyCarArr) {
        [paramsArr addObject:[dic objectForKey:@"vehicleId"]];
    }
    
    NSString *params = [paramsArr componentsJoinedByString:@","];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileAlarm.mvc/alarm?vehicleIds=%@&alarmTypes=CrossBorder,7,30",[CommonFunction getloginIP],params]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        NSLog(@"%@",[dic objectForKey:@"message"]);
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            
            if ([dic objectForKey:@"data"]) {
                
                NSMutableString *content = [NSMutableString string];
                
                
                for (NSDictionary *contentDic in [dic objectForKey:@"data"]) {
                    
                    [content appendString:[NSString stringWithFormat:@"%@ %@ %@\n",[contentDic objectForKey:@"plateNo"],[contentDic objectForKey:@"alarmTime"],[contentDic objectForKey:@"alarmTypeDescr"]]];
                
                }
                
                if (content.length > 1) {
                    UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:nil message:content delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                }
                
               
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
    
}

- (void)updatelocatoinWithvehicleId:(NSString *)vehicleId{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileRealData.mvc/refreshRealData?vehicleId=%@",[CommonFunction getloginIP],vehicleId]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [CommonFunction removeProgress];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            
            NSLog(@"事实监听接口成功");
            NSDictionary *data = [dic objectForKey:@"data"];
            
            NSString *title =[data objectForKey:@"location"];
            NSString *lat =[data objectForKey:@"lat"];
            NSString *lng =[data objectForKey:@"lng"];
            
            
            if (self.isManycarsModel) {
                
                for (MKPointAnnotation *anonation in self.mapview.annotations) {
                    
                    NSDictionary *dic = objc_getAssociatedObject(anonation, @"showDic");
                    NSString *vehicleId = [dic objectForKey:@"vehicleId"];
                    
                    
                    if ([vehicleId integerValue] == [[data objectForKey:@"vehicleId"] integerValue]) {
                        [self.mapview removeAnnotation:anonation];
                        
                       
                        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
                        pointAnnotation.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                        pointAnnotation.title = title;
                        
                        objc_setAssociatedObject(pointAnnotation, @"showDic", data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//                        objc_setAssociatedObject(pointAnnotation,@"vehicleId", dic,
//                                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        [self.mapview addAnnotation:pointAnnotation];
                        
                        
                    }
                }
                
                
            }else{
                [self setCenterAnnonationWithTItle:title lat:[lat doubleValue] lng:[lng doubleValue] dic:data];
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [CommonFunction showWrongMessagewithtext:[NSString stringWithFormat:@"%@",error] completionBlock:^{
            
        }];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];

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
            ProtectSetViewController * vc = [[ProtectSetViewController alloc]init];
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    view.selected = YES;

    
    NSMutableDictionary *dic =  objc_getAssociatedObject(view.annotation, @"showDic");
    [CommonFunction saveCurrentplateNo:[dic objectForKey:@"plateNo"]];
    [CommonFunction saveCurrentdriver:[dic objectForKey:@"driver"]];
    [CommonFunction saveCurrenttermNo:[dic objectForKey:@"plateNo"]];
    [CommonFunction saveCurrentVehicleId:[NSString stringWithFormat:@"%@",[dic objectForKey:@"vehicleId"]]];
    [CommonFunction saveCurrentVehicleLat:[dic objectForKey:@"lat"]];
    [CommonFunction saveCurrentVehicleLng:[dic objectForKey:@"lng"]];
    
    self.isManycarsModel = NO;
    self.title = [dic objectForKey:@"plateNo"];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    
    view.selected = NO;
    
}

#pragma mark mkmapViewAnnonation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]]){
//        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
//        annotationView.canShowCallout = YES;
//        annotationView.draggable = YES;
//        annotationView.image = [UIImage imageNamed:@"homeAnn"];
//        return annotationView;
        
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView  *annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        
        NSDictionary *dic = objc_getAssociatedObject(annotation, @"showDic");
    
        
    
        
        annotationView.text1 = [NSString stringWithFormat:@"%@:%@%%    状态:%@    速度:%@km/h",NSLocalizedString(@"battery", nil),[dic objectForKey:@"dianChiDianLiang"],[dic objectForKey:@"locationStatus"],[dic objectForKey:@"speed"]];
        annotationView.text2 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"alert info", nil),[dic objectForKey:@"alarm"]];

        annotationView.text3 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"location time", nil),[dic objectForKey:@"sendTime"]];
        annotationView.text4 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"recive time", nil),[dic objectForKey:@"updateDate"]];
        annotationView.text5 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"location"]];

        
//        annotationView.calloutOffset = CGPointMake(0, -3);
//        NSData *infoData = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"locationInfo%@",[CommonFunction getUserID]]];
//        LocationInfo *info = [LocationInfo parseFromData:infoData];
//        annotationView.subTilte = [[NSUserDefaults standardUserDefaults]objectForKey:@"subtitle"];
//        annotationView.info = info;
        if ([dic objectForKey:@"alarm"]) {
            annotationView.image = [UIImage imageNamed:@"homeAnn"];
        }else{
            annotationView.image = [UIImage imageNamed:@"homeAnn"];

        }
        

        return annotationView;
    }
    
    return nil;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
