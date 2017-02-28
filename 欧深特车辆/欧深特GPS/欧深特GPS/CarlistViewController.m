//
//  CarlistViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/19.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CarlistViewController.h"
#import "CarlistSegmentController.h"
#import "BDDynamicTreeNode.h"
#import "BDDynamicTree.h"
#import "CarDetailViewController.h"
#import <objc/runtime.h>



@interface CarlistViewController ()<BDDynamicTreeDelegate>


@property (nonatomic,strong) BDDynamicTree *dynamicTree;
//@property (nonatomic,strong) UIView *upBcview;

//@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *allCarArr;
@property (nonatomic,strong) NSMutableArray *onlineArr;
@property (nonatomic,strong) NSMutableArray *outlineArr;

//@property (nonatomic,assign) NSInteger selectIndex;


@property (nonatomic,strong) NSArray *groupArr;
@property (nonatomic,strong) NSArray *vehicleArr;


@end

@implementation CarlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"CarlistViewController_CarList", "车辆列表");
    self.view.backgroundColor = [UIColor whiteColor];
    

    
    

    
    
//    UIView *upBcview = [[UIView alloc]initWithFrame:CGRectMake(0, 150, WindowWidth, WindowHeight - 200)];
//    [self.view addSubview:upBcview];
//    self.upBcview = upBcview;
    
//    CarlistSegmentController *carlistSeg = [[CarlistSegmentController alloc]initWithFrame:CGRectMake(0, 0
//                                                                                                     , WindowWidth, 44)];
//    carlistSeg.delegate = self;
//    [self.upBcview addSubview:carlistSeg];
    
    
//    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(carlistSeg.frame), WindowWidth - 24, WindowHeight - CGRectGetMaxY(carlistSeg.frame) - 200) style:UITableViewStylePlain];
//    [self.upBcview addSubview:tableView];
//    tableView.delegate = self;
//    tableView.dataSource  =self;
//    self.tableView = tableView;
//    self.tableView.tableFooterView = [[UIView alloc]init];
//    
//    
    self.allCarArr = [NSMutableArray array];
    self.onlineArr = [NSMutableArray array];
    self.outlineArr = [NSMutableArray array];
    
    
    
    
    
    
    self.dynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) nodes:[self generateData]];
    self.dynamicTree.delegate = self;
    [self.view addSubview:self.dynamicTree];
    
    
    
    
    
    
    
    //获取所有的组
    [self getAllgroup];
    
    //获取所有的车辆
    [self getAllVehicle];

    
    
    
}

#pragma mark private
//获取所有的组
- (void)getAllgroup{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/DepartmentListByUser",[CommonFunction getloginIP]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            if ([[dic objectForKey:@"message"] hasPrefix:@"网页已经过期"]) {
                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                    [appDelegate enterLoginVC];
                }];
                return ;
            }
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                [appDelegate enterLoginVC];
            }];
            
        }else{
            
            NSLog(@"获取组成功");
            
            self.groupArr = [dic objectForKey:@"data"];
//            NSLog(@"%@",self.groupArr);
            
            
            self.dynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) nodes:[self generateData]];
            self.dynamicTree.delegate = self;
            [self.view addSubview:self.dynamicTree];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}


//获取所有的车辆
- (void)getAllVehicle{
    
   NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/List?pageNo=0&pageSize=5000",[CommonFunction getloginIP]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            if ([[dic objectForKey:@"message"] hasPrefix:@"网页已经过期"]) {
                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                    AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                    [appDelegate enterLoginVC];
                }];
                return ;
            }
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                [appDelegate enterLoginVC];
            }];
            
        }else{
            
            NSLog(@"获取所有的车辆成功");
            NSDictionary *DataDic = [dic objectForKey:@"data"];
            NSArray *vehicleArr = [DataDic objectForKey:@"results"];
            self.vehicleArr = vehicleArr;
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

- (NSArray *)generateData
{
    NSMutableArray *arr = [NSMutableArray array];
    
    
    BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
    root.originX = 20.f;
    root.isDepartment = YES;
    root.fatherNodeId = nil;
    root.nodeId = @"-1";
    root.name = @"选择分组";
    root.data = @{@"name":@"选择分组"};
    [arr addObject:root];

    
    
    for (NSDictionary *itemDic in self.groupArr) {
        BDDynamicTreeNode *root = [[BDDynamicTreeNode alloc] init];
        BOOL isDepartment = NO;
        
        for (NSDictionary *compareItem in self.groupArr) {
            if ([[compareItem objectForKey:@"parentId"] integerValue] == [[itemDic objectForKey:@"depId"] integerValue]) {
                isDepartment = YES;
                break;
            }
        }
        
    
        root.isDepartment = isDepartment;
        if ([[itemDic objectForKey:@"parentId"] integerValue] == 0) {
            root.fatherNodeId = @"-1";
        }else{
            root.fatherNodeId = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"parentId"]];
        }
        
        root.nodeId = [NSString stringWithFormat:@"%@",[itemDic objectForKey:@"depId"]];;
        root.name = [itemDic objectForKey:@"name"];
        root.data = @{@"name":[itemDic objectForKey:@"name"]};
        [arr addObject:root];
    }
    
    return arr;
}


