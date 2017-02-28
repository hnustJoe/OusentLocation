//
//  HomeBottomView.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "HomeBottomView.h"


#define imageleftSpaceWitdth 15
#define imagetopSpaceWitdth 5

@interface HomeBottomView ()


@end


@implementation HomeBottomView

- (instancetype)initWithFrame:(CGRect)frame DataArr:(NSMutableArray *)cellArr{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *pullBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WindowWidth, bottomPullHeight)];
        pullBtn.backgroundColor = [CommonFunction mainColor] ;
        pullBtn.selected = YES;//选中时代表已经上拉显示，未选中代表没有显示
        [self addSubview:pullBtn];
        [pullBtn addTarget:self action:@selector(pullBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
        pullBtn.alpha = 0.3;
        
        
        
        UIImageView *pullArrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bottomPullHeight, bottomPullHeight)];
        pullArrowImageView.center = CGPointMake(WindowWidth/2.0, bottomPullHeight/2.0);
        pullArrowImageView.image = [UIImage imageNamed:@"home_arrow_normal"];
        [pullBtn addSubview:pullArrowImageView];
        self.pullArrowImageView = pullArrowImageView;
        
        
        CAShapeLayer *pullBtnshaperLayer = [CAShapeLayer layer];
        UIBezierPath *pullBtnpath = [UIBezierPath bezierPathWithRoundedRect:pullBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
        pullBtnshaperLayer.path = pullBtnpath.CGPath;
        pullBtn.layer.mask = pullBtnshaperLayer;
        
        

        
    
        self.backgroundColor = [UIColor lightGrayColor];
        
        UIView *cellBcView = [[UIView alloc]initWithFrame:CGRectMake(0, bottomPullHeight, WindowWidth, bottomHeight - bottomPullHeight)];
        [self addSubview:cellBcView];
        cellBcView.backgroundColor = [UIColor colorWithRed:250/255.0 green:159/255.0 blue:114/255.0 alpha:1];
        
        for (int i = 0; i < 6; i ++) {
            NSMutableDictionary *celldic = cellArr[i];
            NSString *key = [celldic allKeys][0];
            UIImage *img = [celldic objectForKey:key];
            
            CGFloat x = HomeBottomViewspaceWidth + i%3 * (bottomCellWeight + HomeBottomViewspaceWidth);
            CGFloat y = bottomPullHeight + HomeBottomViewspaceWidth + i/3 * (bottomCellWeight + HomeBottomViewspaceWidth);
            
            UIButton *cellBTn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, bottomCellWeight, bottomCellWeight)];
//            [cellBTn setTitle:key forState:UIControlStateNormal];
//            [cellBTn setImage:img forState:UIControlStateNormal];
            cellBTn.tag = i;
            [cellBTn addTarget:self action:@selector(cellBTn_clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cellBTn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cellBTn.backgroundColor = [UIColor whiteColor];
            [self addSubview:cellBTn];

            
            
            CGFloat imgWidth = bottomCellWeight - imageleftSpaceWitdth*2;
            CGFloat imgHeight = imgWidth;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageleftSpaceWitdth, imagetopSpaceWitdth, imgWidth, imgHeight)];
            imageView.image = img;
            [cellBTn addSubview:imageView];

            
        

            
            UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame), imageView.frame.size.width, bottomCellWeight - imgHeight - imagetopSpaceWitdth)];
            nameLable.textAlignment = NSTextAlignmentCenter;
            nameLable.text = key;
            nameLable.font = [CommonFunction SmallFont];
            [cellBTn addSubview:nameLable];

            
            
            
            
            
        }

        
    }
    
    return self;
}

- (void)pullBtn_clicked:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(HomeBottomViewpullBtn_clicked:)] && self.delegate) {
        [self.delegate HomeBottomViewpullBtn_clicked:sender];
    }
    
}


- (void)cellBTn_clicked:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(HomeBottomViewcellBTn_clicked:)] && self.delegate) {
        [self.delegate HomeBottomViewcellBTn_clicked:sender];
    }

}


@end
