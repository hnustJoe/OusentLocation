//
//  ShowrectViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/10.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ShowrectViewController.h"
#import <MapKit/MapKit.h>
#import "MKMapView+MapViewUtil.h"


@interface ShowrectViewController ()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;


@end

@implementation ShowrectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    NSString *points = [self.dic objectForKey:@"points"];
    
    NSArray *arr= [points componentsSeparatedByString:@";"];
    
    
    NSArray *arr1 = [arr[0] componentsSeparatedByString:@","];
    NSArray *arr2 = [arr[1] componentsSeparatedByString:@","];
    NSArray *arr3 = [arr[2] componentsSeparatedByString:@","];
    NSArray *arr4 = [arr[3] componentsSeparatedByString:@","];

    
    CLLocationCoordinate2D PolylineCoords0 = CLLocationCoordinate2DMake([arr1[1] floatValue], [arr[0] floatValue]);
    CLLocationCoordinate2D PolylineCoords1 = CLLocationCoordinate2DMake([arr2[1] floatValue], [arr2[0] floatValue]);
    CLLocationCoordinate2D PolylineCoords2 = CLLocationCoordinate2DMake([arr3[1] floatValue], [arr3[0] floatValue]);
    CLLocationCoordinate2D PolylineCoords3 = CLLocationCoordinate2DMake([arr4[1] floatValue], [arr4[0] floatValue]);

    
    MKPointAnnotation *pointAnnotation0 = [[MKPointAnnotation alloc] init];
    pointAnnotation0.coordinate = PolylineCoords0;
    [_mapView addAnnotation:pointAnnotation0];
    
    MKPointAnnotation *pointAnnotation1 = [[MKPointAnnotation alloc] init];
    pointAnnotation1.coordinate = PolylineCoords1;
    [_mapView addAnnotation:pointAnnotation1];
    
    MKPointAnnotation *pointAnnotation2 = [[MKPointAnnotation alloc] init];
    pointAnnotation2.coordinate = PolylineCoords2;
    [_mapView addAnnotation:pointAnnotation2];

    
    
    MKPointAnnotation *pointAnnotation3 = [[MKPointAnnotation alloc] init];
    pointAnnotation3.coordinate = PolylineCoords3;
    [_mapView addAnnotation:pointAnnotation3];

    
    
    CLLocationCoordinate2D PolylineCoords[5];
    
    PolylineCoords[0] = PolylineCoords0;
    PolylineCoords[1] = PolylineCoords1;
    PolylineCoords[2] = PolylineCoords2;
    PolylineCoords[3] = PolylineCoords3;
    PolylineCoords[4] = PolylineCoords0;

    
    
    
    MKPolyline *ployLine = [MKPolyline polylineWithCoordinates:PolylineCoords count:5];
    [self.mapView addOverlay:ployLine];
    
    
    [self.mapView setCenterCoordinate:PolylineCoords0 zoomLevel:15 animated:YES];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"unbind", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightaction)];

}

- (void)rightaction{
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/UnBindEnclosure?vehicleId=%@&enclosureID=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId],[self.dic objectForKey:@"enclosureId"]];
    
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
            }];
            
        }else{
            [CommonFunction showRightMessageToView:self.view text:@"OK" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
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
