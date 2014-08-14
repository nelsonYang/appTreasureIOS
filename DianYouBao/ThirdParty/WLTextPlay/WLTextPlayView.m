//
//  WLTextPlayView.m
//  WeiLe
//
//  Created by wuqiang on 13-12-26.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "WLTextPlayView.h"
#import "ConverCD.h"

@implementation WLTextPlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatScrollow];
    }
    return self;
}
-(void)creatScrollow
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    [_contentView release];
    
    float labely = (self.frame.size.height - 20)/2;
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, labely, 100, 20)];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_textLabel];
    [_textLabel release];
}
-(void)startPlayText:(NSString*)playtext
{
    [self freePlayTimer];
    int labelW = [ConverCD getContentMaxWidth:playtext FontSize:15.0];
    CGRect textrect = _textLabel.frame;
    textrect.size.width = labelW + 20;
    _textLabel.frame = textrect;
    _textLabel.text = playtext;
    scrollX = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(playTextAction) userInfo:nil repeats:YES];
}
-(void)playTextAction
{
    int totalW = self.frame.size.width + [ConverCD getContentMaxWidth:_textLabel.text FontSize:15.0];
    if (scrollX < totalW)
    {
        scrollX ++;
    }
    else
    {
        scrollX = 0;
    }
    [_contentView setContentOffset:CGPointMake(-scrollX, 0) animated:NO];
}
-(void)stopPlayText
{
    [self freePlayTimer];
}

-(void)freePlayTimer
{
    if (_playTimer != nil)
    {
        [_playTimer invalidate];
        _playTimer = nil;
    }
}

-(void)dealloc
{
    [self freePlayTimer];
    [super dealloc];
}

@end
