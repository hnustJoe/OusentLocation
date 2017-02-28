//
//  HistoryTrackView.m
//  欧深特GPS
//
//  Created by joe on 16/9/20.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "HistoryTrackView.h"
#import "HistoryTrackDateView.h"


@interface HistoryTrackView ()<HistoryTrackDateViewDelegate>

@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,strong) UIButton *endBtn;


@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@end

@implementation HistoryTrackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *bcView = [[UIView alloc]initWithFrame:self.bounds];
        bcView.backgroundColor = [UIColor blackColor];
        bcView.alpha = 0.3;
        [self addSubview:bcView];
        
        UITapGestureRecognizer *bcViewtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bcView_tap:)];
        [bcView addGestureRecognizer:bcViewtap];
        
        
        
        
        UIView *bcWhiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WindowWidth - 40, 180)];
        bcWhiteView.backgroundColor = [UIColor whiteColor];
        bcWhiteView.center = self.center;
        [self addSubview:bcWhiteView];
        bcWhiteView.layer.masksToBounds = YES;
        bcWhiteView.layer.cornerRadius = 3;

        
        UILabel *startTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, 80, 30)];
        startTimeLable.text = NSLocalizedString(@"HistoryTrackView_start time", "开始时间");
        [bcWhiteView addSubview:startTimeLable];

        
        UIImage *normal = [UIImage imageNamed:@"route_inputbox"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(2, 10, 30, 100) resizingMode:UIImageResizingModeStretch];
        
        UIButton *startTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startTimeLable.frame) + 3, startTimeLable.frame.origin.y, WindowWidth - CGRectGetMaxX(startTimeLable.frame) - 3 - 40 - 12, 30)];
        [startTimeBtn setBackgroundImage:normal forState:UIControlStateNormal];
        [startTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        startTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        startTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [bcWhiteView addSubview:startTimeBtn];
        self.startBtn = startTimeBtn;
        [self.startBtn addTarget:self action:@selector(startBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];

        
        
        UILabel *endTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(startTimeLable.frame) + 10, 80, 30)];
        endTimeLable.text = NSLocalizedString(@"HistoryTrackView_end time", "结束时间");
        [bcWhiteView addSubview:endTimeLable];
        
        UIButton *endTimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(endTimeLable.frame) + 3, endTimeLable.frame.origin.y, WindowWidth - CGRectGetMaxX(endTimeLable.frame) - 3 - 40 - 12, 30)];
        [endTimeBtn setBackgroundImage:normal forState:UIControlStateNormal];
        [endTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        endTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        endTimeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [bcWhiteView addSubview:endTimeBtn];
        self.endBtn = endTimeBtn;
        [self.endBtn addTarget:self action:@selector(endTimeBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(endTimeBtn.frame) + 20, bcWhiteView.frame.size.width - 40, 30)];
        [bcWhiteView addSubview:checkBtn];
        checkBtn.backgroundColor = [CommonFunction mainColor];
        checkBtn.layer.masksToBounds = YES;
        checkBtn.layer.cornerRadius = 3;
        [checkBtn setTitle:NSLocalizedString(@"HistoryTrackView_check", "查询") forState:UIControlStateNormal];
        [checkBtn addTarget:self action:@selector(checkBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

#pragma mark sender
- (void)bcView_tap:(UITapGestureRecognizer *)reg{
    [self removeFromSuperview];
}


- (void)startBtn_clicked:(UIButton *)sender{
    HistoryTrackDateView *datePicker = [[HistoryTrackDateView alloc]initWithDate:[NSDate date] title:NSLocalizedString(@"HistoryTrackView_startTime", "开始时间")];
    [datePicker show];
    datePicker.delegate = self;
    datePicker.tag = 0;
    
    

}



- (void)endTimeBtn_clicked:(UIButton *)sender{
    HistoryTrackDateView *datePicker = [[HistoryTrackDateView alloc]initWithDate:[NSDate date] title:NSLocalizedString(@"HistoryTrackView_endTime", "结束时间")];
    [datePicker show];
    datePicker.delegate = self;
    datePicker.tag = 1;

}


- (void)checkBtn_clicked:(UIButton *)sender{
    
    
    
    if (self.startBtn.titleLabel.text.length < 1) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"HistoryTrackView_startTime can't be empty", "开始时间不能为空") completionBlock:^{
            
        }];
        return;
    }else if(self.endBtn.titleLabel.text.length < 1){
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"HistoryTrackView_endTime can't be empty", "结束时间不能为空") completionBlock:^{
            
        }];
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    NSDate *startDate = [dateFormatter dateFromString:self.startTime];
    NSTimeInterval startDateInterval = [startDate timeIntervalSince1970];
    NSDate *endDate = [dateFormatter dateFromString:self.endTime];
    NSTimeInterval endDateInterval = [endDate timeIntervalSince1970];
    
    
    if (startDateInterval >= endDateInterval) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"HistoryTrackView_startTime is bigger than endTime", "开始时间大于结束时间") completionBlock:^{
            
        }];
        
        return;
    }
    
    
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(historyTrackView:checkBtnClickedWithStartTime:endTime:)]) {
        [self.delegate historyTrackView:self checkBtnClickedWithStartTime:self.startBtn.titleLabel.text endTime:self.endBtn.titleLabel.text];
    }
    
    [self removeFromSuperview];
    
}





#pragma mark OnetalkingDateViewDelegate
- (void)sureBtnClicked:(HistoryTrackDateView *)dateView Date:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [dateFormatter stringFromDate:date];
    if (dateView.tag == 0) {
        self.startTime = time;
        [self.startBtn setTitle:time forState:UIControlStateNormal];
    }else{
        self.endTime = time;
        [self.endBtn setTitle:time forState:UIControlStateNormal];
    }
}
@end
