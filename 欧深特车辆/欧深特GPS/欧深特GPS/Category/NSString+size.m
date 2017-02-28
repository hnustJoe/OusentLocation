//
//  NSString+size.m
//  小公举
//
//  Created by Elwin on 16/5/23.
//  Copyright © 2016年 Wanyu. All rights reserved.
//

#import "NSString+size.h"

@implementation NSString (size)


- (CGSize)sizeWithFont:(UIFont *)font{
    return  [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

@end
