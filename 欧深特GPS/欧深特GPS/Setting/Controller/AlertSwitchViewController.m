//
//  AlertSwitchViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/28.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AlertSwitchViewController.h"

@interface AlertSwitchViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation AlertSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"SettingViewController_AlertNoti", "报警通知");

    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    self.dataArr = [NSMutableArray arrayWithArray:[CommonFunction getNotiArr]];

    
    
}



#pragma mark uiatbleViewDelegate&dataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *key = [dic allKeys][0];
    NSString *name = [NSString stringWithFormat:@"AlertSwitchViewController_%@",key];
    cell.textLabel.text = NSLocalizedString(name, nil);

    
    UISwitch *switchView = [[UISwitch alloc]init];
    cell.accessoryView = switchView;
    switchView.onTintColor = [CommonFunction mainColor];
    switchView.tag = indexPath.row;
    [switchView addTarget:self action:@selector(switchViewchanged:) forControlEvents:UIControlEventValueChanged];
    if ([[dic objectForKey:key] boolValue]) {
        switchView.on = YES;
    }else{
        switchView.on = NO;
    }
    
    return cell;
        
}

- (void)switchViewchanged:(UISwitch *)sender{
    
    
    NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArr[sender.tag]];
    NSString *name = [dic allKeys][0];

    [dic setValue:[NSNumber numberWithBool:sender.isOn] forKey:name];
    [self.dataArr replaceObjectAtIndex:sender.tag withObject:dic];
    
    [CommonFunction saveNotiArr:self.dataArr];
    
    
}


@end
