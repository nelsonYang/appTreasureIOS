//
//  NSString+FontHeight.h
//  WeiLe
//
//  Created by linger on 10/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FontHeight)

- (float)getFontSize:(float)fontSize andWidth:(float)width;

- (float)getHeightWithFont:(UIFont *)font andWidth:(float)width;

@end
