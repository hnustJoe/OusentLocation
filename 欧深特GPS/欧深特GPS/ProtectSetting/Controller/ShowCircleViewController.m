//
//  ShowCircleViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/10.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ShowCircleViewController.h"
#import <MapKit/MapKit.h>
#import "MKMapView+MapViewUtil.h"


@interface ShowCircleViewController ()<MKMapViewDelegate>

@property (nonatomic,strong) MKMapView *mapView;

@end

@implementation ShowCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    
    NSString *points = [self.dic objectForKey:@"points"];
    
    NSArray *arr= [points componentsSeparatedByString:@","];
    
    CLLocationCoordinate2D PolylineCoords = CLLocationCoordinate2DMake([arr[1] floatValue], [arr[0] floatValue]);
    
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:PolylineCoords radius:[[self.dic objectForKey:@"radius"] floatValue]];
    [_mapView addOverlay:circle];
    
    //添加 标注
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = PolylineCoords;
    [_mapView addAnnotation:pointAnnotation];
    
    
    [self.mapView setCenterCoordinate:PolylineCoords zoomLevel:15 animated:YES];
    
    
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


//圆圈
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    circleRenderer.lineWidth   = 1.f;
    circleRenderer.strokeColor = [UIColor colorWithRed:125/225.0 green:180/225.0 blue:254/225.0 alpha:1];
    circleRenderer.fillColor   = [UIColor colorWithRed:125/225.0 green:180/225.0 blue:254/225.0 alpha:.3];
    return circleRenderer;
}
@end
