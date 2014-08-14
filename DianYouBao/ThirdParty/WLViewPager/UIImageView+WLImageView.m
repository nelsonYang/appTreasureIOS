//
//  UIImageView+WLImageView.m
//  TestWLFramework
//
//  Created by linger on 21/11/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "UIImageView+WLImageView.h"
#import "WLCache.h"
#import "NSString+WLMD5.h"

@implementation UIImageView (WLImageView)


- (void)setWLImage:(NSString *)url placeholder:(UIImage *)placeholdImage;
{
    NSURL *imageURL = [NSURL URLWithString:url];
	NSString *key = [url getWLMD5Hash];
	NSData *data = [[WLCache sharedInstance] objectForKey:key];
	if (data)
    {
		UIImage *image = [UIImage imageWithData:data];
        self.image = image;
	} else {
		self.image = placeholdImage;
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
		dispatch_async(queue, ^{
			NSData *data = [NSData dataWithContentsOfURL:imageURL];
			[[WLCache sharedInstance] setCacheWithData:data forKey:key];
			UIImage *image = [UIImage imageWithData:data];
			dispatch_sync(dispatch_get_main_queue(), ^{
                self.image = image;
                
			});
		});
	}
}

@end
