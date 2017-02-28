//
//  BaseInfoViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/19.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "BaseInfoViewController.h"
#import "BaseInfoModel.h"

@interface BaseInfoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BaseInfoModel *baseInfoModel;

@end

@implementation BaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"BaseInfoViewController_BaseInfo", "基本信息");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(right_action)];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    
    
//    NSMutableDictionary *baseDic = [NSMutableDictionary dictionary];
//    [baseDic setObject:@"joe" forKey:@"nickName"];
//    [baseDic setObject:@"粤B99999" forKey:@"carNumber"];
//    [baseDic setObject:@"123456" forKey:@"carFrameNumber"];
//    [baseDic setObject:@"11111" forKey:@"engineNumber"];
//    [baseDic setObject:@"2016/9/5" forKey:@"insuranceDate"];
//    [baseDic setObject:@"2016/9/5" forKey:@"annualDate"];
//
//    
//    self.baseInfoModel = [[BaseInfoModel alloc]initWithDic:baseDic];
}



#pragma mark sender
- (void)right_action{
    
}


#pragma mark uitableViewDatasourse&delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return 1;
//    }else if(section == 1){
//        return 3;
//    }else{
//        return 2;
//    }
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingViewControllerCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    
    cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_nickName", "昵称");
    cell.detailTextLabel.text = self.baseInfoModel.nickName;
    
    
    
//    if (indexPath.section == 0) {
//        cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_nickName", "昵称");
//        cell.detailTextLabel.text = self.baseInfoModel.nickName;
//        
//    }else if(indexPath.section == 1){
//        
//        switch (indexPath.row) {
//            case 0:{
//                cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_CarNumber", "车牌号");
//                cell.detailTextLabel.text = self.baseInfoModel.carNumber;
//
//            }
//                break;
//            case 1:{
//                cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_CarFrameNumber", "车架号");
//                cell.detailTextLabel.text = self.baseInfoModel.carFrameNumber;
//
//            }
//                break;
//            case 2:{
//                cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_EngineNumber", "发动机");
//                cell.detailTextLabel.text = self.baseInfoModel.engineNumber;
//
//            }
//                break;
//                
//            default:
//                break;
//        }
//        
//    }else if(indexPath.section == 2){
//        
//        switch (indexPath.row) {
//            case 0:{
//                cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_insuranceDate", "保险到期");
//                cell.detailTextLabel.text = self.baseInfoModel.insuranceDate;
//                
//            }
//                break;
//            case 1:{
//                cell.textLabel.text = NSLocalizedString(@"BaseInfoViewController_AnnualDate", "年审过期");
//                cell.detailTextLabel.text = self.baseInfoModel.annualDate;
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//
//    
//    }
//    
//    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //#import "BaseInfoViewController.h"
    //#import "ChangePasswordViewController.h"
    //#import "VersionInfoViewController.h"
    
    
//    if (indexPath.section == 0) {
//        
//        switch (indexPath.row) {
//            case 0:{
//                BaseInfoViewController *vc = [[BaseInfoViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 1:{
//                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 2:{
//                
//                
//            }
//                break;
//            case 3:{
//                VersionInfoViewController *vc = [[VersionInfoViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//                
//            }break;
//                
//            default:
//                break;
//        }
//        
//        
//    }else if(indexPath.section == 1){
//        
//        
//    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 24;
}

@end
