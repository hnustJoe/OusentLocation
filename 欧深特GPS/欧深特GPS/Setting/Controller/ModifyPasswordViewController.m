//
//  ModifyPasswordViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/6.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pass1;
@property (weak, nonatomic) IBOutlet UITextField *pass2;
@property (weak, nonatomic) IBOutlet UITextField *pass3;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UILabel *oldLable1;
@property (weak, nonatomic) IBOutlet UILabel *odllable2;
@property (weak, nonatomic) IBOutlet UILabel *lable3;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"ChangePasswordViewController_ChangePassword", "修改密码");
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    self.oldLable1.text = NSLocalizedString(@"ModifyPasswordViewController_old password", "旧密码");
    self.odllable2.text = NSLocalizedString(@"ModifyPasswordViewController_new password", "新密码");
     self.lable3.text = NSLocalizedString(@"ModifyPasswordViewController_ensure password", "确认密码");
    
    
    self.pass1.placeholder = NSLocalizedString(@"ModifyPasswordViewController_placeholder", "6-16个字符，区分大小写");
    self.pass2.placeholder = NSLocalizedString(@"ModifyPasswordViewController_placeholder", "6-16个字符，区分大小写");
    self.pass3.placeholder = NSLocalizedString(@"ModifyPasswordViewController_placeholder", "6-16个字符，区分大小写");
    [self.ensureBtn setTitle:NSLocalizedString(@"Confirm", "确定") forState:UIControlStateNormal];

    self.ensureBtn.backgroundColor = [CommonFunction mainColor];
    self.ensureBtn.layer.cornerRadius = 4;
    self.ensureBtn.layer.masksToBounds = YES;
    [self.ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (IBAction)ensureBtn_clicked:(id)sender {
    if (self.pass1.text.length == 0 ) {
        [self.pass1 becomeFirstResponder];
        return;
    }
    
    if (self.pass2.text.length == 0 || self.pass2.text.length < 6) {
        [self.pass2 becomeFirstResponder];
        return;
    }
    
    if (self.pass3.text.length == 0 || self.pass3.text.length < 6) {
        [self.pass3 becomeFirstResponder];
        return;
    }
    
    if (![self.pass2.text isEqualToString:self.pass3.text]) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"ModifyPasswordViewController two passwords are different", "两次密码不相同") completionBlock:^{
            self.pass2.text = nil;
            self.pass3.text = nil;
            [self.pass2 becomeFirstResponder];
            
           
        }];
        return ;
    }
    
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:8];
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileUser.mvc/UpdatePassword?oldPsd=%@&newPsd=%@",[CommonFunction getloginIP],self.pass1.text,self.pass2.text];
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
