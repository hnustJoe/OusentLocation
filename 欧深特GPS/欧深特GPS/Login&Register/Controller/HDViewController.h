//
//  CSIIViewController.h
//  ScrollView
//
//  Created by Hu Di on 13-10-11.
//  Copyright (c) 2013年 Sanji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDScrollview.h"

@class HDViewController;
@protocol HDViewControllerDelegate <NSObject>

- (void)lastPageClicked:(HDViewController *)vc;

@end

@interface HDViewController : UIViewController<UIScrollViewDelegate,HDScrollviewDelegate>

@property (nonatomic,assign) id<HDViewControllerDelegate> delegate;
@end
