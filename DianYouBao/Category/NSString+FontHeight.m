//
//  NSString+FontHeight.m
//  WeiLe
//
//  Created by linger on 10/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "NSString+FontHeight.h"

@implementation NSString (FontHeight)

- (float)getFontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [self sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return sizeToFit.height;
}

- (float)getHeightWithFont:(UIFont *)font andWidth:(float)width
{
    CGSize stringSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize.height;
}

@end
