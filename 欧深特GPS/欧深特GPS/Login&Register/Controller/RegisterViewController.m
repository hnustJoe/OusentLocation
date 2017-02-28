//
//  RegisterViewController.m
//  欧深特GPS
//
//  Created by joe on 16/11/3.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField* usernameTextField;
@property (nonatomic,strong) UITextField* emailTextField;
@property (nonatomic,strong) UITextField* ensureCodeTextField;
@property (nonatomic,strong) UITextField* phoneTextField;
@property (nonatomic,strong) UITextField* passwordTextField;
@property (nonatomic,strong) UITextField* secondPasswordTextField;

@property (nonatomic,copy) NSString *testCode;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *backStr = NSLocalizedString(@"back", "返回");
    CGSize backStrSize = [backStr sizeWithFont:[UIFont systemFontOfSize:14.0]];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, backStrSize.width + 20, backStrSize.height + 20)];
    [self.view addSubview:backBtn];
    [backBtn setTitle:backStr forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGFloat x = 20;
    
    UITextField *usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(backBtn.frame) + 40, WindowWidth - 40, 44)];
    usernameTextField.placeholder = NSLocalizedString(@"RegisterViewController_username", "username");
    [self.view addSubview:usernameTextField];
    usernameTextField.delegate = self;
    
    
    UIView *lineusername = [[UIView alloc]initWithFrame:CGRectMake(0, 43, usernameTextField.frame.size.width, 1)];
    lineusername.backgroundColor = [CommonFunction LineGrayColor];
    [usernameTextField addSubview:lineusername];
    self.usernameTextField = usernameTextField;
    
    
    
    
    UITextField *emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(usernameTextField.frame), WindowWidth - 40, 44)];
    emailTextField.placeholder = NSLocalizedString(@"RegisterViewController_email", "email");
    [self.view addSubview:emailTextField];
    emailTextField.delegate = self;
    
    UIView *lineemail = [[UIView alloc]initWithFrame:CGRectMake(0, 43, emailTextField.frame.size.width, 1)];
    lineemail.backgroundColor = [CommonFunction LineGrayColor];
    [emailTextField addSubview:lineemail];
    self.emailTextField = emailTextField;
    
    
    NSString *testCode = NSLocalizedString(@"RegisterViewController_testCode", "验证码");
    CGSize testCodeSize = [testCode sizeWithFont:[CommonFunction MediumFont]];
    UIButton *testCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(emailTextField.frame) - testCodeSize.width, emailTextField.frame.origin.y, testCodeSize.width + 10, emailTextField.frame.size.height)];
    [self.view addSubview:testCodeBtn];
    [testCodeBtn setTitle:testCode forState:UIControlStateNormal];
    testCodeBtn.titleLabel.font = [CommonFunction MediumFont];
    [testCodeBtn setTitleColor:[CommonFunction mainColor] forState:UIControlStateNormal];
    [testCodeBtn addTarget:self action:@selector(testCodeBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    testCodeBtn.layer.cornerRadius = 2;
    testCodeBtn.layer.borderColor = [CommonFunction mainColor].CGColor;
    testCodeBtn.layer.borderWidth = 1;
    testCodeBtn.layer.masksToBounds = YES;
    
    
    
    UITextField *ensureCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(emailTextField.frame), WindowWidth - 40, 44)];
    ensureCodeTextField.placeholder = NSLocalizedString(@"RegisterViewController_testCode", "验证码");
    [self.view addSubview:ensureCodeTextField];
    
    UIView *lineensureCode = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ensureCodeTextField.frame.size.width, 1)];
    lineensureCode.backgroundColor = [CommonFunction LineGrayColor];
    [ensureCodeTextField addSubview:lineensureCode];
    self.ensureCodeTextField = ensureCodeTextField;
    
    
    UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(ensureCodeTextField.frame), WindowWidth - 40, 44)];
    phoneTextField.placeholder = NSLocalizedString(@"RegisterViewController_phone", "phone");
    [self.view addSubview:phoneTextField];
    
    UIView *linephone = [[UIView alloc]initWithFrame:CGRectMake(0, 43, phoneTextField.frame.size.width, 1)];
    linephone.backgroundColor = [CommonFunction LineGrayColor];
    [phoneTextField addSubview:linephone];
    self.phoneTextField = phoneTextField;
    
    
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(phoneTextField.frame), WindowWidth - 40, 44)];
    passwordTextField.placeholder = NSLocalizedString(@"RegisterViewController_password", "password");
    [self.view addSubview:passwordTextField];
    
    UIView *linepassword = [[UIView alloc]initWithFrame:CGRectMake(0, 43, passwordTextField.frame.size.width, 1)];
    linepassword.backgroundColor = [CommonFunction LineGrayColor];
    [passwordTextField addSubview:linepassword];
    self.passwordTextField = passwordTextField;

    
    UITextField *secondPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(passwordTextField.frame), WindowWidth - 40, 44)];
    secondPasswordTextField.placeholder = NSLocalizedString(@"RegisterViewController_secondPassword", "secondPassword");
    [self.view addSubview:secondPasswordTextField];
    
    UIView *linesecondPassword = [[UIView alloc]initWithFrame:CGRectMake(0, 43, secondPasswordTextField.frame.size.width, 1)];
    linesecondPassword.backgroundColor = [CommonFunction LineGrayColor];
    [secondPasswordTextField addSubview:linesecondPassword];
    self.secondPasswordTextField = secondPasswordTextField;
    
    
    
    UIButton *ensureBtn = [[UIButton alloc]initWithFrame:CGRectMake(secondPasswordTextField.frame.origin.x, CGRectGetMaxY(secondPasswordTextField.frame) + 20, WindowWidth - 40, 44)];
    [self.view addSubview:ensureBtn];
    ensureBtn.backgroundColor = [CommonFunction mainColor];
    [ensureBtn setTitle:NSLocalizedString(@"Confirm", "确认") forState:UIControlStateNormal];
    [ensureBtn addTarget:self action:@selector(ensureBtn_clicked) forControlEvents:UIControlEventTouchUpInside];

    
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    titleLable.font = [UIFont systemFontOfSize:14.0];
    titleLable.center =  CGPointMake(WindowWidth / 2.0, 30 + 6);
    titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLable];
    titleLable.text = NSLocalizedString(@"login", "登录");
}


