//
//  ProtectSetViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/10.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ProtectSetViewController.h"
#import "ProtectSettingViewController.h"
#import "ShowCircleViewController.h"
#import "ShowrectViewController.h"
#import "ChangeProtectSetViewController.h"


@interface ProtectSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSorseArr;


@end

@implementation ProtectSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ProtectSettingViewController_ProtectSetting", "设防控制");
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClciked)];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataSorseArr = [NSMutableArray array];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileQuery.mvc/Paginate?queryId=selectBindEnclosureByVehicleId&vehicleId=%@&pageNo=1&pageSize=20",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId]];
    
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        

            self.dataSorseArr = [dic objectForKey:@"rows"];
            [self.tableView reloadData];

        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    

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
    
    
    NSDictionary *dic = self.dataSorseArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSorseArr[indexPath.row];
    
    
    ChangeProtectSetViewController *vc = [[ChangeProtectSetViewController alloc]init];
    vc.modifyDic = dic;
    [self.navigationController pushViewController:vc animated:YES];
    
    /*
    if ([[dic objectForKey:@"enclosureType"] isEqualToString:@"circle"]) {
        ShowCircleViewController *vc = [[ShowCircleViewController alloc]init];
        vc.dic =dic;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([[dic objectForKey:@"enclosureType"] isEqualToString:@"rect"]) {
        ShowrectViewController *vc = [[ShowrectViewController alloc]init];
        vc.dic =dic;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

     */

    
    

}


- (void)addClciked{
    ProtectSettingViewController *vc = [[ProtectSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
