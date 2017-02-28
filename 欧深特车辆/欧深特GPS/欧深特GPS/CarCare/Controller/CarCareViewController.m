//
//  CarCareViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CarCareViewController.h"

@interface CarCareViewController ()

@end

@implementation CarCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"CarCareViewController_CarCare", "车况养护");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileVehicleList.mvc/GetVehicleById?vehicleId=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId]]];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:10];
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
                AppDelegate *appDelegate =  [UIApplication sharedApplication].delegate;
                [appDelegate enterLoginVC];
            }];
            
        }else{
            
            NSLog(@"获取车辆信息成功");
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            
            

            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
}


@end
