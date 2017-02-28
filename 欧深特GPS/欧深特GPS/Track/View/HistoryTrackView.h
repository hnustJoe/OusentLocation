//
//  HistoryTrackView.h
//  欧深特GPS
//
//  Created by joe on 16/9/20.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryTrackView;

@protocol HistoryTrackViewDelegate <NSObject>

- (void)historyTrackView:(HistoryTrackView *)checkView checkBtnClickedWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
@end

@interface HistoryTrackView : UIView

@property (nonatomic,assign) id<HistoryTrackViewDelegate> delegate;

@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@end
