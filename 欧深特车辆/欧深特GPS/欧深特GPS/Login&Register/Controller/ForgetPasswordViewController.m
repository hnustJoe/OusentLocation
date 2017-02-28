//
//  ForgetPasswordViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/3.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@property (nonatomic,strong) UITextField *userNameTextField;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSString *backStr = NSLocalizedString(@"back", "返回");
    CGSize backStrSize = [backStr sizeWithFont:[UIFont systemFontOfSize:14.0]];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, backStrSize.width, backStrSize.height)];
    [self.view addSubview:backBtn];
    [backBtn setTitle:backStr forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITextField *userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(backBtn.frame) + 40, WindowWidth - 40, 44)];
    [self.view addSubview:userNameTextField];
    userNameTextField.placeholder = NSLocalizedString(@"ForgetPasswordViewController_email/username", "邮箱/用户名");
    self.userNameTextField = userNameTextField;
    
    
    
    UIView *textFieldLine = [[UIView alloc]initWithFrame:CGRectMake(userNameTextField.frame.origin.x, CGRectGetMaxY(userNameTextField.frame), userNameTextField.frame.size.width, 1)];
    textFieldLine.backgroundColor = [CommonFunction LineGrayColor];
    [self.view addSubview:textFieldLine];
    
    
    UIButton *getPassword = [[UIButton alloc]initWithFrame:CGRectMake(userNameTextField.frame.origin.x, CGRectGetMaxY(textFieldLine.frame) + 20, userNameTextField.frame.size.width, 44)];
    [getPassword setTitle:NSLocalizedString(@"ForgetPasswordViewController_getPassword", "找回密码") forState:UIControlStateNormal];
    [self.view addSubview:getPassword];
    [getPassword addTarget:self action:@selector(getPassword_clicked) forControlEvents:UIControlEventTouchUpInside];
    [getPassword setBackgroundColor:[CommonFunction mainColor]];
    
}

- (void)backBtn_clicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getPassword_clicked{
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/FindPassword?email=%@",[CommonFunction getloginIP],self.userNameTextField.text];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
                [self.userNameTextField becomeFirstResponder];
                
            }];
            
        }else{
            
            [CommonFunction showRightMessageToView:self.view text:@"OK" completionBlock:^{
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            
            
            NSLog(@"OK");
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];

    
    
}




@end
