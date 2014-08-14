//
//  UIButton+Tag.h
//  WeiLe
//
//  Created by YDH on 13-12-31.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLButton : UIButton

@property (nonatomic, retain) NSString *longTag;
@property (nonatomic, retain) NSString *carriedString;
@property (nonatomic, assign) CGPoint cgPoint;
@property (nonatomic, retain) NSMutableDictionary *dict;
@end
