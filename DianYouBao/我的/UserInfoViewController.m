//
//  UserInfoViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UpdateUserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CommonParam sharedInstance] requestUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidFinish:) name:kReqUserInfoDidFinish object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark UserInfoNotification

- (void)userInfoDidFinish:(NSNotification *)notifity
{
    [self initWithCustomView];
}

#pragma mark PrivateFunc
- (void)initWithCustomView
{
    //WLLog(@"%@", [CommonParam sharedInstance].userInfo);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 40*5)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    UIButton *accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.frame  = CGRectMake(5, 5, 290, 30);
    accountBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [accountBtn setTitle:[NSString stringWithFormat:@"账号:%@", [CommonParam sharedInstance].uuid] forState:UIControlStateNormal];
    accountBtn.tag = UserInfoType_uuid;
    [accountBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [accountBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:accountBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 290, 1)];
    line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line];
    [line release];
    
    UIButton *sexBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sexBtn.frame  = CGRectMake(5, 49, 290, 30);
    sexBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    if ([[[CommonParam sharedInstance].userInfo objectForKey:@"sex"] intValue] == 1)
    {
          [sexBtn setTitle:@"性别:男" forState:UIControlStateNormal];
    }
    else
    {
        [sexBtn setTitle:@"性别:女" forState:UIControlStateNormal];
    }

    sexBtn.tag = UserInfoType_sex;
    [sexBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sexBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sexBtn];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 290, 1)];
    line1.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line1];
    [line1 release];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame  = CGRectMake(5, 89, 290, 30);
    phoneBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [phoneBtn setTitle:[NSString stringWithFormat:@"手机号:%@", [[CommonParam sharedInstance].userInfo objectForKey:@"mobile"]] forState:UIControlStateNormal];
    phoneBtn.tag = UserInfoType_phone;
    [phoneBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:phoneBtn];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 120, 290, 1)];
    line2.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line2];
    [line2 release];
    
    UIButton *emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emailBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    emailBtn.frame  = CGRectMake(5, 129, 290, 30);
    [emailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [emailBtn setTitle:[NSString stringWithFormat:@"QQ邮箱:%@", [[CommonParam sharedInstance].userInfo objectForKey:@"email"]] forState:UIControlStateNormal];
    emailBtn.tag = UserInfoType_email;
    [emailBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:emailBtn];
    
    UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 290, 1)];
    line3.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line3];
    [line3 release];
    
    UIButton *pamentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pamentBtn.frame  = CGRectMake(5, 169, 290, 30);
    pamentBtn.titleLabel.textAlignment = UITextAlignmentLeft;
    [pamentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [pamentBtn setTitle:[NSString stringWithFormat:@"支付宝账号:%@", [[CommonParam sharedInstance].userInfo objectForKey:@"payAccount"]] forState:UIControlStateNormal];
    pamentBtn.tag = UserInfoType_payment;
    [pamentBtn addTarget:self action:@selector(userInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:pamentBtn];

}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userInfoClick:(UIButton *)button
{
    if (button.tag != UserInfoType_uuid)
    {
        UpdateUserInfoViewController *updateUserInfoVC = [[UpdateUserInfoViewController alloc] initWithNibName:nil bundle:nil];
        updateUserInfoVC.userInfoType = button.tag;
        [self.navigationController pushViewController:updateUserInfoVC animated:YES];
        [updateUserInfoVC release];
    }

}

@end
