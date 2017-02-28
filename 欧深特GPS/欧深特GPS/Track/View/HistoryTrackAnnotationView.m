//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "HistoryTrackAnnotationView.h"
#import "CustomCalloutView.h"

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  63.0

@interface HistoryTrackAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation HistoryTrackAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action



- (void)configViewdata{
    
}


- (void)updateTime{
    
    self.titleLable.text = [self convertTime];
    NSLog(@"%@fire",self.timer);
    
}


- (void)setTime:(double)time{
    _time = time;
    self.title = [self convertTime];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
}


- (NSString *)convertTime{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM-dd HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:confromTimesp];
    
    
    
    NSInteger timeInterval = ([[NSDate date]timeIntervalSince1970] - self.time)/60;
    
    switch (timeInterval) {
        case 0:
            timeStr = NSLocalizedString(@"Right Now", @"刚刚");
            break;
        case 1:
            timeStr =NSLocalizedString(@"Right Now", @"刚刚");
            break;
        case 2:
            timeStr =NSLocalizedString(@"Two Min Ago", @"两分钟之前");
            break;
        case 3:
            timeStr = NSLocalizedString(@"Three Min Ago", @"三分钟之前");
            break;
        case 4:
            timeStr = NSLocalizedString(@"Four Min Ago", @"四分钟之前");
            break;
        case 5:
            timeStr = NSLocalizedString(@"Five Min Ago", @"五分钟之前");
            break;
        default:
            break;
    }
    
    return  [NSString stringWithFormat:@"%@  %@:%dm",timeStr,NSLocalizedString(@"Accuracy", @"精度"),(int)self.radius];
    
}


- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    if (self.selected == selected)
    //    {
    //        return;
    //    }
    
    if (selected)
    {
        [self.calloutView removeFromSuperview];
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName];
        
        CGSize titleSize0 = [self.text0 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];

        CGSize titleSize1 = [self.text1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        CGSize titleSize2 = [self.text2 boundingRectWithSize:CGSizeMake(WindowWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        //            CGSize titleSize2 = [self.text2 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        CGSize titleSize3 = [self.text3 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        CGSize titleSize4 = [self.text4 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        //            CGSize titleSize5 = [self.text5 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
        //            CGSize titleSize5 = [self.text5 boundingRectWithSize:CGSizeMake(WindowWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        CGSize  titleSize5=[self.text5 sizeWithFont:[UIFont systemFontOfSize:12.0]  constrainedToSize:CGSizeMake(WindowWidth - 100, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        
        
        CGFloat maxWidth;
        maxWidth = MAX(MAX(MAX(MAX(MAX(titleSize1.width +  10, titleSize2.width +  10), titleSize3.width +  10), titleSize4.width +  10), titleSize5.width +  10), WindowWidth - 100);
        
        //            if (maxWidth > [UIScreen mainScreen].bounds.size.width - 40) {
        //                maxWidth = [UIScreen mainScreen].bounds.size.width - 40;
        //            }
        
        maxWidth = maxWidth + 50;
        /* Construct custom callout. */
        self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, maxWidth,titleSize0.height +  titleSize1.height + titleSize2.height+ titleSize3.height + titleSize4.height + titleSize5.height + 40)];
        self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                              -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        
        
        UILabel *titleLable0 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, maxWidth - 10, titleSize1.height)];
        titleLable0.font = [UIFont systemFontOfSize:12.0];
        titleLable0.backgroundColor = [UIColor clearColor];
        titleLable0.textColor = [UIColor whiteColor];
        titleLable0.text = self.text0;
        [self.calloutView addSubview:titleLable0];
        
        
        UILabel *titleLable1 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable0.frame) + 5, maxWidth - 10, titleSize1.height)];
        titleLable1.font = [UIFont systemFontOfSize:12.0];
        titleLable1.backgroundColor = [UIColor clearColor];
        titleLable1.textColor = [UIColor whiteColor];
        titleLable1.text = self.text1;
        [self.calloutView addSubview:titleLable1];
        
        UILabel *titleLable2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable1.frame) + 5, maxWidth - 10, titleSize2.height)];
        titleLable2.font = [UIFont systemFontOfSize:12.0];
        titleLable2.backgroundColor = [UIColor clearColor];
        titleLable2.textColor = [UIColor whiteColor];
        titleLable2.text = self.text2;
        titleLable2.numberOfLines = 0;
        [self.calloutView addSubview:titleLable2];
        
        UILabel *titleLable3 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable2.frame)+ 5, maxWidth - 10, titleSize3.height)];
        titleLable3.font = [UIFont systemFontOfSize:12.0];
        titleLable3.backgroundColor = [UIColor clearColor];
        titleLable3.textColor = [UIColor whiteColor];
        titleLable3.text = self.text3;
        [self.calloutView addSubview:titleLable3];
        
        UILabel *titleLable4 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable3.frame)+ 5, maxWidth - 10, titleSize4.height)];
        titleLable4.font = [UIFont systemFontOfSize:12.0];
        titleLable4.backgroundColor = [UIColor clearColor];
        titleLable4.textColor = [UIColor whiteColor];
        titleLable4.text = self.text4;
        [self.calloutView addSubview:titleLable4];
        
        UILabel *titleLable5 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLable4.frame)+ 5, maxWidth, titleSize5.height)];
        titleLable5.font = [UIFont systemFontOfSize:12.0];
        titleLable5.backgroundColor = [UIColor clearColor];
        titleLable5.textColor = [UIColor whiteColor];
        titleLable5.numberOfLines = 0;
        titleLable5.text = self.text5;
        [self.calloutView addSubview:titleLable5];
        
        [self addSubview:self.calloutView];
        
        
        
        
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    //    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 80, 80);
        
        self.backgroundColor = [UIColor clearColor];
        
        /* Create portrait image view and add to view hierarchy. */
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 22, 30, 30)];
        [self addSubview:self.imageView];
        
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeAnnotion) name:@"removeAnnotion" object:nil];
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeCallout) name:@"didSingleTapped" object:nil];
        
    }
    
    return self;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}


- (void)setOritation:(NSInteger)oritation{
    _oritation = oritation;
    self.imageView.transform = CGAffineTransformMakeRotation(kDegreesToRadian(oritation));
}

- (void)removeCallout{
    [self.calloutView removeFromSuperview];
}

- (void)removeAnnotion{
    
    if (self.timer.isValid) {
        [self.timer invalidate];
        //        self.timer = nil;
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
