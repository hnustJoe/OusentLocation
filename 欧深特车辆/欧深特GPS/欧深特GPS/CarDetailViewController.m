//
//  CarDetailViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/30.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CarDetailViewController.h"
#import "CarlistSegmentController.h"
#import <objc/runtime.h>


@interface CarDetailViewController ()<CarlistSegmentControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) NSMutableArray *allCarArr;
//@property (nonatomic,strong) NSMutableArray *onlineArr;
//@property (nonatomic,strong) NSMutableArray *outlineArr;

@end

@implementation CarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CarlistSegmentController *carlistSeg = [[CarlistSegmentController alloc]initWithFrame:CGRectMake(0, 64
                                                                                                     , WindowWidth, 44)];
    carlistSeg.delegate = self;
    [self.view addSubview:carlistSeg];

    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(carlistSeg.frame), WindowWidth - 24, WindowHeight - CGRectGetMaxY(carlistSeg.frame) - 200) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource  =self;
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc]init];

}

#pragma mark CarlistSegmentControllerDelegate
- (void)carlistSegmentController:(CarlistSegmentController *)seg clickedIndex:(NSInteger)index{
    self.selectIndex = index;
    [self.tableView reloadData];
}


#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.selectIndex) {
        case 0:
            return self.allCarArr.count;
            break;
        case 1:
            return self.onlineArr.count;
            break;
        case 2:
            return self.outlineArr.count;
            break;
            
        default:
            return 0;
            break;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CarlistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    
    switch (self.selectIndex) {
        case 0:{
            NSDictionary *datadic = self.allCarArr[indexPath.row];
            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
            
        }
            break;
        case 1:
        {
            NSDictionary *datadic = self.onlineArr[indexPath.row];
            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
            
        }
            break;
        case 2: {
            NSDictionary *datadic = self.outlineArr[indexPath.row];
            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *datadic;
    
    switch (self.selectIndex) {
        case 0:{
            datadic = self.allCarArr[indexPath.row];
        }
            break;
        case 1:
        {
            datadic = self.onlineArr[indexPath.row];
        }
            break;
        case 2: {
            datadic = self.outlineArr[indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    
    
    UIAlertView *selectvehcileAlertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@ %@？",NSLocalizedString(@"CarlistViewController_sure to switch to car of", "确认切换到车辆"),[datadic objectForKey:@"plateNo"]] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", "取消") otherButtonTitles:NSLocalizedString(@"Confirm", "确认"), nil];
    NSString *vehicleId = [NSString stringWithFormat:@"%@",[datadic objectForKey:@"vehicleId"]];;
    objc_setAssociatedObject(selectvehcileAlertView, @"vehicleId", vehicleId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [selectvehcileAlertView show];
    
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *vehicleId = objc_getAssociatedObject(alertView, @"vehicleId");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"swithCurrentCarNoti" object:nil userInfo:[NSDictionary dictionaryWithObject:vehicleId forKey:@"vehicleId"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
