//
//  OnetalkingDateView.m
//  Onetalking
//
//  Created by Elwin on 15/12/10.
//  Copyright © 2015年 OneTalk. All rights reserved.
//

#import "HistoryTrackDateView.h"

#define spaceWidth 12

@interface HistoryTrackDateView ()

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIView *bcView;
@property (nonatomic,strong) UIView *maskView;
@end

@implementation HistoryTrackDateView

- (instancetype)initWithDate:(NSDate *)date title:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
    if (self) {
        
        
        UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, WindowHeight)];
        maskView.alpha = 0;
        maskView.backgroundColor = [UIColor blackColor];
        self.maskView = maskView;
        [self addSubview:maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.maskView addGestureRecognizer:tap];
        
        

        
        UIView *bcView = [[UIView alloc]initWithFrame:CGRectMake(0, WindowHeight, WindowWidth, WindowHeight)];
        [self addSubview:bcView];
        bcView.backgroundColor = [UIColor clearColor];
        self.bcView = bcView;

        
        UILabel *toolLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, 40)];
        [bcView addSubview:toolLable];
        toolLable.textAlignment = NSTextAlignmentCenter;
        toolLable.backgroundColor = [UIColor whiteColor];
        toolLable.text =title;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, WindowWidth, 1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [toolLable addSubview:line];
        
        
        UIButton *leftbtn = [[UIButton alloc]initWithFrame:CGRectMake(spaceWidth, 8, 60, 24)];
        [leftbtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [leftbtn setTitleColor:[CommonFunction mainColor] forState:UIControlStateNormal];
        [bcView addSubview:leftbtn];
        [leftbtn addTarget:self action:@selector(leftBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGSize rightbtnSize = [NSLocalizedString(@"Confirm", nil) sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}];
        
        UIButton *rightbtn = [[UIButton alloc]initWithFrame:CGRectMake(WindowWidth - 60 - spaceWidth, 8, rightbtnSize.width, 24)];
        [rightbtn setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
        rightbtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [rightbtn setTitleColor:[CommonFunction mainColor] forState:UIControlStateNormal];
        [bcView addSubview:rightbtn];
        [rightbtn addTarget:self action:@selector(rightBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIDatePicker *pick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, WindowWidth, 200)];
        pick.datePickerMode = UIDatePickerModeDateAndTime;
//        [pick setLocale:[[NSLocale alloc]initWithLocaleIdentifier:[[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleIdentifier]]];
        if (!date) {
            pick.date = [NSDate date];
        }else {
            pick.date = date;
        }
        pick.maximumDate = [NSDate date];
        pick.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
        pick.backgroundColor = [UIColor whiteColor];
        [bcView addSubview:pick];
        self.datePicker = pick;
}
    return self;
}






- (void)tap{
    [self dismiss];
}
- (void)leftBtn_clicked{
    [self dismiss];
}


- (void)rightBtn_clicked{
    [self.delegate sureBtnClicked:self Date:self.datePicker.date];
    [self dismiss];
}
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.bcView.frame = CGRectMake(0, WindowHeight - 240, WindowWidth, 240);
        self.maskView.alpha = 0.4;
        
    }];
}
- (void)dismiss{

    [UIView animateWithDuration:0.2 animations:^{
        self.bcView.frame = CGRectMake(0, WindowHeight, WindowWidth, 240);
        self.maskView.alpha = 0;

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
