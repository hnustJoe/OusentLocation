//
//  ProtectSettingViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ProtectSettingViewController.h"
#import <MapKit/MapKit.h>

@interface ProtectSettingViewController ()

@property (nonatomic,strong) MKMapView *mapView;
@end

@implementation ProtectSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ProtectSettingViewController_ProtectSetting", "设防控制");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
}



@end
