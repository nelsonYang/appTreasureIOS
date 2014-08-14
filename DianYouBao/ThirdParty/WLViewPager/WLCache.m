//
//  Cache.m
//  Cache
//
//  Created by linger on 22/05/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "WLCache.h"
#include <sys/stat.h>
#include <dirent.h>

#define kAutoClearCacheDate 60*60*24*7

@implementation WLCache

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getCacheDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"MyCaches"];
	return cacheDirectory;
}

- (void)clearCache
{
    [[NSFileManager defaultManager] removeItemAtPath:[self getCacheDirectory] error:nil];
}

- (id)objectForKey:(NSString*)key {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [[self getCacheDirectory] stringByAppendingPathComponent:key];
	if ([fileManager fileExistsAtPath:filename])
	{
		NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
		if ([modificationDate timeIntervalSinceNow] < - kAutoClearCacheDate)
        {
			[fileManager removeItemAtPath:filename error:nil];
		}
        else
        {
			NSData *data = [NSData dataWithContentsOfFile:filename];
			return data;
		}
	}
	return nil;
}

- (void)setCacheWithData:(NSData*)data forKey:(NSString*)key
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *filename = [[self getCacheDirectory] stringByAppendingPathComponent:key];
	BOOL isDir = YES;
	if (![fileManager fileExistsAtPath:[self getCacheDirectory] isDirectory:&isDir])
    {
		[fileManager createDirectoryAtPath:[self getCacheDirectory]
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
	}
	
	NSError *error;
	@try {
		[data writeToFile:filename options:NSDataWritingAtomic error:&error];
	}
	@catch (NSException * e) {
		//TODO: error handling maybe
	}
}

- (NSString *)getCacheSize
{
    return [NSString stringWithFormat:@"%.2f", ((float)[self getCacheSizeLong] / 1024 /1024)];
}

- (long long)getCacheSizeLong
{
    return [self folderSizeAtPath:[[self getCacheDirectory] cStringUsingEncoding:NSUTF8StringEncoding]];
}

- (long long) folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL)
    {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || 
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)
                                        )) continue;
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024]; 
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/')
        {
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR)
        {
            folderSize += [self folderSizeAtPath:childPath]; 
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
        else if (child->d_type == DT_REG || child->d_type == DT_LNK)
        {
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

@end
