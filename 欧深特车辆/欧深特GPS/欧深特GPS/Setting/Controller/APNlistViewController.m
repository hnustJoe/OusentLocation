//
//  APNlistViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/6.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "APNlistViewController.h"
#import "APNSencondViewController.h"


@interface APNlistViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourseArr;


@end

@implementation APNlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    self.title = NSLocalizedString(@"SettingViewController_help", "帮助");
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    self.dataSourseArr = [NSMutableArray array];
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileQuery.mvc/Paginate?queryId=selectBasicData&pageNo=0&pageSize=300&parent=ApnCompany",[CommonFunction getloginIP]];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        self.dataSourseArr = [dic objectForKey:@"rows"];
        [self.tableView reloadData];
                        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];

    
    
    
}


#pragma mark uitableViewDatasourse&delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourseArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"SettingViewControllerCell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    
    NSDictionary *dic = self.dataSourseArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.dataSourseArr[indexPath.row];
    
    APNSencondViewController *vc = [[APNSencondViewController alloc]init];
    vc.code = [dic objectForKey:@"code"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}




@end
