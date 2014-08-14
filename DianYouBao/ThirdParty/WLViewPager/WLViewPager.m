//
//  WLViewPager.m
//  WLViewPager
//
//  Created by linger on 21/11/13.
//  Copyright (c) 2013年 linger. All rights reserved.
//

#import "WLViewPager.h"
#import "WLPageControl.h"
#import "UIImageView+WLImageView.h"
#import "ConverCD.h"

#define kWLScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWLScreenWidth [UIScreen mainScreen].bounds.size.width
#define WLDELEGATE_CALLBACK_ONE_PARAMETER(DELEGATE, SEL, X) if (DELEGATE && [DELEGATE respondsToSelector:@selector(SEL)]) [DELEGATE performSelector:@selector(SEL) withObject:X]
@interface WLViewPager()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    WLPageControl *_pageControl;
}

@property (nonatomic, retain) NSTimer *timer;

@end

@implementation WLViewPager

- (id)initWithWLFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self initWithCustomView:rect];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scrollView.frame.size.width;
    int pageCount = self.localImages ?  self.localImages.count : self.netWorkImagesUrl.count;
    int page = floor((_scrollView.contentOffset.x - pagewidth/(pageCount+2))/pagewidth)+1;
    page --;
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stopViewPagerTimer];
    CGFloat pagewidth = _scrollView.frame.size.width;
    int currentPage = floor((_scrollView.contentOffset.x - pagewidth/ ([self.localImages count]+2)) / pagewidth) + 1;
    
    if (self.localImages)
    {
        if (currentPage==0)
        {
            [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * self.localImages.count,0,self.frame.size.width,self.frame.size.height) animated:NO];
        }
        else if (currentPage==([self.localImages count]+1))
        {
            [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
        }
    }
    else
    {
        if (currentPage==0)
        {
            [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width * self.netWorkImagesUrl.count,0,self.frame.size.width,self.frame.size.height) animated:NO];
        }
        else if (currentPage==([self.netWorkImagesUrl count]+1))
        {
            [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
        }
    }
    
    [self startViewPagerTimer];
}

- (void)initWithCustomView:(CGRect)rect
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView release];
    }

    if (_pageControl == nil)
    {
        _pageControl = [[WLPageControl alloc] initWithFrame:CGRectMake(self.pageControllerXPoint ? self.pageControllerXPoint : 0, kScreenHeight - 20, self.localImages ? self.localImages.count * 12 : self.netWorkImagesUrl.count*10,20)];
    }
    
    if (self.thumbImage && self.seclectImage) {
        [_pageControl setPageControlStyle:PageControlStyleThumb];
        [_pageControl setThumbImage:self.thumbImage];
        [_pageControl setSelectedThumbImage:self.seclectImage];
    }
    else
    {
        [_pageControl setPageControlStyle:PageControlStyleDefault];
    }

    _pageControl.numberOfPages =  self.localImages ? [self.localImages count] : [self.netWorkImagesUrl count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];

    
    if (self.localImages)
    {
        for (int i = 0; i < [self.localImages count];i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [self.localImages objectAtIndex:i];
            imageView.frame = CGRectMake((rect.size.width * i) + rect.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:)];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];
            
            [imageView release];
        }
    }
    else
    {
        for (int i = 0; i < [self.netWorkImagesUrl count];i++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            UIImage *placeholderImage = [ConverCD creactLoadingImage:CGSizeMake(rect.size.width, rect.size.height) FillColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
            [imageView setWLImage:[self.netWorkImagesUrl objectAtIndex:i] placeholder:placeholderImage];
            imageView.frame = CGRectMake((rect.size.width * i) + rect.size.width, 0, rect.size.width, rect.size.height);
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            [_scrollView addSubview:imageView];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickImage:)];
            [imageView addGestureRecognizer:singleTap];
            [singleTap release];
            
            [imageView release];
        }
    }
    
    UIImageView *leftImageView = [[UIImageView alloc] init];
    if (self.localImages)
    {
        leftImageView.image = [self.localImages objectAtIndex:([self.localImages count]-1)];
    }
    else
    {
        UIImage *placeholderImage = [ConverCD creactLoadingImage:CGSizeMake(rect.size.width, rect.size.height) FillColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [leftImageView setWLImage:[self.netWorkImagesUrl objectAtIndex:([self.netWorkImagesUrl count]-1)] placeholder:placeholderImage];
    }
    leftImageView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [_scrollView addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc] init];
    if (self.localImages)
    {
        rightImageView.image = [self.localImages objectAtIndex:0];
        rightImageView.frame = CGRectMake((rect.size.width * ([self.localImages count] + 1)) , 0, rect.size.width, rect.size.height);
    }
    else
    {
        UIImage *placeholderImage = [ConverCD creactLoadingImage:CGSizeMake(rect.size.width, rect.size.height) FillColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [rightImageView setWLImage:[self.netWorkImagesUrl objectAtIndex:0] placeholder:placeholderImage];
        rightImageView.frame = CGRectMake((rect.size.width * ([self.netWorkImagesUrl count] + 1)) , 0, rect.size.width, rect.size.height);
    }
    [_scrollView addSubview:rightImageView];
    [rightImageView release];
    
    if (self.localImages)
    {
        [_scrollView setContentSize:CGSizeMake(rect.size.width *  ([self.localImages count] + 2), rect.size.height)];
    }
    else
    {
        [_scrollView setContentSize:CGSizeMake(rect.size.width *  ([self.netWorkImagesUrl count] + 2), rect.size.height)];
    }
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(rect.size.width,0,rect.size.width, rect.size.height) animated:NO];
    
    if (self.pageControllerAlignmentCenter)
    {
        CGPoint pagePoint = _pageControl.center;
        _pageControl.center = CGPointMake(_scrollView.frame.size.width/2, pagePoint.y);
    }
    [self startViewPagerTimer];
}

- (void)startViewPagerTimer
{
    int pageCount = self.localImages ?  self.localImages.count : self.netWorkImagesUrl.count;
    if (pageCount >1)
    {
        if (_timer == nil)
        {
            [self setTimer:[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES]];
        }
    }
}

- (void)stopViewPagerTimer
{
    int pageCount = self.localImages ?  self.localImages.count : self.netWorkImagesUrl.count;
    if (pageCount >1 )
    {
        if (_timer != nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)runTimePage
{
    int page = _pageControl.currentPage;
    page++;
    int pageCount = self.localImages ?  self.localImages.count : self.netWorkImagesUrl.count;
    page = page > pageCount - 1 ? 0 : page ;
    _pageControl.currentPage = page;
    
    [self turnPage];
}

- (void)turnPage
{
    int page = _pageControl.currentPage;
    if (page==0)
    {
        [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    }
    else
    {
        [_scrollView scrollRectToVisible:CGRectMake(self.frame.size.width*(page+1),0,self.frame.size.width,self.frame.size.height) animated:YES];
    }
}

-(void)onClickImage:(UIGestureRecognizer *)guesture
{
    WLDELEGATE_CALLBACK_ONE_PARAMETER(self.delegate, imageViewDidSelectIndex:,[NSNumber numberWithInteger:guesture.view.tag]);
}

- (void)removeWLViewPager
{
    [super removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
