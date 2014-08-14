//
//  AppDelegate.h
//  DianZhuanBao
//
//  Created by 林 贤辉 on 14-1-9.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "ActivityViewController.h"
#import "ActivityViewController.h"
#import "ZhuanDianViewController.h"
#import "MineViewController.h"
#import "MoreViewController.h"

@class LaunchViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LaunchViewController *lanuchViewController;
@property (strong, nonatomic) MLNavigationController *rootNavi;
@property (strong, nonatomic) ActivityViewController *activityVC;
@property (strong, nonatomic) ZhuanDianViewController *zhuanDianVC;
@property (strong, nonatomic) MineViewController *mineVC;
@property (strong, nonatomic) MoreViewController *moreVC;
@property (strong, nonatomic) UITabBarController *tabbarController;

- (void)initWithTabbarController;

@end
