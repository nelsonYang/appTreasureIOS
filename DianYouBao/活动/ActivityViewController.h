//
//  ActivityViewController.h
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *dianBiLabel;
@property (retain, nonatomic) IBOutlet UIImageView *toolbar;

- (IBAction)getMoneyClick:(id)sender;
- (IBAction)refreshClick:(id)sender;

@end
