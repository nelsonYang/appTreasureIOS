//
//  LaunchViewController.m
//  WeiLe
//
//  Created by linger on 09/07/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//

#import "LaunchViewController.h"
#import "UIView+RoundCorner.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "JSONKit.h"
#import "NSString+MD5.h"
#import "TransformData.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"
#import "CommonParam.h"
#import "AppDelegate.h"

@interface LaunchViewController ()<UIScrollViewDelegate>
{
    NSTimer *_timer;
}

@end

@implementation LaunchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *bgView= [[UIView alloc] initWithFrame:self.view.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackgroound:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self initWithCustomView];
    [self initWithFootBtnView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    SAFE_RELEASE(_scrollView);
    SAFE_RELEASE(_slideImages);
    SAFE_RELEASE(_pageControl);
    [super dealloc];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pagewidth/([_slideImages count]+2))/pagewidth)+1;
    page --;  
    _pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endTimer];
    CGFloat pagewidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pagewidth/ ([_slideImages count]+2)) / pagewidth) + 1;
    if (currentPage==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth * [_slideImages count],0,kScreenWidth,kScreenHeight) animated:NO]; 
    }
    else if (currentPage==([_slideImages count]+1))
    {
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth,0,kScreenWidth,kScreenHeight) animated:NO]; 
    }
    [self startTimer];
}

#pragma mark Notification
- (void)applicationEnterBackgroound:(NSNotification *)notification
{
    [self endTimer];
}

- (void)applicationBecomeActive:(NSNotification *)notification
{
    [self startTimer];
}

#pragma mark PrivateFunc

- (void)initWithCustomView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _slideImages = [[NSMutableArray alloc] init];
    if (iPhone5)
    {
        [_slideImages addObject:@"login_01_568.jpg"];
        [_slideImages addObject:@"login_02_568.jpg"];
        [_slideImages addObject:@"login_03_568.jpg"];
    }
    else
    {
        [_slideImages addObject:@"login_01.jpg"];
        [_slideImages addObject:@"login_02.jpg"];
        [_slideImages addObject:@"login_03.jpg"];
    }

    
    _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(100, iPhone5 ? 448 : 390, 120,18)];
    [_pageControl setPageControlStyle:PageControlStyleThumb];
    [_pageControl setThumbImage:[UIImage imageNamed:@"unfocus"]];
    [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"focus"]];
    
    _pageControl.numberOfPages = [self.slideImages count];
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    for (int i = 0;i<[_slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:i]]];
        imageView.frame = CGRectMake((kScreenWidth * i) + kScreenWidth, 0, kScreenWidth, kScreenHeight);
        [_scrollView addSubview:imageView];
        [imageView release];
    }
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:([_slideImages count]-1)]]];
    leftImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_scrollView addSubview:leftImageView];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_slideImages objectAtIndex:0]]];
    rightImageView.frame = CGRectMake((kScreenWidth * ([_slideImages count] + 1)) , 0, kScreenWidth, kScreenHeight);
    [_scrollView addSubview:rightImageView];
    [rightImageView release];
    
    [_scrollView setContentSize:CGSizeMake(kScreenWidth * ([_slideImages count] + 2), kScreenHeight)];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth,0,kScreenWidth, kScreenHeight) animated:NO];
}

- (void)initWithFootBtnView
{
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(20, iPhone5 ? kScreenHeight - 90 : kScreenHeight - 70, 130, 40);
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(170, iPhone5 ? kScreenHeight - 90 : kScreenHeight - 70, 130, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_grey_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_grey_pressing"] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)turnPage
{
    int page = _pageControl.currentPage;
    if (page==0)
    {
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth,0,kScreenWidth,kScreenHeight) animated:NO];
    }
    else
    {
        [self.scrollView scrollRectToVisible:CGRectMake(kScreenWidth*(page+1),0,kScreenWidth,kScreenHeight) animated:YES];
    }
}

- (void)runTimePage
{
    int page = _pageControl.currentPage;
    page++;
    page = page > _slideImages.count - 1 ? 0 : page ;
    _pageControl.currentPage = page;
    [self turnPage];
}

- (void)startTimer
{
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    }
}

- (void)endTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark BtnEvent

- (void)registerClick:(id)sender
{
    RegisterViewController *reigsterVC = [[RegisterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:reigsterVC animated:YES];
    [reigsterVC release];
}

- (void)loginClick:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    [loginVC release];
}

@end
