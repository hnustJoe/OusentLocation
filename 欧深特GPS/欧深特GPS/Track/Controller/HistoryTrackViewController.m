//
//  HistoryTrackViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "HistoryTrackViewController.h"
#import "MKMapView+MapViewUtil.h"
#import <MapKit/MapKit.h>
#import "HistoryTrackView.h"
#import "LRGlowingButton.h"
#import "CustomAnnotationView.h"
#import <objc/runtime.h>
#import "HistoryTrackAnnotationView.h"
#import "UIImage+Rotate.h"
#define spaceTime 0.5 //动画中间停顿时间

@interface HistoryTrackViewController ()<MKMapViewDelegate,HistoryTrackViewDelegate>


@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) UISlider *slide;
@property (nonatomic,strong) UILabel *rangeLable;


@property (nonatomic,strong) NSMutableArray *plistArr;

@property (nonatomic,assign) double animationTime;
@property (nonatomic,assign) BOOL pauseAnimation;
@property (nonatomic,assign) int animationIndex;


@property (nonatomic,assign) NSString *startTime;
@property (nonatomic,assign) NSString *endTime;


@property (nonatomic,strong) NSTimer *timer;
@end

@implementation HistoryTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"HistoryTrackViewController_HistoryTrack", "历史轨迹");
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"HistoryTrackView_check", "查询") style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    
    self.animationTime = 1;
    self.animationIndex = 1;
    self.pauseAnimation = YES;



    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    
    
    [self setupView];

    
    //添加选择时间框
//    HistoryTrackView *historyTrackView = [[HistoryTrackView alloc]initWithFrame:self.view.bounds];
//    historyTrackView.delegate = self;
//    [self.view addSubview:historyTrackView];


    //数据回来显示动画
//    NSMutableArray *plistArr = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"latlon" ofType:@"plist"]];
//    self.plistArr = plistArr;
//
//    [self addmapAnimation];
    
    
    
    
       
    
    
    [self right_action];
    
    
//    [self getTrackDataWithStartTime:startTime endTime:endtime];
    

    
    
    
    
}

#pragma mark private
- (void)getTrackDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", "正在加载") time:30];

    NSString *urlstr = [NSString stringWithFormat:@"http://%@/MobileGpsInfo.mvc/GetHistoryGpsInfo?plateNo=%@&startTime=%@&endTime=%@",[CommonFunction getloginIP],[CommonFunction getCurrentplateNo],startTime,endTime];
    NSString* encodedString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [CommonFunction removeProgress];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            NSLog(@"获取轨迹成功");
            NSDictionary *DataDic = [dic objectForKey:@"data"];
            NSArray *locationArr = [DataDic objectForKey:@"rows"];
            
            self.plistArr = [NSMutableArray array];
            for (NSDictionary *dic in locationArr) {
//                NSDictionary *DataDic = [NSMutableDictionary dictionary];
//                NSString *lat = [NSString stringWithFormat:@"%@",[dic objectForKey:@"latitude"]];
//                NSString *lon = [NSString stringWithFormat:@"%@",[dic objectForKey:@"longitude"]];
//                [DataDic setValue:lat forKey:@"lat"];
//                [DataDic setValue:lon forKey:@"lon"];
//                [DataDic setValue:[dic objectForKey:@"location"] forKey:@"location"];

                [self.plistArr addObject:dic];
            }
            
            if (self.plistArr.count > 0) {
                [self addmapAnimation];
                
                self.animationTime = 120.0 / self.plistArr.count;
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [CommonFunction removeProgress];
        
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}


- (void)setupView{
    
//    UIView *toolView0 = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height  - 50 - 64, WindowWidth, 50)];
//    toolView0.backgroundColor = [CommonFunction mainColor];
//    [self.view addSubview:toolView0];
//    
////    UIView *line0 =[[UIView alloc]initWithFrame:CGRectMake(0, 39, WindowWidth, 1)];
////    line0.backgroundColor = [UIColor whiteColor];
////    [toolView0 addSubview:line0];
//
//    
//    LRGlowingButton *StopBtn = [[LRGlowingButton alloc]initWithFrame:CGRectMake(50,64, 50, 50)];
//    StopBtn.center = CGPointMake(WindowWidth/2, 25);
////    [StopBtn setTitle:NSLocalizedString(@"HistoryTrackViewController_Pause", "暂停") forState:UIControlStateNormal];
//    [StopBtn setImage:[UIImage imageNamed:@"route_pauseBtn_normal"] forState:UIControlStateNormal];
//    StopBtn.backgroundColor = [CommonFunction mainColor];
//    [StopBtn addTarget:self action:@selector(stopBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView0 addSubview:StopBtn];
//
//    
//    
//    LRGlowingButton *startBtn = [[LRGlowingButton alloc]initWithFrame:CGRectMake(0,64, 50, 50)];
//    startBtn.center = CGPointMake(WindowWidth/2 - 80, 25);
//    [startBtn setImage:[UIImage imageNamed:@"route_startBtn_normal"] forState:UIControlStateNormal];
//    startBtn.backgroundColor = [CommonFunction mainColor];
//    [startBtn addTarget:self action:@selector(startBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView0 addSubview:startBtn];
//    
//    LRGlowingButton *restartBtn = [[LRGlowingButton alloc]initWithFrame:CGRectMake(0,64, 50, 50)];
//    restartBtn.center = CGPointMake(WindowWidth/2 + 80, 25);
//    [restartBtn setImage:[UIImage imageNamed:@"route_stopBtn_normal"] forState:UIControlStateNormal];
//    restartBtn.backgroundColor = [CommonFunction mainColor];
//    [restartBtn addTarget:self action:@selector(restartBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [toolView0 addSubview:restartBtn];


    
    UIView *secureRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height  - 80, WindowWidth, 40)];
    secureRangeView.backgroundColor = [CommonFunction mainColor];
    [self.view addSubview:secureRangeView];
    
    
