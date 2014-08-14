//
//  FindPwdViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "FindPwdViewController.h"

@interface FindPwdViewController ()

@end

@implementation FindPwdViewController

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
    if (self.titileStr)
    {
        self.titleLabel.text = self.titileStr;
    }
    [self initWithCustomView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];

    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
    warnLabel.text = @"请您联系点点赚官方客服的QQ";
    warnLabel.textColor = [UIColor darkGrayColor];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.textAlignment = UITextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:warnLabel];
    [warnLabel release];
    
    UILabel *qqLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 300, 40)];
    qqLabel.text = @"2274917090";
    qqLabel.backgroundColor = [UIColor clearColor];
    qqLabel.textColor = [UIColor redColor];
    qqLabel.textAlignment = UITextAlignmentCenter;
    qqLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:qqLabel];
    [qqLabel release];

}


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_titleLabel release];
    [super dealloc];
}
@end
