//
//  NSString+DateFormat.h
//  WeiLe
//
//  Created by linger on 21/08/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DateFormat)

- (NSString *)dateFormat:(NSString *)currentFormate;

- (NSDate*)convertDateFromString:(NSString*)formate;

@end
