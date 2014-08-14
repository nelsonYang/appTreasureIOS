//
//  UserInfoViewController.h
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UserInfoType_uuid = 99,
    UserInfoType_sex,
    UserInfoType_phone,
    UserInfoType_email,
    UserInfoType_payment
} UserInfoType;

@interface UserInfoViewController : UIViewController

- (IBAction)backClick:(id)sender;

@end
