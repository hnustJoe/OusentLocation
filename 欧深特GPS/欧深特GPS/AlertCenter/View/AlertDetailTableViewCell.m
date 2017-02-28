//
//  AlertDetailTableViewCell.m
//  欧深特GPS
//
//  Created by joe on 2017/1/3.
//  Copyright © 2017年 OuShenTe. All rights reserved.
//

#import "AlertDetailTableViewCell.h"


@interface AlertDetailTableViewCell ()



@end

@implementation AlertDetailTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 7, WindowWidth, 20)];
        [self.contentView addSubview:nameLable];
        self.nameLable = nameLable;
        
        UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 25, WindowWidth, 20)];
        [self.contentView addSubview:timeLable];
        self.timeLable = timeLable;
        
        
        UILabel *loactionLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 44, WindowWidth, 50)];
        [self.contentView addSubview:loactionLable];
        loactionLable.font = [UIFont systemFontOfSize:12.0];
        self.loactionLable = loactionLable;
        self.loactionLable.numberOfLines = 0;
        
    
    }
    
    return self;
}


- (void)setDataDic:(NSDictionary *)dic{
    self.nameLable.text = [dic objectForKey:@"plateNo"];
    self.timeLable.text = [dic objectForKey:@"alarmTime"];;
    self.loactionLable.text = [dic objectForKey:@"location"];
    
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:12.0] forKey:NSFontAttributeName];
    CGSize titleSize = [[dic objectForKey:@"location"] boundingRectWithSize:CGSizeMake(WindowWidth - 12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil].size;
    
    self.loactionLable.frame = CGRectMake(12, 44, WindowWidth -12, titleSize.height);

    self.rowHeight = 44 + titleSize.height;
    
}

@end
