//
//  CarlistSegmentController.m
//  欧深特GPS
//
//  Created by joe on 16/9/20.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CarlistSegmentController.h"


#define slantLineWidth 20
#define normalColor [UIColor lightGrayColor]
#define selectColor [CommonFunction mainColor]


@interface CarlistSegmentController ()


@property (nonatomic,strong) UIButton *allBtn;
@property (nonatomic,strong) UIButton *onlineBtn;
@property (nonatomic,strong) UIButton *outlineBtn;

@end


@implementation CarlistSegmentController


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        UIButton *allBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width/3.0, height)];
        allBtn.backgroundColor = selectColor;
        [allBtn setTitle:NSLocalizedString(@"CarlistViewController_all", "全部") forState:UIControlStateNormal];
        [self addSubview:allBtn];
        CAShapeLayer *allshaperLayer = [CAShapeLayer layer];
        UIBezierPath *allPath = [UIBezierPath bezierPath];
        [allPath moveToPoint:CGPointMake(0, 0)];
        [allPath addLineToPoint:CGPointMake(WindowWidth/3.0, 0)];
        [allPath addLineToPoint:CGPointMake(WindowWidth/3.0 - slantLineWidth, 44)];
        [allPath addLineToPoint:CGPointMake(0, 44)];
        allshaperLayer.path = allPath.CGPath;
        allBtn.layer.mask = allshaperLayer;
        self.allBtn = allBtn;
        
        UIButton *onlineBtn = [[UIButton alloc]initWithFrame:CGRectMake(width/3.0 - slantLineWidth, 0, width/3.0 + slantLineWidth, height)];
        onlineBtn.backgroundColor = normalColor;
        [onlineBtn setTitle:NSLocalizedString(@"CarlistViewController_online", "在线") forState:UIControlStateNormal];
        CAShapeLayer *onlineshaperLayer = [CAShapeLayer layer];
        UIBezierPath *onlinePath = [UIBezierPath bezierPath];
        [onlinePath moveToPoint:CGPointMake(slantLineWidth, 0)];
        [onlinePath addLineToPoint:CGPointMake(WindowWidth/3.0 + slantLineWidth, 0)];
        [onlinePath addLineToPoint:CGPointMake(WindowWidth/3.0 , 44)];
        [onlinePath addLineToPoint:CGPointMake(0, 44)];
        onlineshaperLayer.path = onlinePath.CGPath;
        onlineBtn.layer.mask = onlineshaperLayer;
        [self addSubview:onlineBtn];
        self.onlineBtn = onlineBtn;
        
        
        
        UIButton *outLineBtn = [[UIButton alloc]initWithFrame:CGRectMake(2*width/3.0 - slantLineWidth, 0, width/3.0 + slantLineWidth, height)];
        outLineBtn.backgroundColor = normalColor;
        [outLineBtn setTitle:NSLocalizedString(@"CarlistViewController_outLine", "离线") forState:UIControlStateNormal];
        CAShapeLayer *outLineshaperLayer = [CAShapeLayer layer];
        UIBezierPath *outLinePath = [UIBezierPath bezierPath];
        [outLinePath moveToPoint:CGPointMake(slantLineWidth, 0)];
        [outLinePath addLineToPoint:CGPointMake(WindowWidth/3.0 + slantLineWidth, 0)];
        [outLinePath addLineToPoint:CGPointMake(WindowWidth/3.0 + slantLineWidth, 44)];
        [outLinePath addLineToPoint:CGPointMake(0, 44)];
        outLineshaperLayer.path = outLinePath.CGPath;
        outLineBtn.layer.mask = outLineshaperLayer;
        [self addSubview:outLineBtn];
        self.outlineBtn = outLineBtn;
        
        
        [self.allBtn addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.onlineBtn addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.outlineBtn addTarget:self action:@selector(btn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        self.allBtn.tag = 0;
        self.onlineBtn.tag = 1;
        self.outlineBtn.tag = 2;
    }
    return self;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (selectIndex == 0) {
        self.allBtn.backgroundColor = selectColor;
        self.onlineBtn.backgroundColor = normalColor;
        self.outlineBtn.backgroundColor = normalColor;
    }
    
    if (selectIndex == 1) {
        self.allBtn.backgroundColor = normalColor;
        self.onlineBtn.backgroundColor = selectColor;
        self.outlineBtn.backgroundColor = normalColor;

    }
    
    if (selectIndex == 2) {
        self.allBtn.backgroundColor = normalColor;
        self.onlineBtn.backgroundColor = normalColor;
        self.outlineBtn.backgroundColor = selectColor;
        
    }
    
    
}

- (void)btn_clicked:(UIButton *)sender{
    
    if ([sender.backgroundColor isEqual:selectColor]) {
        return;
    }
    
    sender.backgroundColor =selectColor;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]] && view.tag != sender.tag) {
            view.backgroundColor = normalColor;
        }
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(carlistSegmentController:clickedIndex:)]) {
        [self.delegate carlistSegmentController:self clickedIndex:sender.tag];
    }
}

@end
