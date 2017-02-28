//
//  OneKeyTestingViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "OneKeyTestingViewController.h"

@interface OneKeyTestingViewController ()

@end

@implementation OneKeyTestingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"OneKeyTestingViewController_OneKeyTesting", "一键检测");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *bcView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WindowWidth, 230)];
    [self.view addSubview:bcView];
    bcView.backgroundColor = [CommonFunction mainColor];
    
    
    UIButton *textBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    textBtn.center = CGPointMake(WindowWidth/2.0, 230/2.0);
    [textBtn setImage:[UIImage imageNamed:@"test_Btn_normal"] forState:UIControlStateNormal];
    [bcView addSubview:textBtn];
    
    
    UILabel *textlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, textBtn.frame.size.width, textBtn.frame.size.height)];
    textlable.center = CGPointMake(70, 70);
    textlable.text = NSLocalizedString(@"OneKeyTestingViewController_OneKeyTesting", "一键检测");
    textlable.font = [UIFont boldSystemFontOfSize:18.0];
    textlable.textColor = [UIColor whiteColor];
    textlable.textAlignment = NSTextAlignmentCenter;
    [textBtn addSubview:textlable];

}


@end
