//
//  CarlistSegmentController.h
//  欧深特GPS
//
//  Created by joe on 16/9/20.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarlistSegmentController;

@protocol CarlistSegmentControllerDelegate <NSObject>


- (void)carlistSegmentController:(CarlistSegmentController *)seg clickedIndex:(NSInteger)index;
@end

@interface CarlistSegmentController : UIView



@property (nonatomic,assign) id<CarlistSegmentControllerDelegate> delegate;


@end
