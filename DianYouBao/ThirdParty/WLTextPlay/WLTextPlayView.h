//
//  WLTextPlayView.h
//  WeiLe
//
//  Created by wuqiang on 13-12-26.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLTextPlayView : UIView
{
    NSTimer *_playTimer;
    UIScrollView *_contentView;
    UILabel *_textLabel;
    int     scrollX;
}
-(void)startPlayText:(NSString*)playtext;
-(void)stopPlayText;
@end
