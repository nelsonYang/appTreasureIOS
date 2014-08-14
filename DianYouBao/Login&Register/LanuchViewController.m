//
//  LanuchViewController.m
//  DianZhuanBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "LanuchViewController.h"
#import "WLViewPager.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface LanuchViewController ()<WLViewPagerDelegate>

@end

@implementation LanuchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //WLLog(@"%f", kScreenHeight);
    //WLLog(@"%f", kScreenWidth);
    
    [self initWithViewPager];
    [self initWithButtons];
}

- (void)initWithViewPager
{
    WLViewPager *wlViewPager = [[WLViewPager alloc] initWithWLFrame:self.view.bounds];
    wlViewPager.delegate = self;
    if (iPhone5)
    {
        wlViewPager.localImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"login_01_568.jpg"], [UIImage imageNamed:@"login_02_568.jpg"], [UIImage imageNamed:@"login_03_568.jpg"], nil];
    }
    else
    {
        wlViewPager.localImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"login_01.jpg"], [UIImage imageNamed:@"login_02.jpg"], [UIImage imageNamed:@"login_03.jpg"], nil];
    }
    
    wlViewPager.thumbImage = [UIImage imageNamed:@"login_lost_focus"];
    wlViewPager.seclectImage = [UIImage imageNamed:@"login_get_focus"];
    wlViewPager.pageControllerAlignmentCenter = YES;
    [self.view addSubview:wlViewPager];
    [wlViewPager release];
}

- (void)initWithButtons
{
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(20, kScreenHeight - 90, 130, 40);
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(170, kScreenHeight - 90, 130, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_grey_normal"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_grey_pressing"] forState:UIControlStateHighlighted];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)registerClick:(id)sender
{

}

- (void)loginClick:(id)sender
{

}

@end
