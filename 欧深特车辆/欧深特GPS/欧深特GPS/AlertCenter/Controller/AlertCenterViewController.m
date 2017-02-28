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
    
    
    NSArray * arr = [CommonFunction getNotiArr];
    self.dataSorseArr = [NSMutableArray array];
    
    for (NSDictionary *dic in arr) {
        NSString *key = [dic allKeys][0];
        if ([[dic objectForKey:key] boolValue]) {
            [self.dataSorseArr addObject:key];
        }
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSorseArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *key = self.dataSorseArr[indexPath.section];
    NSString *name = [NSString stringWithFormat:@"AlertSwitchViewController_%@",key];
    cell.textLabel.text = NSLocalizedString(name, nil);
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
    NSString *key = self.dataSorseArr[indexPath.section];
    NSString *name = [NSString stringWithFormat:@"AlertSwitchViewController_%@",key];
    vc.title = NSLocalizedString(name, nil);
    vc.alarmType = key;
    [self.navigationController pushViewController:vc animated:YES];
}





@end
