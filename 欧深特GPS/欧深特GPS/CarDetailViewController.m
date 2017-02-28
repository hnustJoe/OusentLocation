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
#import "CardetailTableViewCell.h"

#import "AccountManager.h"


@interface CarDetailViewController ()<CarlistSegmentControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) UITableView *tableView;




@property (nonatomic,strong) NSArray *vehicleArr;


@property (nonatomic,strong) NSMutableArray *selectArr;



@end

@implementation CarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CarlistSegmentController *carlistSeg = [[CarlistSegmentController alloc]initWithFrame:CGRectMake(0, 20, WindowWidth, 44)];
    carlistSeg.delegate = self;
    [self.view addSubview:carlistSeg];

    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(carlistSeg.frame), WindowWidth, WindowHeight - CGRectGetMaxY(carlistSeg.frame) - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource  =self;
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc]init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    if (self.isManycarsModel) {
        self.selectArr = [AccountManager shareInstance].selectArr;
//    }
    
    if (!self.selectArr) {
        self.selectArr = [NSMutableArray array];
    }
   
    
    self.selectIndex = [CommonFunction getCarListSelectIndex];
    carlistSeg.selectIndex = self.selectIndex;
    
    [self getAllVehicle];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(right_action)];
}

- (void)right_action{
    
    self.selectArr = [NSMutableArray array];
    
    for (NSDictionary *dic in self.allCarArr) {
        
        if ([[dic objectForKey:@"select"] boolValue]) {
            [self.selectArr addObject:dic];
        }
        
    }
    
    
    
    if (self.selectArr.count == 0) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"select car", nil) completionBlock:^{
            
        }];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:self.selectArr forKey:@"selectedCar"];
        
        [AccountManager shareInstance].selectArr = self.selectArr;

        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectCar" object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//获取所有的车辆
- (void)getAllVehicle{
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:15];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/List?pageNo=0&pageSize=5000",[CommonFunction getloginIP]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        
        
        [CommonFunction removeProgress];
        
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
               
            }];
            
        }else{
            
            NSLog(@"获取所有的车辆成功");
            NSDictionary *DataDic = [dic objectForKey:@"data"];
            NSArray *vehicleArr = [DataDic objectForKey:@"results"];
            self.vehicleArr = vehicleArr;
            
            
            self.allCarArr = [NSMutableArray array];
            self.onlineArr = [NSMutableArray array];
            self.outlineArr = [NSMutableArray array];
            
            
            for (NSDictionary *vehicleDic in vehicleArr) {
                
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:vehicleDic];
                [mutableDic setObject:@NO forKey:@"select"];

                
                for (NSDictionary *dic in self.selectArr) {
                    
                    if ([[mutableDic objectForKey:@"vehicleId"] integerValue] == [[dic objectForKey:@"vehicleId"] integerValue]) {
                        [mutableDic setObject:@YES forKey:@"select"];
                        break;
                    }
                    
                    
                    
                }
                
                

                
                
                    [self.allCarArr addObject:mutableDic];
                    
                    
                    if ([[vehicleDic objectForKey:@"online"] boolValue] == YES) {
                        [self.onlineArr addObject:mutableDic];
                    }else{
                        [self.outlineArr addObject:mutableDic];
                    }
                }
                
            }

        
        [self.tableView reloadData];
            
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}



#pragma mark CarlistSegmentControllerDelegate
- (void)carlistSegmentController:(CarlistSegmentController *)seg clickedIndex:(NSInteger)index{
    self.selectIndex = index;
    [self.tableView reloadData];
    
    [CommonFunction saveCarListSelectIndex:index];
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
    CardetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CardetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    

    
    
    switch (self.selectIndex) {
        case 0:{
            NSMutableDictionary *datadic = self.allCarArr[indexPath.row];
            cell.dataDic =  datadic;
        }
            break;
        case 1:
        {
            NSMutableDictionary *datadic = self.onlineArr[indexPath.row];
            cell.dataDic =  datadic;
        }
            break;
        case 2: {
            NSMutableDictionary *datadic = self.outlineArr[indexPath.row];
            cell.dataDic =  datadic;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSMutableDictionary *datadic;
    
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
    
    
    [datadic setObject:[NSNumber numberWithBool:![[datadic objectForKey:@"select"] boolValue]] forKey:@"select"];

    
//    if ([[datadic objectForKey:@"select"] boolValue]) {
//        [self.selectArr addObject:datadic];
//    }else{
//        [self.selectArr removeObject:datadic];
//    }
    
    [self.tableView reloadData];
    
    
    
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
