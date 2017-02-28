//
//  LoginViewController.m
//  欧深特GPS
//
//  Created by joe on 16/9/19.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "LoginViewController.h"
#import "SelectionCell.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITextField *nickNameTextField;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *openBtn;
@property (nonatomic,strong) UIButton *serverBtn;
@property (nonatomic,strong) UIView *maskView;
@property (strong, nonatomic) UITableView *tb;


@property (nonatomic,strong) NSArray *serverArr;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isOpened = NO;
    
    
    [self setupView];
    
    
    
//    http://219.138.163.110/webgis/
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://219.138.163.110/webgis/MobileIpAddress.mvc/GetGpsServerIP"];
    NSMutableURLRequest *urlQuest = [[NSMutableURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSArray *Arr = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        self.serverArr =Arr;
        [self.tb reloadData];
        NSDictionary *serverDic = self.serverArr[0];
        [self.serverBtn setTitle:[serverDic objectForKey:@"ip"]forState:UIControlStateNormal];

        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
    
    
    self.nickNameTextField.text = [CommonFunction getCurrentUsername];
    self.passwordTextField.text = [CommonFunction getCurrentPassword];
    
    
    
    
    
}


- (void)openBtn_clicked:(UIButton *)sender{
    
    
    
    [self.view endEditing:YES];
    
    
    if (isOpened) {
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *closeImage=[UIImage imageNamed:@"login_fold_normal"];
            [_openBtn setImage:closeImage forState:UIControlStateNormal];
            
            CGRect frame=_tb.frame;
            
            frame.size.height=0;
            [_tb setFrame:frame];
            
        } completion:^(BOOL finished){
            
            isOpened=NO;
            self.maskView.hidden = YES;

        }];
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            UIImage *openImage=[UIImage imageNamed:@"login_fold_pressed"];
            [_openBtn setImage:openImage forState:UIControlStateNormal];
            
            CGRect frame=self.tb.frame;
            
            frame.size.height=WindowHeight -CGRectGetMaxY(self.serverBtn.frame);
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            
            isOpened=YES;
            self.maskView.hidden = NO;

        }];
        
        
    }
}

- (void)setupView{
    
    UITextField *nickNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(12, 200 * 667.0/WindowHeight, WindowWidth - 24, 40)];
    nickNameTextField.placeholder = NSLocalizedString(@"LoginViewController_userName", "用户名");
    nickNameTextField.font = [CommonFunction MediumFont];
    [self.view addSubview:nickNameTextField];
    self.nickNameTextField = nickNameTextField;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 39, WindowWidth - 24, 1)];
    line.backgroundColor =[CommonFunction LineGrayColor];
    [nickNameTextField addSubview:line];
    
    
    
    
    
    UITextField *passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(nickNameTextField.frame.origin.x, CGRectGetMaxY(nickNameTextField.frame), WindowWidth - 24, 40)];
    passwordTextField.placeholder = NSLocalizedString(@"LoginViewController_password", "密码");
    passwordTextField.font = [CommonFunction MediumFont];
    passwordTextField.secureTextEntry = YES;
    [self.view addSubview:passwordTextField];
    self.passwordTextField = passwordTextField;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, WindowWidth - 24, 1)];
    line1.backgroundColor =[CommonFunction LineGrayColor];
    [passwordTextField addSubview:line1];
    
    
    
    
    UIButton *serverBtn = [[UIButton alloc]initWithFrame:CGRectMake(nickNameTextField.frame.origin.x, CGRectGetMaxY(passwordTextField.frame), WindowWidth - 24, 40)];
    [serverBtn setTitle:NSLocalizedString(@"LoginViewController_server option", "服务器选项") forState:UIControlStateNormal];
    [serverBtn setTitleColor:[CommonFunction grayTextFont1] forState:UIControlStateNormal];
    [serverBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.view addSubview:serverBtn];
    self.serverBtn = serverBtn;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, WindowWidth - 24, 1)];
    line2.backgroundColor =[CommonFunction LineGrayColor];
    [serverBtn addSubview:line2];
    
    
    CGFloat openBtnWidth = 40;
    UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(serverBtn.frame.size.width - openBtnWidth, 0, openBtnWidth, openBtnWidth)];
    [openBtn setImage:[UIImage imageNamed:@"login_fold_normal"] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [serverBtn addSubview:openBtn];
    self.openBtn = openBtn;
    
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(nickNameTextField.frame.origin.x, CGRectGetMaxY(serverBtn.frame) + 20, WindowWidth - 24, 40)];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    self.loginBtn.backgroundColor = [CommonFunction mainColor];
    [self.loginBtn setTitle:NSLocalizedString(@"LoginViewController_login", "登录") forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtn_clicked:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 3;
    
    
    CGSize registerBtnSize = [NSLocalizedString(@"LoginViewController_register", "注册") sizeWithFont:[CommonFunction MediumFont]];
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(loginBtn.frame.origin.x, CGRectGetMaxY(loginBtn.frame) + 10, registerBtnSize.width, registerBtnSize.height)];
    [registerBtn setTitle:NSLocalizedString(@"LoginViewController_register", "注册") forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [CommonFunction MediumFont];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:registerBtn];
    [registerBtn addTarget:self action:@selector(registerBtn_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGSize forgetPasswordSize = [NSLocalizedString(@"LoginViewController_forgetPassword", "注册") sizeWithFont:[CommonFunction MediumFont]];
    UIButton *forgetPasswordBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(loginBtn.frame) - forgetPasswordSize.width, CGRectGetMaxY(loginBtn.frame) + 10, forgetPasswordSize.width, forgetPasswordSize.height)];
    [forgetPasswordBtn setTitle:NSLocalizedString(@"LoginViewController_forgetPassword", "忘记密码") forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    forgetPasswordBtn.titleLabel.font = [CommonFunction MediumFont];
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn addTarget:self action:@selector(forgetPassword_clicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *maskView = [[UIView alloc]initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.hidden = YES;
    [self.view addSubview:maskView];
    self.maskView = maskView;
    
    UITapGestureRecognizer *maskTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskView_tap)];
    [maskView addGestureRecognizer:maskTapGes];
    
    
    self.tb = [[UITableView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(serverBtn.frame), WindowWidth - 24, 0) style:UITableViewStylePlain];
    [self.view addSubview:self.tb];
    self.tb.dataSource =self;
    self.tb.delegate = self;
    [_tb.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tb.layer setBorderWidth:1];

    
}


