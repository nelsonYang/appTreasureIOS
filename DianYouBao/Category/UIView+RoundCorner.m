//
//  UIView+RoundCorner.m
//  WeiLe
//
//  Created by linger on 09/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "UIView+RoundCorner.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (RoundCorner)

- (void)setRoundCorner
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
}

@end
