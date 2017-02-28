//
//  AddDeviceViewController.h
//  欧深特GPS
//
//  Created by joe on 16/11/8.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeviceViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *imeiTextField;//ID
@property (weak, nonatomic) IBOutlet UITextField *IDTextFied;//SN
@property (nonatomic,assign) BOOL isfistADD;

@end
