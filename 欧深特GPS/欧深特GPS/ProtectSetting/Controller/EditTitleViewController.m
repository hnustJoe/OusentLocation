//
//  EditTitleViewController.m
//  Onetalking
//
//  Created by Elwin on 15/11/26.
//  Copyright © 2015年 OneTalk. All rights reserved.
//

#import "EditTitleViewController.h"

@interface EditTitleViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation EditTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleTextField becomeFirstResponder];
    self.titleTextField.delegate = self;
    self.titleTextField.returnKeyType = UIReturnKeyDone;
    self.titleTextField.text  = self.tempCareModel.name;
    self.titleTextField.placeholder = NSLocalizedString(@"title", nil);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tempCareModel.name = self.titleTextField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
