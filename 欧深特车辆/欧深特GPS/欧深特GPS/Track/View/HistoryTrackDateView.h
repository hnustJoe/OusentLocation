//
//  OnetalkingDateView.h
//  Onetalking
//
//  Created by Elwin on 15/12/10.
//  Copyright © 2015年 OneTalk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryTrackDateView;
@protocol HistoryTrackDateViewDelegate <NSObject>

- (void)sureBtnClicked:(HistoryTrackDateView *)dateView Date:(NSDate *)date;

@end

@interface HistoryTrackDateView : UIView

@property (nonatomic,assign) id<HistoryTrackDateViewDelegate> delegate;


- (instancetype)initWithDate:(NSDate *)date title:(NSString *)title;
- (void)show;
- (void)dismiss;

@end
