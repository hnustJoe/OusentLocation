//
//  HelpViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/6.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "HelpViewController.h"
#import "APNlistViewController.h"

@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = NSLocalizedString(@"SettingViewController_help", "帮助");
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
}

#pragma mark uitableViewDatasourse&delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingViewControllerCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"HelpViewController_APN list", "APN列表");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.textLabel.text = NSLocalizedString(@"app version", "app版本");
        cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    
        
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.row == 0) {
//        cell.textLabel.text = NSLocalizedString(@"SettingViewController_BaseInfo", "基本信息");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else{
        APNlistViewController *vc = [[APNlistViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        cell.textLabel.text = NSLocalizedString(@"SettingViewController_BaseInfo", "基本信息");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


@end