#warning 动画时间设计中没有，暂时隐藏
    secureRangeView.hidden = YES;
    
    UILabel *safelable = [[UILabel alloc]init];
    safelable.text = NSLocalizedString(@"HistoryTrackViewController_animationTime", "动画时间");
    safelable.font = [UIFont systemFontOfSize:17.0];
    [secureRangeView addSubview:safelable];
    safelable.textAlignment = NSTextAlignmentLeft;
    CGSize lableSize = [safelable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    safelable.frame = CGRectMake(spaceWidth, 0, lableSize.width, 40);
    safelable.textColor = [UIColor whiteColor];
    
    CGSize rangeLabelSize = [@"200m " sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    
    UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(lableSize.width + 2*spaceWidth, 0, WindowWidth -(lableSize.width + 2*spaceWidth) - rangeLabelSize.width - 2 *spaceWidth, 40)];
    slide.minimumValue = 1;
    slide.maximumValue = 10;
    slide.value = 3;
    slide.minimumTrackTintColor = [UIColor whiteColor];
    slide.maximumTrackTintColor = [UIColor whiteColor];


    [slide addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventTouchUpInside];
    [secureRangeView addSubview:slide];
    self.slide = slide;
    
    UILabel *rangeLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(slide.frame) + spaceWidth, 0, rangeLabelSize.width, 40)];
    rangeLable.textColor = [UIColor whiteColor];
    rangeLable.text = @"3s";
    rangeLable.font = [UIFont systemFontOfSize:15.0];
    rangeLable.textAlignment = NSTextAlignmentCenter;
    [secureRangeView addSubview:rangeLable];
    self.rangeLable = rangeLable;
}


- (void)addmapAnimation{
    //添加点 线段
    CLLocationCoordinate2D PolylineCoords[self.plistArr.count];
    for (int i = 0; i < self.plistArr.count; i++) {
        NSDictionary *latlonDic = self.plistArr[i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[latlonDic objectForKey:@"latitude"] doubleValue],[[latlonDic objectForKey:@"longitude"] doubleValue]);
        
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
        pointAnnotation.coordinate = coordinate;
        if (![[latlonDic objectForKey:@"location"] isKindOfClass:[NSNull class]]) {
            pointAnnotation.title = [latlonDic objectForKey:@"location"];
        }
        
        if (i == 0) {
            objc_setAssociatedObject(pointAnnotation, @"isFirst", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        if (i == self.plistArr.count - 1) {
            objc_setAssociatedObject(pointAnnotation, @"isLast", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        objc_setAssociatedObject(pointAnnotation, @"showDic", latlonDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.mapView addAnnotation:pointAnnotation];
        
        PolylineCoords[i] = coordinate;
    }
    MKPolyline *ployLine = [MKPolyline polylineWithCoordinates:PolylineCoords count:self.plistArr.count];
    [self.mapView addOverlay:ployLine];
    
    
    //设置中点和缩放级别
    NSDictionary *latlonDic = self.plistArr[0];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[latlonDic objectForKey:@"latitude"] doubleValue],[[latlonDic objectForKey:@"longitude"] doubleValue]);
//    [self.mapView setCenterCoordinate:coordinate zoomLevel:20 animated:YES];
    [self.mapView setCenterCoordinate:coordinate zoomLevel:16 animated:YES];


}

//动画
- (void)aniationFunction{
    //1当已经暂停时停止动画和关闭定时器
    if (self.pauseAnimation) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    if (self.plistArr.count == 0) {
        return;
    }
    
    //2添加动画
    NSDictionary *latlonDic = self.plistArr[self.animationIndex];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[latlonDic objectForKey:@"latitude"] doubleValue],[[latlonDic objectForKey:@"longitude"] doubleValue]);
    
    [MKMapView animateWithDuration:self.animationTime animations:^{
        
//        [self.mapView setCenterCoordinate:coordinate animated:YES];
        
        [self.mapView setCenterCoordinate:coordinate zoomLevel:16 animated:YES];

        
    }];
    
    
    //3当播放到最后一个动画的时候关闭动画和定时器
    if (self.animationIndex == self.plistArr.count - 1) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    //动画指数加一
    self.animationIndex++;
}


