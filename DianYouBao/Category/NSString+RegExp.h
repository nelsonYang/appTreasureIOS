//
//  NSString+RegExp.h
//  精播IM
//
//  Created by linger on 07/06/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegExp)

- (BOOL)isPhoneNumber;
- (BOOL)isPureNumber;
- (BOOL)isPureCharacter;
- (BOOL)isMiddleStronger;
- (BOOL)isMostStronger;
- (BOOL)isFaceExp;
- (BOOL)isFloatVaule;
- (BOOL)isUpcasecharacter;
- (BOOL)isEmail;
- (BOOL)isQQEmail;

@end
