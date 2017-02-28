//
//  ProgressView.m
//  小公举
//
//  Created by Elwin on 16/6/14.
//  Copyright © 2016年 Wanyu. All rights reserved.
//

#import "ProgressView.h"
#import "NSString+size.h"

@interface ProgressView ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation ProgressView


+ (ProgressView *)shareInstance
{
    static ProgressView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ProgressView alloc]init];
    });
    return shareInstance;
}
    

- (void)showWithContent:(NSString *)content{
    [self showWithContent:content time:8];
}

- (void)showWithContent:(NSString *)content time:(NSInteger)time{
    CGSize textSize = [content sizeWithFont:[CommonFunction MediumFont]];
    if (content && ![content isEqualToString:@""]) {
        self.btn.frame = CGRectMake(0, 0, textSize.width + 20, textSize.height + 10);
        self.btn.center = CGPointMake(self.center.x, CGRectGetMaxY(self.imageView.frame) + spaceWidth + textSize.height/2);
        [self.btn setTitle:content forState:UIControlStateNormal];
    }else{
        self.btn.frame = CGRectNull;
    }
    [self.imageView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(remove) userInfo:nil repeats:NO];
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    
    
}

- (void)remove{
    [_timer invalidate];
    _timer = nil;
    CGSize textSize = [NSLocalizedString(@"Retry", "请重试") sizeWithFont:[CommonFunction MediumFont]];
    self.btn.frame = CGRectMake(0, 0, textSize.width + 20, textSize.height + 10);
    self.btn.center = CGPointMake(self.center.x, CGRectGetMaxY(self.imageView.frame) + spaceWidth + textSize.height/2);
    [self.btn setTitle:NSLocalizedString(@"Retry", "请重试") forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView stopAnimating];
        [self removeFromSuperview];
    });
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, WindowWidth, WindowHeight);
        UIView *view2 = [[UIView alloc]initWithFrame:self.bounds];
        view2.backgroundColor = [UIColor blackColor];
        view2.alpha = 0.5;
        [self addSubview:view2];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
        imageView.center = self.center;
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 1; i < 13; i ++) {
            NSString *imageName =[NSString stringWithFormat:@"progress_%d",i];
            [imageArr addObject:[UIImage imageNamed:imageName]];
        }
        imageView.animationImages =imageArr;
        imageView.animationDuration = 1;
        [self addSubview:imageView];
        self.imageView = imageView;
        

        UIButton *btn = [[UIButton alloc]init];
        btn.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [CommonFunction MediumFont];
        btn.backgroundColor = [UIColor colorWithRed:204/255.0 green:227/255.0 blue:255/255.0 alpha:1];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[CommonFunction blackTextFont1] forState:UIControlStateNormal];
        self.btn = btn;
        [self addSubview:btn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)reco{
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}

- (void)removeFromKeyWindow{
    [_timer invalidate];
    _timer = nil;
    [self removeFromSuperview];
}

@end
