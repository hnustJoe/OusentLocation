//
//  AlertDetailViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/29.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AlertDetailViewController.h"
#import "MJRefresh.h"
#import "AlertLatLonViewController.h"
#import "AlertDetailTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface AlertDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSString *startStr;
@property (nonatomic,strong) NSString *endStr;
@property (nonatomic,assign) NSInteger pageNum;


@property (nonatomic,strong) UITableView *tableView;


@property (nonatomic,strong) MJRefreshFooterView *footerView;
@property (nonatomic,strong) MJRefreshHeaderView *headerView;

@property (nonatomic, strong) CLGeocoder *geoC;

@end

@implementation AlertDetailViewController

-(CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

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
    
    
//    NSDate *date = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd";
//    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    
//    NSString *firstDateStr = [currentDateStr stringByReplacingCharactersInRange:NSMakeRange(currentDateStr.length -2, 2) withString:@"01"];
//    firstDateStr = [firstDateStr stringByAppendingString:@" 00:00:00"];
//    self.startStr = firstDateStr;
//    
//    
//    NSString *endDateStr = [currentDateStr stringByReplacingCharactersInRange:NSMakeRange(currentDateStr.length -2, 2) withString:@"30"];
//    endDateStr = [endDateStr stringByAppendingString:@" 00:00:00"];
//    self.endStr = endDateStr;
    
    
    
    
//    NSDateFormatter *format=[[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM"];
//    NSDate *newDate=[format dateFromString:currentDateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:[NSDate date]];
    endDate = [beginDate dateByAddingTimeInterval:interval-1];

    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    
    self.startStr = [beginString stringByAppendingString:@" 00:00:00"];


    self.endStr = [endString stringByAppendingString:@" 00:00:00"];

    
    
    
    self.pageNum = 1;
    
    
    [self getAlertDetailInfo];
    

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RemoteAlertNoti:) name:@"RemoteAlertNoti" object:nil];
    
    
}

- (void)RemoteAlertNoti:(NSNotification *)noti{
    
    
    NSString *type = [noti.userInfo objectForKey:@"key3"];
    NSArray *arr = [type componentsSeparatedByString:@","];
    type = [arr objectAtIndex:0];
    if ([type isEqualToString:self.alarmType]) {
        
        NSMutableDictionary *cellDataDic = [NSMutableDictionary dictionary];
        [cellDataDic setObject:[noti.userInfo objectForKey:@"key1"] forKey:@"plateNo"];
        [cellDataDic setObject:[noti.userInfo objectForKey:@"key2"] forKey:@"alarmTime"];
        [cellDataDic setObject:[arr objectAtIndex:2] forKey:@"lat"];
        [cellDataDic setObject:[arr objectAtIndex:1] forKey:@"lon"];
        
        
        
        
        double latitude = [[cellDataDic objectForKey:@"lat"] doubleValue];
        double longitude = [[cellDataDic objectForKey:@"lon"] doubleValue];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        // 反地理编码(经纬度---地址)
        [self.geoC reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(error == nil)
            {
                CLPlacemark *pl = [placemarks firstObject];
                [cellDataDic setObject:pl.name forKey:@"location"];
                [_dataArr insertObject:cellDataDic atIndex:0];
                [_tableView reloadData];
                
            }else
            {
                NSLog(@"错误");
            }
        }];
        


        
        
    }
    
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
                NSMutableDictionary *cellDataDic = [NSMutableDictionary dictionary];
                [cellDataDic setObject:[rowDic objectForKey:@"plateNo"] forKey:@"plateNo"];
                [cellDataDic setObject:[rowDic objectForKey:@"alarmTime"] forKey:@"alarmTime"];
                [cellDataDic setObject:[rowDic objectForKey:@"latitude"] forKey:@"lat"];
                [cellDataDic setObject:[rowDic objectForKey:@"longitude"] forKey:@"lon"];
                [cellDataDic setObject:[rowDic objectForKey:@"location"] forKey:@"location"];
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
    AlertDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AlertDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary *dataDic = self.dataArr[indexPath.row];

    
    [cell setDataDic:dataDic];
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    
    AlertLatLonViewController *vc = [[AlertLatLonViewController alloc]init];
    vc.time = [dataDic objectForKey:@"alarmTime"];
    vc.lon = [dataDic objectForKey:@"lon"];
    vc.lat = [dataDic objectForKey:@"lat"];
    vc.location = [dataDic objectForKey:@"location"];
    vc.name = [dataDic objectForKey:@"plateNo"];

    vc.title = self.title;
    
    [self.navigationController pushViewController:vc animated:YES];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.dataArr[indexPath.row];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName];
    
    CGSize titleSize2 = [[dataDic objectForKey:@"location"] boundingRectWithSize:CGSizeMake(WindowWidth - 12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;

    
    
    return 44 + titleSize2.height;
}

#pragma mark  MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self getAlertDetailInfo];
}



- (void)dealloc{
    [_footerView free];
    [_headerView free];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
