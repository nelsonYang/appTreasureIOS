//
//  NSDictionary+Helper.m
//  WeiLe
//
//  Created by linger on 16/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data
{
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data,
                                                               kCFPropertyListImmutable,
                                                               NULL);
    if(plist == nil) return nil;
    if ([(id)plist isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)plist autorelease];
    }
    else
    {
        CFRelease(plist);
        return nil;
    }
}

- (NSData *)tranformToData
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"Some Key Value"];
    [archiver finishEncoding];
    [archiver release];
    return data;
}

@end
