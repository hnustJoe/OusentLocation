//
//  ProtectSettingViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ProtectSettingViewController.h"
#import <MapKit/MapKit.h>
#import "ProtectModel.h"
#import "EditTitleViewController.h"
#import "CareTimeTableViewController.h"
#import "SettingAddressViewController.h"
#import "SettingAddRectViewController.h"

@interface ProtectSettingViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) ProtectModel *model;


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSorseArr;

@end

@implementation ProtectSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"add protect", "添加设防控制");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

        
    self.dataSorseArr = [NSMutableArray array];
    [self.dataSorseArr addObject:NSLocalizedString(@"title", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"time", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"type", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"location", nil)];

    
    
    self.model = [[ProtectModel alloc]init];
    NSDateFormatter *dataformatter = [[NSDateFormatter alloc]init];
    dataformatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    
    self.model.startTime  =[dataformatter stringFromDate:[NSDate date]];
    
    NSInteger endt = [[NSDate date] timeIntervalSince1970] + 60*60;
    self.model.endTime =[dataformatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:endt]];
    self.model.type = 0;
    self.model.radius = 200;
    
    
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSorseArr.count;
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
        case 2:
            cell.detailTextLabel.text = self.model.type == 0 ? NSLocalizedString(@"circle", nil) : NSLocalizedString(@"rectangle", nil);
            break;
        case 3:
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
           
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nil
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          destructiveButtonTitle:nil
                                          otherButtonTitles:NSLocalizedString(@"circle", nil), NSLocalizedString(@"rectangle", nil),nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];

        }
            break;
        case 3:{
            
            if (self.model.type == 0) {
                SettingAddressViewController *vc = [[SettingAddressViewController alloc]init];
                vc.tempCareModel = self.model;
                [self.navigationController pushViewController:vc animated:YES];

            }else{
                
                
                SettingAddRectViewController *vc = [[SettingAddRectViewController alloc]init];
                vc.tempCareModel = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
    
    }


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex < 2) {
        self.model.type = buttonIndex;
    }
    
    [self.tableView reloadData];
}


- (void)right_action{

    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    
    if (self.model.type == 0) {
        self.model.points = [NSString stringWithFormat:@"%f,%f",self.model.centerCoo.longitude,self.model.centerCoo.latitude];
    }
    
    NSString *enclosureType = self.model.type == 0 ? @"circle" : @"rect";
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/BindEnclosure?vehicleId=%@&pionts=%@&name=%@&radius=%ld&startTime=%@&endTime=%@&enclosureType=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId],self.model.points,self.model.name,self.model.radius,self.model.startTime,self.model.endTime,enclosureType];
    
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
