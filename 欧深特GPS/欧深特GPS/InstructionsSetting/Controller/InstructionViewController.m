//
//  InstructionViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "InstructionViewController.h"
#import "SpeedlimitSettingViewController.h"
#import "DataReportingTimeViewController.h"
#import "NomalViewController.h"
#import "TrackViewController.h"
#import "LowPowerModeViewController.h"

@interface InstructionViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSorseArr;


@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"work mode", "工作模式");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataSorseArr = [NSMutableArray array];
    [self.dataSorseArr addObject:NSLocalizedString(@"nomal mode", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"track mode", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"power saving mode", nil)];

//    [self.dataSorseArr addObject:NSLocalizedString(@"InstructionViewController_Data reporting time", "数据上报时间")];

    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSorseArr[indexPath.row];
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
            NomalViewController *vc =[[NomalViewController alloc]init];
            vc.title = NSLocalizedString(@"nomal mode", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            TrackViewController *vc =[[TrackViewController alloc]init];
            vc.title = NSLocalizedString(@"track mode", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 2:
        {
            LowPowerModeViewController *vc =[[LowPowerModeViewController alloc]init];
            vc.title = NSLocalizedString(@"power saving mode", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }

    
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:nil
//                                  delegate:self
//                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
//                                  destructiveButtonTitle:nil
//                                  otherButtonTitles:NSLocalizedString(@"nomal mode", nil), NSLocalizedString(@"track mode", nil),
//                                  NSLocalizedString(@"power saving mode", nil),nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
//    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            NomalViewController *vc =[[NomalViewController alloc]init];
            vc.title = NSLocalizedString(@"nomal mode", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            TrackViewController *vc =[[TrackViewController alloc]init];
            vc.title = NSLocalizedString(@"track mode", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 2:
        {
            LowPowerModeViewController *vc =[[LowPowerModeViewController alloc]init];
            vc.title = NSLocalizedString(@"power saving mode", nil);

            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}






@end
