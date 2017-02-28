//
//  DeviceManagerViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/6.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "DeviceManagerViewController.h"
#import "AddDeviceViewController.h"


@interface DeviceManagerViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation DeviceManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SettingViewController_device management", "设备管理");
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}


#pragma mark uitableViewDatasourse&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingViewControllerCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    
    if (indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"DeviceManagerViewController_add device", nil);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else{
        cell.textLabel.text = NSLocalizedString(@"DeviceManagerViewController_unbind device", nil);
        cell.textLabel.textColor = [CommonFunction mainColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        AddDeviceViewController *vc = [[AddDeviceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView *logoutAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SettingViewController_sure to unbind current device?", "确认解绑当前设备吗？") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"SettingViewController_cancel", "取消") otherButtonTitles:NSLocalizedString(@"SettingViewController_unbind", "确认解绑"), nil];
        [logoutAlertView show];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
        
        NSString *str = [NSString stringWithFormat:@"http://%@/MobileVehicle.mvc/DeleteTerminal?vehicleId=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId]];
        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedString];
        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            
            [CommonFunction removeProgress];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            
            if ([[dic objectForKey:@"success"] boolValue] == NO) {
                
                
                    [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                        
                        
                    }];
                
                
            }else{
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"unbinddevice" object:nil];

                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }

            
            
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [queue addOperation:operation];
    }
}


@end
