//
//  CareTimeTableViewController.m
//  Onetalking
//
//  Created by Elwin on 15/11/25.
//  Copyright © 2015年 OneTalk. All rights reserved.
//

#import "CareTimeTableViewController.h"
#import "ZHPickView.h"

@interface CareTimeTableViewController ()<ZHPickViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CareTimeTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
//    if (self.tempCareModel.time.count == self.index ) {
//        self.startTime = [NSMutableString stringWithFormat:@"00:00"];
//        self.endTime = [NSMutableString stringWithFormat:@"23:59"];
//    }else{
//        NSDictionary *timeDic =  self.tempCareModel.time[self.index];
//        self.startTime = [timeDic objectForKey:@"start"];
//        self.endTime = [timeDic objectForKey:@"end"];
//    }

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    if (self.tempCareModel.time.count == self.index ) {
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:self.startTime forKey:@"start"];
//        [dic setObject:self.endTime forKey:@"end"];
//        [self.tempCareModel.time addObject:dic];
//    }else{
//        NSMutableDictionary *timeDic =  (NSMutableDictionary *)self.tempCareModel.time[self.index];
//        
//        NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
//        [muDic setObject:self.startTime forKey:@"start"];
//        [muDic setObject:self.endTime forKey:@"end"];
//        
//        if ([[timeDic allKeys] containsObject:@"timeId"]) {
//            [muDic setObject:[timeDic objectForKey:@"timeId"] forKey:@"timeId"];
//        }
//
//        [self.tempCareModel.time replaceObjectAtIndex:self.index withObject:muDic];
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"start time", nil);
        cell.detailTextLabel.text = self.tempCareModel.startTime;
    }else{
        cell.textLabel.text =NSLocalizedString(@"end time", nil);
        cell.detailTextLabel.text = self.tempCareModel.endTime;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self addDatePicker:indexPath.row];
}



- (void)addDatePicker:(NSInteger)row
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date;
    if (row == 0) {
        date = [dateFormatter dateFromString:self.tempCareModel.startTime];
    }else{
        date = [dateFormatter dateFromString:self.tempCareModel.endTime];
    }
    
    ZHPickView *pickView = [[ZHPickView alloc]initDatePickWithDate:date datePickerMode:UIDatePickerModeDateAndTime isHaveNavControler:NO];
    pickView.tag = row;
    [pickView show];
    pickView.delegate = self;
}

#pragma mark ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%@",[dateFormatter stringFromDate:pickView.datePicker.date]];
    NSString *preStr =  [timeStr substringToIndex:2];
    if ([preStr isEqualToString:@"12"]) {
        preStr = [NSString stringWithFormat:@"00"];
        [timeStr replaceCharactersInRange:NSMakeRange(0, 2) withString:preStr];
    }else if([preStr isEqualToString:@"00"]){
        preStr = [NSString stringWithFormat:@"12"];
        [timeStr replaceCharactersInRange:NSMakeRange(0, 2) withString:preStr];
    }
    
    
    
    if (pickView.tag == 0) {
        self.tempCareModel.startTime =timeStr ;
    }else{
        self.tempCareModel.endTime = timeStr;
    }
    
    [self.tableView reloadData];
}


@end
