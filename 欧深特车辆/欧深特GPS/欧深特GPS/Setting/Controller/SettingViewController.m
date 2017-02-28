//
//  SettingViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/14.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "SettingViewController.h"

#import "BaseInfoViewController.h"
#import "ChangePasswordViewController.h"
#import "VersionInfoViewController.h"
#import "AlertSwitchViewController.h"
#import "HelpViewController.h"



@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>


@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"SettingViewController_Setting", "设置");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    
}
#pragma mark sender
- (void)alertNotiValue_changed:(UISwitch *)sender{
    if (sender.isOn) {
        NSLog(@"YES");
    }
}


#pragma mark uitableViewDatasourse&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingViewControllerCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = NSLocalizedString(@"SettingViewController_BaseInfo", "基本信息");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }break;
            case 1:{
                cell.textLabel.text = NSLocalizedString(@"SettingViewController_AlertNoti", "报警通知");
                
                UISwitch *openNotiSwitch = [[UISwitch alloc]init];
                [openNotiSwitch addTarget:self action:@selector(openNotiSwitch_valueChanged:) forControlEvents:UIControlEventValueChanged];
                NSString *notiSwitchkey = [NSString stringWithFormat:@"%@%@",alartNoti,[CommonFunction getCurrentVehicleId]];
                openNotiSwitch.on =[[[NSUserDefaults standardUserDefaults] objectForKey:notiSwitchkey] boolValue];
                openNotiSwitch.onTintColor = [CommonFunction mainColor];
                cell.accessoryView = openNotiSwitch;
            }break;
            case 2:{
                cell.textLabel.text = NSLocalizedString(@"SettingViewController_device management", "设备管理");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }break;
            
                
            default:
                break;
        }
        
        
    }else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = NSLocalizedString(@"SettingViewController_ChangePassword", "修改密码");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }break;
            case 1:{
                cell.textLabel.text = NSLocalizedString(@"SettingViewController_help", "帮助");
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }break;
            default:
                break;
        }

        
    }else{
        cell.textLabel.text = NSLocalizedString(@"SettingViewController_Logout", "退出登录");
        cell.textLabel.textColor = [CommonFunction mainColor];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                BaseInfoViewController *vc = [[BaseInfoViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case 1:{

            
            }break;
            case 2:{
                AlertSwitchViewController *vc = [[AlertSwitchViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
                
                
            default:
                break;
        }
        
        
    }else if(indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:{
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            case 1:{
                HelpViewController *vc = [[HelpViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }break;
            default:
                break;
        }
        
        
    }else{
        UIAlertView *logoutAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"SettingViewController_sure to logout?", "确认退出当前账号吗？") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"SettingViewController_cancel", "取消") otherButtonTitles:NSLocalizedString(@"SettingViewController_logout", "确认退出"), nil];
        [logoutAlertView show];
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


#pragma mark 
- (void)openNotiSwitch_valueChanged:(UISwitch *)openNotiSwitch{
    NSString *notiSwitchkey = [NSString stringWithFormat:@"%@%@",alartNoti,[CommonFunction getCurrentVehicleId]];
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:openNotiSwitch.isOn] forKey:notiSwitchkey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ManulLogoutOK" object:nil];
    }
}


@end
