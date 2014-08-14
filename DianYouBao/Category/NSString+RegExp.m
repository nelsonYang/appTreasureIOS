//
//  NSString+RegExp.m
//  精播IM
//
//  Created by linger on 07/06/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "NSString+RegExp.h"

@implementation NSString (RegExp)

- (BOOL)isPhoneNumber
{
    NSString *phoneNumRegExp = @"^(13|14|15|18|19)\\d{9}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isPureNumber
{
    NSString *pureNumberRegExp = @"^[0-9]*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pureNumberRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isPureCharacter
{
    NSString *pureCharacterRegExp = @"^[A-Za-z]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pureCharacterRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isMiddleStronger
{
    NSString *middleRegExp = @"^[A-Za-z0-9]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", middleRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isMostStronger
{
    NSString *mostRegExp = @"/[0-9a-zA-Z^$.*+ -?=!|\()[]{}/";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isFaceExp
{   
    NSString *mostRegExp = @"f[0-9]{3,}+";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isFloatVaule
{
    NSString *mostRegExp = @"^[1-9]d*.d*|0.d*[1-9]d*$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isUpcasecharacter
{
    NSString *mostRegExp = @"^[A-Z]+$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isQQEmail
{
    NSString *mostRegExp = @"^[0-9_-]+@qq.com$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mostRegExp];
    return [test evaluateWithObject:self];
}

@end

