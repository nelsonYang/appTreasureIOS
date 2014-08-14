//
//  AddViewController.h
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddrViewController : UIViewController

@property (nonatomic, retain) NSString *currentAddr;
@property (nonatomic, retain) NSString *addressId;
@property (nonatomic, retain) NSString *name;

- (IBAction)backClick:(id)sender;

@end
