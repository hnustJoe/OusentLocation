//
//  HomeBottomView.h
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>


#define bottomPullHeight 44 //底部的拉条高度
#define HomeBottomViewspaceWidth 10 //空隙的宽度

#define bottomCellWeight (WindowWidth - HomeBottomViewspaceWidth*4)/3.0 //下部按钮的宽度
#define bottomHeight (bottomCellWeight*2 + HomeBottomViewspaceWidth*3 + bottomPullHeight) //底部的高度


@protocol HomeBottomViewDelegate <NSObject>

- (void)HomeBottomViewpullBtn_clicked:(UIButton *)sender;
- (void)HomeBottomViewcellBTn_clicked:(UIButton *)sender;

@end

@interface HomeBottomView : UIView

- (instancetype)initWithFrame:(CGRect)frame DataArr:(NSMutableArray *)cellArr;
@property (nonatomic,assign) id<HomeBottomViewDelegate> delegate;
@property (nonatomic,strong) UIImageView *pullArrowImageView;


@end
