//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

//#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MKAnnotationView

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
@property (nonatomic,copy) NSString *text4;
@property (nonatomic,copy) NSString *text5;






@end
