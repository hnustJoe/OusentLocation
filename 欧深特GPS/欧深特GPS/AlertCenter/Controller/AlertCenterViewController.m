//
//  AlertCenterViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/13.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AlertCenterViewController.h"
#import "AlertDetailViewController.h"

@interface AlertCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataSorseArr;

@end

@implementation AlertCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"AlertCenterViewController_AlertCenter", "报警中心");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    self.dataSorseArr = [NSMutableArray array];
    
    
    [self.dataSorseArr addObject:NSLocalizedString(@"Electronic fence alarm", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"Low voltage alarm", nil)];
    [self.dataSorseArr addObject:NSLocalizedString(@"Fall alarm", nil)];

    
    
    
//    for (NSDictionary *dic in arr) {
//        NSString *key = [dic allKeys][0];
//        if ([[dic objectForKey:key] boolValue]) {
//            [self.dataSorseArr addObject:key];
//        }
//    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSorseArr.count;
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
    
    AlertDetailViewController *vc = [[AlertDetailViewController alloc]init];
    vc.title = self.dataSorseArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];

    
    switch (indexPath.row) {
        case 0:{
            vc.alarmType = @"CrossBorder";

        }
            break;
        case 1:{
            vc.alarmType = @"7";

        }
            break;
        case 2:{
            vc.alarmType = @"30";
        }
            break;
        default:
            break;
    }
    
    }





@end
