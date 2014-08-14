//
//  UIButton+Tag.m
//  WeiLe
//
//  Created by YDH on 13-12-31.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "WLButton.h"

@implementation WLButton

-(void)dealloc{
    [super dealloc];
    SAFE_RELEASE(_longTag);
    SAFE_RELEASE(_carriedString);
    SAFE_RELEASE(_dict);
}

@end