#pragma mark BDDynamicTreeDelegate
- (void)dynamicTree:(BDDynamicTree *)dynamicTree didSelectedRowWithNode:(BDDynamicTreeNode *)node
{
    
    if (!node.isDepartment) {
        
    
//        [_dynamicTree removeFromSuperview];
//        _dynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 20) nodes:[self generateData]];
//        _dynamicTree.delegate = self;
//        [self.view addSubview:_dynamicTree];
        
        
        
        self.allCarArr = [NSMutableArray array];
        self.onlineArr = [NSMutableArray array];
        self.outlineArr = [NSMutableArray array];

        
        for (NSDictionary *vehicleDic in self.vehicleArr) {
            
            if ([[vehicleDic objectForKey:@"depName"] isEqualToString:node.name]) {
                
                [self.allCarArr addObject:vehicleDic];
                
                
                if ([[vehicleDic objectForKey:@"online"] boolValue] == YES) {
                    [self.onlineArr addObject:vehicleDic];
                }else{
                    [self.outlineArr addObject:vehicleDic];
                }
            }
            
        }
        
        
        
        CarDetailViewController *vc = [[CarDetailViewController alloc]init];
        vc.allCarArr = self.allCarArr;
        vc.onlineArr = self.onlineArr;
        vc.outlineArr = self.outlineArr;
        [self.navigationController pushViewController:vc animated:YES];
        vc.title = node.name;
        
        
        
        
        
//        [self.view bringSubviewToFront:self.upBcview];
//        [self.tableView reloadData];
        
        
    }
    
//    else{
//        
//        
//        
//        [self.view bringSubviewToFront:self.dynamicTree];
//        
//        
//    }
}



//#pragma mark UITableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    switch (self.selectIndex) {
//        case 0:
//            return self.allCarArr.count;
//            break;
//        case 1:
//            return self.onlineArr.count;
//            break;
//        case 2:
//            return self.outlineArr.count;
//            break;
//
//        default:
//            return 0;
//            break;
//    }
//    
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"CarlistCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    
//    
//    
//    switch (self.selectIndex) {
//        case 0:{
//            NSDictionary *datadic = self.allCarArr[indexPath.row];
//            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
//            
//        }
//            break;
//        case 1:
//        {
//            NSDictionary *datadic = self.onlineArr[indexPath.row];
//            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
//            
//        }
//            break;
//        case 2: {
//            NSDictionary *datadic = self.outlineArr[indexPath.row];
//            cell.textLabel.text = [datadic objectForKey:@"plateNo"];
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    NSDictionary *datadic;
//    
//    switch (self.selectIndex) {
//        case 0:{
//            datadic = self.allCarArr[indexPath.row];
//        }
//            break;
//        case 1:
//        {
//            datadic = self.onlineArr[indexPath.row];
//        }
//            break;
//        case 2: {
//            datadic = self.outlineArr[indexPath.row];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    
//    
//    UIAlertView *selectvehcileAlertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@ %@？",NSLocalizedString(@"CarlistViewController_sure to switch to car of", "确认切换到车辆"),[datadic objectForKey:@"plateNo"]] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", "取消") otherButtonTitles:NSLocalizedString(@"Confirm", "确认"), nil];
//    NSString *vehicleId = [NSString stringWithFormat:@"%@",[datadic objectForKey:@"vehicleId"]];;
//    objc_setAssociatedObject(selectvehcileAlertView, @"vehicleId", vehicleId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [selectvehcileAlertView show];
//
//}

//#pragma mark CarlistSegmentControllerDelegate
//- (void)carlistSegmentController:(CarlistSegmentController *)seg clickedIndex:(NSInteger)index{
//    self.selectIndex = index;
//    [self.tableView reloadData];
//}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *vehicleId = objc_getAssociatedObject(alertView, @"vehicleId");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"swithCurrentCarNoti" object:nil userInfo:[NSDictionary dictionaryWithObject:vehicleId forKey:@"vehicleId"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}



@end
