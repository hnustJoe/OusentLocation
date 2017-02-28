//
//  CardetailTableViewCell.m
//  欧深特GPS
//
//  Created by joe on 16/11/9.
//  Copyright © 2016年 OuShenTe. All rights reserved.
//

#import "CardetailTableViewCell.h"

@interface CardetailTableViewCell ()

@property (nonatomic,strong) UIView *slectedview;
@property (nonatomic,strong) UIView *unslectedview;
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *nameLable;

@end


@implementation CardetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        UIView * slectedview = [[UIView alloc]initWithFrame:CGRectMake(12, 17, 15, 15)];
        slectedview.backgroundColor = [CommonFunction mainColor];
        [self.contentView addSubview:slectedview];
        self.slectedview = slectedview;
        
        UIView * unslectedview = [[UIView alloc]initWithFrame:CGRectMake(12, 17, 15, 15)];
        unslectedview.backgroundColor = [UIColor whiteColor];
        unslectedview.layer.borderColor = [CommonFunction mainColor].CGColor;
        unslectedview.layer.borderWidth = 1;
        unslectedview.layer.masksToBounds = YES;
        [self.contentView addSubview:unslectedview];
        self.unslectedview = unslectedview;
        

        
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        icon.center = CGPointMake(unslectedview.center.x + 30, unslectedview.center.y);
        [self.contentView addSubview:icon];
        self.icon = icon;
        
        
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame), 15, 200, 20)];
        [self.contentView addSubview:nameLable];
        self.nameLable = nameLable;
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, WindowWidth, 1)];
        [self.contentView addSubview:line];
        line.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    
    self.nameLable.text = [dataDic objectForKey:@"plateNo"];
    
    if ([[dataDic objectForKey:@"online"] boolValue] == YES) {
        self.icon.image =[UIImage imageNamed:@"list_online"];
        self.nameLable.textColor = [CommonFunction mainColor];
    }else{
        self.icon.image =[UIImage imageNamed:@"list_offline"];
        self.nameLable.textColor = [UIColor lightGrayColor];
   }

    
    
    if ([[dataDic objectForKey:@"select"] boolValue] == YES) {
        self.slectedview.hidden = NO;
        self.unslectedview.hidden = YES;

    }else{
        self.slectedview.hidden = YES;
        self.unslectedview.hidden = NO;

    }

    
    
    
    
    
}
@end
