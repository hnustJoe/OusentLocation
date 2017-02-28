//
//  AddDeviceViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/8.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "SwapDeviceViewController.h"

@interface AddDeviceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *swapBtn;

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.title = NSLocalizedString(@"add device", nil);
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(right_action)];
    
    
    [self.swapBtn setTitle:NSLocalizedString(@"swap", nil) forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(right_action)];
    
    self.imeiTextField.placeholder =NSLocalizedString(@"input the ID which on the box", nil);
    self.IDTextFied.placeholder =NSLocalizedString(@"input the SN which on the box", nil);

}
- (IBAction)swapbtn_clicked:(id)sender {
    SwapDeviceViewController *vc = [[SwapDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)right_action{
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileVehicle.mvc/BindTerminal?termNo=%@&termId=%@",[CommonFunction getloginIP],self.imeiTextField.text,self.IDTextFied.text];
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
                
                if (self.isfistADD) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"addfirstDeviceOK" object:nil];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}


- (IBAction)imeiTextField:(id)sender {
}
@end