- (void)maskView_tap{
    [UIView animateWithDuration:0.3 animations:^{
        UIImage *closeImage=[UIImage imageNamed:@"login_fold_normal"];
        [_openBtn setImage:closeImage forState:UIControlStateNormal];
        
        CGRect frame=_tb.frame;
        
        frame.size.height=0;
        [_tb setFrame:frame];
        
    } completion:^(BOOL finished){
        
        isOpened=NO;
        self.maskView.hidden = YES;
    }];
    
}


- (void)registerBtn_clicked{
    RegisterViewController *vc = [[RegisterViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)forgetPassword_clicked{
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc]init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)loginBtn_clicked:(UIButton *)sender{
    
    
    [CommonFunction showProgressMessage:NSLocalizedString(@"loading", "正在加载...") time:15];
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileHome.mvc/Login?username=%@&password=%@",self.serverBtn.titleLabel.text,self.nickNameTextField.text,self.passwordTextField.text];
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
            
            
            NSLog(@"手动登录成功");
            
            [CommonFunction saveCurrentPassword:self.passwordTextField.text];
            [CommonFunction saveCurrentUserName:self.nickNameTextField.text];
            [CommonFunction saveloginIP:self.serverBtn.titleLabel.text];

            [CommonFunction saveCurrentVehicleId:nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ManualLoginOK" object:nil userInfo:dic];
        
            [self uploadDeviceTokenWithId:[[dic objectForKey:@"data"] objectForKey:@"id"]];
            
            
        }
        
    

        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
       
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
}


- (void)uploadDeviceTokenWithId:(NSString *)userId{
    
    
    NSString *str = [NSString stringWithFormat:@"http://%@/MobileUser.mvc/SubmitDeviceToKen?deviceTokenId=%@&userId=%@",self.serverBtn.titleLabel.text,[[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"],userId];
//    NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *urlQuest = [[NSURLRequest alloc]initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:urlQuest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        [CommonFunction removeProgress];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] boolValue] == NO) {
            
        }else{
            
            
            NSLog(@"上传token成功");
            
            
            
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        [CommonFunction showWrongMessagewithtext:[NSString stringWithFormat:@"%@",error] completionBlock:^{
            
        }];
        
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:operation];
    
    
}





#pragma mark uitablview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.serverArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSDictionary *serverDic = self.serverArr[indexPath.row];
    [cell.lb setText:[serverDic objectForKey:@"name"]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *serverDic = self.serverArr[indexPath.row];
    [self.serverBtn setTitle:[serverDic objectForKey:@"ip"]forState:UIControlStateNormal];

    
    [[NSUserDefaults standardUserDefaults]setObject:[serverDic objectForKey:@"ip"] forKey:@"ip"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.openBtn sendActionsForControlEvents:UIControlEventTouchUpInside];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return 44;
    }
    return 0;
}

@end
