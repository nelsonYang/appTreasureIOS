//
//  UpdateUserInfoViewController.h
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"

@interface UpdateUserInfoViewController : UIViewController

@property (nonatomic, assign) UserInfoType userInfoType;

- (IBAction)backClick:(id)sender;

@end
