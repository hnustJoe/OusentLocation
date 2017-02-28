//
//  ProgressView.h
//  小公举
//
//  Created by Elwin on 16/6/14.
//  Copyright © 2016年 Wanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (ProgressView *)shareInstance;
- (void)showWithContent:(NSString *)content;
- (void)showWithContent:(NSString *)content time:(NSInteger)time;
- (void)removeFromKeyWindow;
@end
