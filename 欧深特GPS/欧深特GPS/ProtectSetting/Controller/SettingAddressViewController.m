//
//  SettingAddressViewController.m
//  Onetalking
//
//  Created by Elwin on 15/11/10.
//  Copyright © 2015年 OneTalk. All rights reserved.
//

#import "SettingAddressViewController.h"
//#import <MAMapKit/MAMapKit.h>
#import "MKMapView+MapViewUtil.h"
#import <AMapSearchKit/AMapSearchKit.h>
//#import "UIColor+Hex.h"
#import <MapKit/MapKit.h>
@interface SettingAddressViewController ()<MKMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) MKMapView *mapView;
//@property (nonatomic,strong) AMapSearchAPI *search;
//@property (nonatomic,strong) UITextField *addressTextField;
@property (nonatomic,strong) UILabel *rangeLable;
@property (nonatomic,strong) UISlider *slide;
@property (nonatomic,strong) CLLocationManager *locationmanager;


@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@end

@implementation SettingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"pick address", nil);
    [self setMapView];
    [self setupView];
    

    self.slide.value = self.tempCareModel.radius;
    self.rangeLable.text = [NSString stringWithFormat:@"%ldm",(long)self.tempCareModel.radius];

    
    if ([CommonFunction getCurrentVehicleLat] && [CommonFunction getCurrentVehicleLng]) {
        NSString *lat =  [CommonFunction getCurrentVehicleLat];
        NSString *lng =  [CommonFunction getCurrentVehicleLng];
        
        self.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);

    }
    
    [self addOverlayAndAnnotion];

    
    
    
}






- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    
    self.tempCareModel.centerCoo = self.coordinate;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
}



#pragma mark private
- (void)setMapView{
    //地图对象
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.mapView addGestureRecognizer:mTap];


}

- (void)tapPress:(UIGestureRecognizer*)gestureRecognizer {
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];//这里touchMapCoordinate就是该点的经纬度了
    
    
    self.tempCareModel.centerCoo = touchMapCoordinate;
    self.coordinate = touchMapCoordinate;
    [self removeOverlayAndAnnotion];
    [self addOverlayAndAnnotion];
    //反地理编码


}

- (void)setupView{
    
    
    UIView *secureRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height  - 40 - 64, WindowWidth, 40)];
    secureRangeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:secureRangeView];
    
    UILabel *safelable = [[UILabel alloc]init];
    safelable.text = NSLocalizedString(@"safe range", nil);
    safelable.font = [UIFont systemFontOfSize:17.0];
    [secureRangeView addSubview:safelable];
    safelable.textAlignment = NSTextAlignmentLeft;
    CGSize lableSize = [safelable.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
    safelable.frame = CGRectMake(spaceWidth, 0, lableSize.width, 40);
    
    
    CGSize rangeLabelSize = [@"200m " sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    
    UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(lableSize.width + 2*spaceWidth, 0, WindowWidth -(lableSize.width + 2*spaceWidth) - rangeLabelSize.width - 2 *spaceWidth, 40)];
    slide.minimumValue = 200;
    slide.maximumValue = 500;
    slide.value = 200;
    [slide addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventTouchUpInside];
    [secureRangeView addSubview:slide];
    self.slide = slide;
    
    UILabel *rangeLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(slide.frame) + spaceWidth, 0, rangeLabelSize.width, 40)];
    rangeLable.textColor = [UIColor grayColor];
    rangeLable.text = @"200m";
    rangeLable.font = [UIFont systemFontOfSize:15.0];
    rangeLable.textAlignment = NSTextAlignmentCenter;
    [secureRangeView addSubview:rangeLable];
    self.rangeLable = rangeLable;
    


}

//slide 值改变
- (void)updateValue:(UISlider *)sender {
    NSInteger value =(NSInteger)sender.value ;
    self.slide.value = value;
    self.rangeLable.text = [NSString stringWithFormat:@"%ldm",(long)value];
    self.tempCareModel.radius = value;
    
    
    for (MKCircle *circle in self.mapView.overlays) {
        [self.mapView removeOverlay:circle];
    }
    
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:[[NSString stringWithFormat:@"%ld",(long)value] integerValue]];
    [_mapView addOverlay:circle];
}

//删除标注和圆圈
- (void)removeOverlayAndAnnotion{
    for (MKCircle *circle in self.mapView.overlays) {
        [self.mapView removeOverlay:circle];
    }
    for (MKPointAnnotation *pointAnnotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:pointAnnotation];
    }

}
//添加标注和圆圈
- (void)addOverlayAndAnnotion{
    
    if ((int)self.coordinate.latitude != 0) {
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:self.slide.value];
        [_mapView addOverlay:circle];
        
        //添加 标注
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = self.coordinate;
        [_mapView addAnnotation:pointAnnotation];
        
        
        [self.mapView setCenterCoordinate:self.coordinate zoomLevel:15 animated:YES];

    }
    
    
}

#pragma mark sender

- (void)doBack:(UIButton *)btn{

    self.tempCareModel.centerCoo = self.coordinate;
    
    [self.navigationController popViewControllerAnimated:YES];

}

//圆圈
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.lineWidth   = 1.f;
    circleRenderer.strokeColor = [UIColor colorWithRed:125/225.0 green:180/225.0 blue:254/225.0 alpha:1];
    circleRenderer.fillColor   = [UIColor colorWithRed:125/225.0 green:180/225.0 blue:254/225.0 alpha:.3];
    return circleRenderer;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]]){
                MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotation"];
                annotationView.canShowCallout = YES;
                annotationView.draggable = YES;
                annotationView.image = [UIImage imageNamed:@"homeAnn"];
                return annotationView;
    }
    
    return nil;
}

#pragma mark MAMapViewDelegate AMapSearchDelegate
-(void)dealloc{
    _mapView.delegate = nil;
    NSLog(@"death");
}
@end
