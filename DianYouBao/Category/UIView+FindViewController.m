//
//  UIView+FindViewController.m
//  WeiLe
//
//  Created by YDH on 13-11-13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "UIView+FindViewController.h"

@implementation UIView (FindViewController)


- (id)findUIViewController: (UIView *) view
{
    id nextResponder = [view nextResponder];
	
    if ([nextResponder isKindOfClass:[UIViewController class]])
	{
        return nextResponder;
    }
	else if ([nextResponder isKindOfClass:[UIView class]])
	{
        return [self findUIViewController:nextResponder];
    }
	else
	{
        return nil;
    }
}

@end
