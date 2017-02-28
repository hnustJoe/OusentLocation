//
//  AlertDetailTableViewCell.h
//  欧深特GPS
//
//  Created by joe on 2017/1/3.
//  Copyright © 2017年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertDetailTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel *nameLable;
@property (nonatomic,strong) UILabel *timeLable;
@property (nonatomic,strong) UILabel *loactionLable;

@property (nonatomic,assign) NSInteger rowHeight;

- (void)setDataDic:(NSDictionary *)dic;


@end
