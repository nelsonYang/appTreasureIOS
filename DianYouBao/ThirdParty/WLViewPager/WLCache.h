//
//  Cache.h
//  Cache
//
//  Created by linger on 22/05/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLCache : NSObject

+ (id)sharedInstance;

- (void)clearCache;
- (void)setCacheWithData:(NSData *)data forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;
- (NSString *)getCacheSize;
- (NSString *)getCacheDirectory;

@end
