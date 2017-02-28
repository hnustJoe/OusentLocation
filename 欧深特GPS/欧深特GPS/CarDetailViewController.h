//
//  CarDetailViewController.h
//  欧深特GPS
//
//  Created by joe on 16/9/30.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarDetailViewController : UIViewController

@property (nonatomic,assign) BOOL isManycarsModel;


@property (nonatomic,strong) NSMutableArray *allCarArr;
@property (nonatomic,strong) NSMutableArray *onlineArr;
@property (nonatomic,strong) NSMutableArray *outlineArr;


@end
