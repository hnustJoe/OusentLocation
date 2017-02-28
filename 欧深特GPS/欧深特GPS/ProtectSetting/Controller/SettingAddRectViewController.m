//
//  SettingAddRectViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/10.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "SettingAddRectViewController.h"
#import "MKMapView+MapViewUtil.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MapKit/MapKit.h>

@interface SettingAddRectViewController ()<MKMapViewDelegate>


@property (nonatomic,strong) MKMapView *mapView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SettingAddRectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = [NSMutableArray array];
    
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];
}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    if (self.dataArr.count >= 4) {
        return;
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =[self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里
    
    //添加 标注
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = touchMapCoordinate;
    [_mapView addAnnotation:pointAnnotation];

    
    //反地理编码
    
    [self.dataArr addObject:pointAnnotation];
    
    
    if (self.dataArr.count == 4) {
        
        CLLocationCoordinate2D PolylineCoords[5];
        
        PolylineCoords[0] = [self.dataArr[0] coordinate];
        PolylineCoords[1] = [self.dataArr[1] coordinate];
        PolylineCoords[2] = [self.dataArr[2] coordinate];
        PolylineCoords[3] = [self.dataArr[3] coordinate];
        PolylineCoords[4] = [self.dataArr[0] coordinate];


        

        MKPolyline *ployLine = [MKPolyline polylineWithCoordinates:PolylineCoords count:5];
        [self.mapView addOverlay:ployLine];
        
        
        self.tempCareModel.points = [NSString stringWithFormat:@"%f,%f;%f,%f;%f,%f;%f,%f;",PolylineCoords[0].longitude,PolylineCoords[0].latitude,
            PolylineCoords[1].longitude,PolylineCoords[1].latitude,
            PolylineCoords[2].longitude,PolylineCoords[2].latitude,
           PolylineCoords[3].longitude,PolylineCoords[3].latitude];
        
        
    }
    
    
}

#pragma mark MKMapViewDelegate
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 2.f;
        polylineView.strokeColor = [CommonFunction mainColor];
        polylineView.lineJoin = kCGLineJoinRound;//连接类型
        
        return polylineView;
    }
    return nil;
}


@end
