//
//  NomalViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/8.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "NomalViewController.h"

@interface NomalViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSString *sportUpTime;
@property (nonatomic,copy) NSString *staticUpTime;


@end

@implementation NomalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"motion state data reporting time", nil);
        cell.detailTextLabel.text = self.sportUpTime;
    }else{
        cell.textLabel.text = NSLocalizedString(@"static state data reporting time", nil);
        cell.detailTextLabel.text = self.staticUpTime;
    }
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
    
    if (indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"30S",@"60S",
                                      @"120S",@"300S",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];

    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"60S",@"120S",
                                      @"300S",@"600S",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag = 2;
        [actionSheet showInView:self.view];

    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 1) {
        
        switch (buttonIndex) {
            case 0:{
                self.sportUpTime = @"30S";
            }
                break;
            case 1:{
                self.sportUpTime = @"60S";
            }
                break;
            case 2:
            {
                self.sportUpTime = @"120S";
            }
                break;
            case 3:
            {
                self.sportUpTime = @"300S";
            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (actionSheet.tag == 2) {
        
        switch (buttonIndex) {
            case 0:{
                self.staticUpTime = @"60S";
            }
                break;
            case 1:{
                self.staticUpTime = @"120S";
            }
                break;
            case 2:
            {
                self.staticUpTime = @"300S";
            }
                break;
            case 3:
            {
                self.staticUpTime = @"600S";
            }
                break;
                
            default:
                break;
        }
        
    }

    
    
    [self.tableView reloadData];
}

- (void)rightAction{
    
    if (self.staticUpTime.length < 1) {
        return;
    }

    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    
    NSString *paramValue = [NSString stringWithFormat:@"0,%ld,%ld",[self.sportUpTime integerValue],[self.staticUpTime integerValue]];
   
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileCommand.mvc/Send?vehicleId=%@&paramIds=%@&paramValues=%@",[CommonFunction getloginIP],[CommonFunction getCurrentVehicleId],@"73,27,29",paramValue];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {


        [CommonFunction removeProgress];


        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];

        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{

            }];

        }else{
            [CommonFunction showRightMessageToView:self.view text:@"OK" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];

            }];
        }




    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}

@end
