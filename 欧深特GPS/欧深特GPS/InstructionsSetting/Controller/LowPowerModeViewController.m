//
//  LowPowerModeViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/8.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "LowPowerModeViewController.h"

@interface LowPowerModeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,copy) NSString *uptime;

@end

@implementation LowPowerModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = NSLocalizedString(@"Tracking time interval", nil);
    cell.detailTextLabel.text = self.uptime;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"2h",@"12h",
                                  @"24h",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:{
            self.uptime = @"2h";
        }
            break;
        case 1:{
            self.uptime = @"12h";
        }
            break;
        case 2:
        {
            self.uptime = @"24h";
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
    
}

- (void)rightAction{

    if (self.uptime.length < 1) {
        return;
    }
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    
    NSString *paramValue = [NSString stringWithFormat:@"1,%ld",[self.uptime integerValue]];
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/Send?vehicleId=%@&paramIds=%@&paramValues=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId],@"73,27",paramValue];
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
            [CommonFunction showRightMessageToView:self.view text:@"OK" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

@end