#pragma mark sender
- (void)right_action{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[HistoryTrackView class]]) {
            return;
        }
    }
    
    NSDate *enddate = [NSDate date];
    NSDateFormatter *enddateFormatter = [[NSDateFormatter alloc]init];
    enddateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *endtime = [enddateFormatter stringFromDate:enddate];
    self.endTime = endtime;
    
    
    NSDate *startdate = [NSDate date];
    NSDateFormatter *startdateFormatter = [[NSDateFormatter alloc]init];
    startdateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *startTime = [startdateFormatter stringFromDate:startdate];
    startTime = [startTime stringByAppendingString:@" 00:00:00"];
    self.startTime = startTime;

    

    HistoryTrackView *historyTrackView = [[HistoryTrackView alloc]initWithFrame:self.view.bounds];
    historyTrackView.startTime = self.startTime;
    historyTrackView.endTime = self.endTime;
    historyTrackView.delegate = self;
    [self.view addSubview:historyTrackView];
    
    
}


- (void)stopBtn_clicked:(UIButton *)sender{
    self.pauseAnimation = YES;
}

- (void)startBtn_clicked:(UIButton *)sender{
    if (self.pauseAnimation == NO) {
        return;
    }
    
    self.pauseAnimation = NO;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.animationTime target:self selector:@selector(aniationFunction) userInfo:nil repeats:YES];
    self.timer = timer;
    [self.timer fire];
}


- (void)restartBtn_clicked:(UIButton *)sender{
    [self.timer invalidate];
    self.timer = nil;
    
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    [self addmapAnimation];
}

//slide 值改变
- (void)updateValue:(UISlider *)sender {
    NSInteger value =(NSInteger)sender.value;
    self.slide.value = value;
    self.rangeLable.text = [NSString stringWithFormat:@"%lds",(long)value];
    self.animationTime = value;
    //重新更新时间
    if (!self.pauseAnimation) {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:spaceTime + self.animationTime target:self selector:@selector(aniationFunction) userInfo:nil repeats:YES];
        self.timer = timer;
        [self.timer fire];
    }
}

#pragma mark  historyTrackViewDelegate;
- (void)historyTrackView:(HistoryTrackView *)checkView checkBtnClickedWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self getTrackDataWithStartTime:startTime endTime:endTime];
}


#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 4.f;
        polylineView.strokeColor = [CommonFunction mainColor];
        polylineView.lineJoin = kCGLineJoinRound;//连接类型
        
        return polylineView;
    }
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]]){
        //        MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
        //        annotationView.canShowCallout = YES;
        //        annotationView.draggable = YES;
        //        annotationView.image = [UIImage imageNamed:@"homeAnn"];
        //        return annotationView;
        
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        HistoryTrackAnnotationView  *annotationView = [[HistoryTrackAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        
        NSDictionary *dic = objc_getAssociatedObject(annotation, @"showDic");
        
        annotationView.text0 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"device name", @"设备名称"),[dic objectForKey:@"plateNo"]];
        annotationView.text1 = [NSString stringWithFormat:@"%@:%@%%    状态:%@    速度:%@km/h",NSLocalizedString(@"battery", @"电量"),[dic objectForKey:@"DianChiDianLiang"],[dic objectForKey:@"locationStatus"],[dic objectForKey:@"velocity"]];
        annotationView.text2 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"alert info", @"报警信息"),[dic objectForKey:@"alarmStateDescr"]];
        
        annotationView.text3 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"alert info", @"报警信息"),[dic objectForKey:@"sendTime"]];
        annotationView.text4 = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"recive time", @"接收时间"),[dic objectForKey:@"createDate"]];
        annotationView.text5 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"location"]];
        
        
        NSLog(@"%@",[dic objectForKey:@"direction"]);
        
        //        annotationView.calloutOffset = CGPointMake(0, -3);
        //        NSData *infoData = [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"locationInfo%@",[CommonFunction getUserID]]];
        //        LocationInfo *info = [LocationInfo parseFromData:infoData];
        //        annotationView.subTilte = [[NSUserDefaults standardUserDefaults]objectForKey:@"subtitle"];
        //        annotationView.info = info;
        
        
        
//        UIImage *img = [UIImage imageNamed:@"home_man_normal"];
        
        
//        annotationView.image = [UIImage imageNamed:@"home_man_normal"];
        annotationView.imageName = @"route_direction";
        
        
        if ([objc_getAssociatedObject(annotation, @"isFirst") boolValue]) {
            annotationView.imageName = @"route_start";
        };

        
        if ([objc_getAssociatedObject(annotation, @"isLast") boolValue]) {
            annotationView.imageName = @"route_end";
        };
        
        annotationView.oritation =[[dic objectForKey:@"direction"] integerValue] - 45;
    
        return annotationView;
    }
    
    return nil;
}






@end
