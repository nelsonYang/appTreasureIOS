//
//  NSDictionary+Helper.h
//  WeiLe
//
//  Created by linger on 16/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helper)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data;
- (NSData *)tranformToData;

@end
