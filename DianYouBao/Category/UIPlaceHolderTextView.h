//
//  UIPlaceHolderTextView.h
//  WeiLe
//
//  Created by linger on 18/11/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIPlaceHolderTextView : UITextView {
    
    NSString *placeholder;
    UIColor *placeholderColor;
@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end