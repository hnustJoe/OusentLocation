//
//  DataReportingTimeViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/29.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "DataReportingTimeViewController.h"

@interface DataReportingTimeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) NSInteger selectIndex;


@end

@implementation DataReportingTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"InstructionViewController_Data reporting time", "数据上报时间");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArr = @[@"30",@"60",@"300",@"600"];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    if ([CommonFunction getDataReportingTime]) {
        NSString *SpeedlimitSetting = [CommonFunction getDataReportingTime];
        
        for (int i = 0; i < self.dataArr.count; i ++) {
            NSString *time = self.dataArr[i];
            if ([time isEqualToString:SpeedlimitSetting]) {
                self.selectIndex = i;
                break;
            }
        }
        
    }else{
        [CommonFunction saveDataReportingTime:@"60"];
        self.selectIndex = 3;
    }


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    
    
    NSString *time = self.dataArr[indexPath.row];
    
    if ([time isEqualToString:@"30"]) {
        cell.textLabel.text = @"30s";
    }else if([time isEqualToString:@"60"]){
        cell.textLabel.text = @"1min";

    }else if([time isEqualToString:@"300"]){
        cell.textLabel.text = @"5min";
        
    }else if([time isEqualToString:@"600"]){
        cell.textLabel.text = @"10min";
        
    }
    
    if (indexPath.row == self.selectIndex){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
    //    [self backAction];
    NSString *value = [self.dataArr objectAtIndex:indexPath.row];

    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:10];
    
    NSString *urlstr = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/Send?vehicleId=%@&paramId=%@&paramValue=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId],@"0x0001",value];
    NSString* encodedString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [CommonFunction removeProgress];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            NSLog(@"设置成功");
            [CommonFunction saveDataReportingTime:value];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [CommonFunction removeProgress];
        
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}


@end
