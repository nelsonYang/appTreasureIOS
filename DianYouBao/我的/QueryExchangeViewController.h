//
//  ExchangeViewController.h
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryExchangeViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *unExchangeBtn;
@property (retain, nonatomic) IBOutlet UIButton *exchangedBtn;
@property (retain, nonatomic) IBOutlet UILabel *balanceLabel;

- (IBAction)backClick:(id)sender;

@end
