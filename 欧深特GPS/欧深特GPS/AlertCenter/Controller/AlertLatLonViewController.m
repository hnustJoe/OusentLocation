//
//  AlertLatLonViewController.m
//  欧深特GPS
//
//  Created by joe on 2016/12/6.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AlertLatLonViewController.h"
#import <MapKit/MapKit.h>
#import "MKMapView+MapViewUtil.h"

#import "CustomAnnotationView.h"
#import "AlertAnnotationView.h"


@interface AlertLatLonViewController ()<MKMapViewDelegate>

@end

@implementation AlertLatLonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
    mapView.delegate = self;
    
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lon doubleValue]);
    pointAnnotation.title = self.time;
    pointAnnotation.subtitle = self.location;
   
    [mapView addAnnotation:pointAnnotation];
   
    [mapView setCenterCoordinate: CLLocationCoordinate2DMake([self.lat doubleValue], [self.lon doubleValue]) zoomLevel:17 animated:YES];

}

#pragma mark mkmapViewAnnonation
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKPointAnnotation class]]){
  
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        AlertAnnotationView  *annotationView = [[AlertAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        
        
        annotationView.text1 = self.name;
        annotationView.text2 = self.time;
        annotationView.text3 = self.location;
        annotationView.image = [UIImage imageNamed:@"homeAnn"];
        
        return annotationView;
    }
    
    return nil;
}


@end
