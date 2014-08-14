//
//  ExchangeViewController.h
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    Money_Type_50 = 50,
    Money_Type_100 = 100,
    Money_Type_200 = 200
} Money_Type;

@interface ExchangeViewController : UIViewController

- (IBAction)backClick:(id)sender;

@end
