//
//  AppDelegate.m
//  DianZhuanBao
//
//  Created by 林 贤辉 on 14-1-9.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [self.tabbarController release];
    [self.activityVC release];
    [self.zhuanDianVC release];
    [self.mineVC release];
    [self.moreVC release];
    [_window release];
    [_lanuchViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.lanuchViewController = [[[LaunchViewController alloc] initWithNibName:@"LanuchViewController" bundle:nil] autorelease];
    self.rootNavi = [[[MLNavigationController alloc] initWithRootViewController:self.lanuchViewController] autorelease];
    self.rootNavi.canDragBack = YES;
    self.rootNavi.hidesBottomBarWhenPushed = YES;
    self.rootNavi.navigationBarHidden = YES;
    
    self.window.rootViewController = self.rootNavi;
    [self.window makeKeyAndVisible];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)initWithTabbarController
{
    
    
    if (self.activityVC == nil)
    {
        [self.activityVC = [ActivityViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if (self.zhuanDianVC == nil)
    {
        self.zhuanDianVC = [[ZhuanDianViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if (self.mineVC == nil)
    {
        self.mineVC = [[MineViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    if (self.moreVC == nil)
    {
        self.moreVC = [[MoreViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    
    if (self.tabbarController == nil)
    {
        self.tabbarController = [[UITabBarController alloc] init];
    }
    self.tabbarController.selectedIndex = 0;
    [_tabbarController.tabBar setBackgroundImage:[UIImage imageNamed:@"label_bg"]];
    self.tabbarController.viewControllers = [NSArray arrayWithObjects:self.zhuanDianVC, self.activityVC, self.mineVC, self.moreVC, nil];
    
    self.zhuanDianVC.dmManager = [[DMOfferWallManager alloc] initWithPublishId:kAppKey userId:[CommonParam sharedInstance].uuid];
    self.zhuanDianVC.offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:kAppKey andUserID:[CommonParam sharedInstance].uuid];
    self.zhuanDianVC.videoController = [[DMVideoViewController alloc] initWithPublisherID:kAppKey andUserID:[CommonParam sharedInstance].uuid];
    self.zhuanDianVC.dmManager.delegate = [AdManager sharedInstance];
    
    [self.rootNavi pushViewController:self.tabbarController animated:YES];
}

@end
