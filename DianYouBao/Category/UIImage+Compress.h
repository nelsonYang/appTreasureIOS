//
//  UIImage+Compress.h
//  WeiLe
//
//  Created by linger on 31/10/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

- (UIImage *)compressedImage;
- (NSData *)compressedImageWithData;
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)showSize:(CGRect)size;

@end
