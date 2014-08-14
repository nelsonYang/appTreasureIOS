//
//  NSString+Kilometer.m
//  WeiLe
//
//  Created by linger on 27/11/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "NSString+Kilometer.h"

@implementation NSString (Kilometer)

- (NSString *)castToKiloMeter
{
    if ([self intValue] < 1000)
    {
        double meter = [self doubleValue] / 100.f;
        return [NSString stringWithFormat:@"%.0f00米以内", meter];
    }
    else if([self intValue] >= 1000 && [self intValue] < 10000)
    {
        double meter = [self doubleValue] / 1000.f;
        return [NSString stringWithFormat:@"%.1f千米以内", meter];
    }
    else
    {
        double meter = [self doubleValue] / 10000.f;
        return [NSString stringWithFormat:@"%.1f万米以内", meter];
    }
}

@end
