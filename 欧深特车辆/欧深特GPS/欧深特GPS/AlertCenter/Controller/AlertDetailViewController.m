//
//  AlertDetailViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/29.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "MJRefresh.h"


@interface AlertDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSString *startStr;
@property (nonatomic,strong) NSString *endStr;
@property (nonatomic,assign) NSInteger pageNum;


@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) MJRefreshFooterView *footerView;
@property (nonatomic,strong) MJRefreshHeaderView *headerView;



@end

@implementation AlertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    
    
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView; // 或者tableView
    footer.delegate = self;
    footer.tag = 1;
    self.footerView = footer;

    
    
    
    
    
    
    
    self.dataArr = [NSMutableArray array];
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    
    NSString *firstDateStr = [currentDateStr stringByReplacingCharactersInRange:NSMakeRange(currentDateStr.length -2, 2) withString:@"01"];
    firstDateStr = [firstDateStr stringByAppendingString:@" 00:00:00"];
    self.startStr = firstDateStr;
    
    
    NSString *endDateStr = [currentDateStr stringByReplacingCharactersInRange:NSMakeRange(currentDateStr.length -2, 2) withString:@"30"];
    endDateStr = [endDateStr stringByAppendingString:@" 00:00:00"];
    self.endStr = endDateStr;
    
    self.pageNum = 1;
    
    
    [self getAlertDetailInfo];
    
    
}

#pragma mark private
- (void)getAlertDetailInfo{
    
    NSString *urlstr = [NSString stringWithFormat:@"http://%@/MobileQuery.mvc/Paginate?queryId=selectProcessedAlarms&pageNo=%ld&pageSize=20&vehicleId=%@&alarmType=%@&startTime=%@&endTime=%@",[CommonFunction getloginIP],self.pageNum,[CommonFunction getCurrentVehicleId],self.alarmType,self.startStr,self.endStr];
    NSString* encodedString = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:15];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        [self.footerView endRefreshing];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        
        if ([dic objectForKey:@"error"]) {
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"error"] completionBlock:^{
                
            }];
            
            return ;
        }
        
        
        NSArray *rowsArr = [dic objectForKey:@"rows"];
        if (rowsArr.count > 0) {
            for (NSDictionary *rowDic in rowsArr) {
                NSString *processed = [rowDic objectForKey:@"processed"];
                NSMutableDictionary *cellDataDic = [NSMutableDictionary dictionary];
                [cellDataDic setObject:processed forKey:@"processed"];
                [cellDataDic setObject:[rowDic objectForKey:@"alarmTime"] forKey:@"alarmTime"];
                [self.dataArr addObject:cellDataDic];
            }
            
            [self.tableView reloadData];
            
        }else{
            [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"no data", "没有数据") completionBlock:^{
                
            }];
        }
        
        
        if (rowsArr.count < 20) {
            self.pageNum = 1;
            NSInteger moth = [[self.startStr substringWithRange:NSMakeRange(5, 2)] integerValue];
            NSString *mothStr = [NSString stringWithFormat:@"%ld",moth-1];
            if (mothStr.length == 1) {
                mothStr = [NSString stringWithFormat:@"0%@",mothStr];
            }
            self.startStr = [self.startStr stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:mothStr];
            self.endStr = [self.endStr stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:mothStr];
        }else{
            
            self.pageNum = self.pageNum+1;
//            NSInteger moth = [[self.startStr substringWithRange:NSMakeRange(5, 2)] integerValue];
//            NSString *mothStr = [NSString stringWithFormat:@"%ld",moth-1];
//            self.startStr = [self.startStr stringByReplacingCharactersInRange:NSMakeRange(6, 2) withString:mothStr];
//            self.endStr = [self.endStr stringByReplacingCharactersInRange:NSMakeRange(6, 2) withString:mothStr];
            
        }
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    NSString *processed = [dataDic objectForKey:@"processed"];
    NSString *alarmTime = [dataDic objectForKey:@"alarmTime"];
    
    cell.textLabel.text = alarmTime;
    cell.detailTextLabel.text = processed;
    
    return cell;
}

#pragma mark  MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self getAlertDetailInfo];
}



- (void)dealloc{
    [_footerView free];
    [_headerView free];
}


@end
