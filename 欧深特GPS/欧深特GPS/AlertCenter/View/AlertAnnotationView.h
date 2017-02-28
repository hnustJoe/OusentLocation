//
//  AlertAnnotationView.h
//  欧深特GPS
//
//  Created by joe on 2017/1/5.
//  Copyright © 2017年 OuShenTe. All rights reserved.
//

#import <MapKit/MapKit.h>


//#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "CustomCalloutView.h"
@interface AlertAnnotationView : MKAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;


@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) double time;
@property (nonatomic,assign) double radius;

@property (nonatomic,strong) NSString *subTilte;
@property (nonatomic,strong) NSString *imageName;


@property (nonatomic,strong) UIImageView *iconImageView;


@property (nonatomic,copy) NSString *text1;
@property (nonatomic,copy) NSString *text2;
@property (nonatomic,copy) NSString *text3;


@end

