//
//  ChangeCircleSetViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/14.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ChangeProtectSetViewController.h"
#import "ProtectModel.h"
#import "EditTitleViewController.h"
#import "CareTimeTableViewController.h"
#import "ShowrectViewController.h"
#import "ShowCircleViewController.h"

@interface ChangeProtectSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ProtectModel *model;


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSorseArr;


@end

@implementation ChangeProtectSetViewController
- (void)setModifyDic:(NSDictionary *)modifyDic{
    _modifyDic = modifyDic;
    self.model = [[ProtectModel alloc]init];
    self.model.enclosureId = [modifyDic objectForKey:@"enclosureId"];
    self.model.name = [modifyDic objectForKey:@"name"];
    self.model.startTime = [modifyDic objectForKey:@"startDate"];
    self.model.endTime = [modifyDic objectForKey:@"endDate"];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(right_action)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"modify protect setting", "修改设防控制");
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataSorseArr = [NSMutableArray array];
    [self.dataSorseArr addObject:NSLocalizedString(@"title", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"time", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"location", nil)];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSorseArr.count;
}


- (void)right_action{
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/UpdateEnclosure?enclosureId=%@&name=%@&startTime=%@&endTime=%@",[CommonFunction getloginIP],self.model.enclosureId,self.model.name,self.model.startTime,self.model.endTime];
    
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == YES) {
            [CommonFunction showRightMessageToView:self.view text:[dic objectForKey:@"message"] completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSorseArr[indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = self.model.name;
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",self.model.startTime,self.model.endTime];
            break;
        default:
            break;
    }
    
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
    
    
    switch (indexPath.row) {
        case 0:{
            EditTitleViewController *vc = [[EditTitleViewController alloc]init];
            vc.tempCareModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 1:{
            CareTimeTableViewController *vc = [[CareTimeTableViewController alloc]init];
            vc.tempCareModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 2:{
            
            
            
             if ([[self.modifyDic objectForKey:@"enclosureType"] isEqualToString:@"circle"]) {
             ShowCircleViewController *vc = [[ShowCircleViewController alloc]init];
             vc.dic =self.modifyDic;
             [self.navigationController pushViewController:vc animated:YES];
             return;
             }
             
             if ([[self.modifyDic objectForKey:@"enclosureType"] isEqualToString:@"rect"]) {
             ShowrectViewController *vc = [[ShowrectViewController alloc]init];
             vc.dic =self.modifyDic;
             [self.navigationController pushViewController:vc animated:YES];
             return;
             }
             
            
            
        }
            break;
                default:
            break;
    }
    
}



@end