//注册按钮
- (void)ensureBtn_clicked{
    
    
    if (!self.testCode || ![self.testCode isEqualToString:self.ensureCodeTextField.text]) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"wrong testcode", nil) completionBlock:^{
        }];
        return;
    }
    
    
    if (![self.passwordTextField.text isEqualToString:self.secondPasswordTextField.text]) {
        [CommonFunction showWrongMessagewithtext:NSLocalizedString(@"password unpaird", nil) completionBlock:^{
        }];
        
        return;

    }
    
    
    //////**********注册小逻辑先不管
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/AddUserInfo?loginName=%@&email=%@&mobile=%@&password=%@",[CommonFunction getloginIP],self.usernameTextField.text,self.emailTextField.text,self.phoneTextField.text,self.passwordTextField.text];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
                [self.usernameTextField becomeFirstResponder];
                
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

#pragma UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    if ([textField isEqual:self.usernameTextField]) {
//        
//        NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/IsloginName?loginName=%@",[CommonFunction getloginIP],self.usernameTextField.text];
//        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:encodedString];
//        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
//            if ([[dic objectForKey:@"success"] boolValue] == NO) {
//                
//                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
//                    
//                    [self.usernameTextField becomeFirstResponder];
//                    
//                }];
//                
//            }else{
//                
//                
//                NSLog(@"OK");
//                
//            }
//            
//        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//        }];
//        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//        [queue addOperation:operation];
//    }
//    
//    if ([textField isEqual:self.emailTextField]) {
//        
//        NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/IsEffectEmail?email=%@",[CommonFunction getloginIP],self.emailTextField.text];
//        NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSURL *url = [NSURL URLWithString:encodedString];
//        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
//        
////        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/MobileHome.mvc/IsEffectEmail?email=%@",[CommonFunction getloginIP],self.emailTextField.text]];
////        NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
//            if ([[dic objectForKey:@"success"] boolValue] == NO) {
//                NSLog(@"用户名不唯一");
//                
//                [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
//
//                    [self.emailTextField becomeFirstResponder];
//                }];
//                
//            }else{
//                
//                
//                NSLog(@"OK");
//                
//            }
//            
//        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
//        }];
//        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
//        [queue addOperation:operation];
//    }
//    
    
}


- (void)backBtn_clicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)testCodeBtn_clicked{
    
    [self.view resignFirstResponder];
    
    
    self.testCode = [NSString stringWithFormat:@"%u",arc4random() % 10000];
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", nil) time:5];
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/SendEmailCode?email=%@&code=%@",[CommonFunction getloginIP],self.emailTextField.text,self.testCode];
    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        [CommonFunction removeProgress];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            
            [CommonFunction showWrongMessagewithtext:[dic objectForKey:@"message"] completionBlock:^{
                
                [self.emailTextField becomeFirstResponder];
            }];
            
        }else{
            
            
            NSLog(@"OK");
            
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
