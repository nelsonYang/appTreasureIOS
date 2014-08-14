//
//  NSString+DateFormat.m
//  WeiLe
//
//  Created by linger on 21/08/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "NSString+DateFormat.h"

@implementation NSString (DateFormat)

- (NSString *)dateFormat:(NSString *)currentFormate 
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:currentFormate];
    
    NSDate *changeDate= [dateFormatter dateFromString:self];
    NSDate *currentDate = [NSDate date];
    
    double changeTimes = (double)[changeDate timeIntervalSince1970];
    double currentTimes = (double)[currentDate timeIntervalSince1970];
    
    if ((currentTimes - changeTimes)  < 60) {
        return @"刚刚";
    }
    else if ((currentTimes - changeTimes)  / 60  < 60)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int) (currentTimes - changeTimes)  / 60];
    }
    else if ((currentTimes - changeTimes)  / 60 / 60  < 24)
    {
        return [NSString stringWithFormat:@"%d小时前",(int) (currentTimes - changeTimes)  / 60 / 60];
    }
    else if ((currentTimes - changeTimes)  / 60 / 60 / 24 < 30)
    {
        return [NSString stringWithFormat:@"%d天前",(int) (currentTimes - changeTimes)  / 60 / 60 / 24];
    }
    else 
    {
        return self;
    }
}

- (NSDate*)convertDateFromString:(NSString*)formate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:formate];
    NSDate *date=[formatter dateFromString:self];
    return date;
}

@end
