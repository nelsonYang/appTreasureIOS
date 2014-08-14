//
//  AccountViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AccountViewController.h"
#import "AdManager.h"

@interface AccountViewController ()
{
    UILabel *_balanceLabel;
    UILabel *_recommandBalanceLabel;
    Dialog *_dialog;
}
@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dialog = [[Dialog alloc] init];
    [[CommonParam sharedInstance] requestUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidFinish:) name:kReqUserInfoDidFinish object:nil];
    [self initWithCustomView];
}

- (void)dealloc
{
    SAFE_RELEASE(_dialog);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark UserInfoNotification

- (void)userInfoDidFinish:(NSNotification *)notifity
{
    [ALToastView toastInView:self.view withText:@"刷新成功"];
    [_dialog hideProgress];
    _balanceLabel.text = [NSString stringWithFormat:@"%d", [[CommonParam sharedInstance] calualteBalance]];
    _recommandBalanceLabel.text =[NSString stringWithFormat:@"%d", [[CommonParam sharedInstance] getReommandBalance]];

}

#pragma mark PrivateFunc
- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 180)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 30)];
    warnLabel.text = @"当前账号余额";
    warnLabel.textColor = [UIColor darkGrayColor];
    warnLabel.backgroundColor = [UIColor clearColor];
    warnLabel.textAlignment = UITextAlignmentCenter;
    warnLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:warnLabel];
    [warnLabel release];
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 300, 40)];
    _balanceLabel.text = [NSString stringWithFormat:@"%d", [[CommonParam sharedInstance] calualteBalance]];
    _balanceLabel.backgroundColor = [UIColor clearColor];
    _balanceLabel.textColor = [UIColor redColor];
    _balanceLabel.textAlignment = UITextAlignmentCenter;
    _balanceLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:_balanceLabel];
    [_balanceLabel release];
    
    UILabel *recommandLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, 300, 30)];
    recommandLabel.text = @"推荐奖励";
    recommandLabel.textColor = [UIColor darkGrayColor];
    recommandLabel.backgroundColor = [UIColor clearColor];
    recommandLabel.textAlignment = UITextAlignmentCenter;
    recommandLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:recommandLabel];
    [recommandLabel release];
    
    _recommandBalanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 300, 40)];
    _recommandBalanceLabel.text = [NSString stringWithFormat:@"%d", [[CommonParam sharedInstance] getReommandBalance]];
    _recommandBalanceLabel.backgroundColor = [UIColor clearColor];
    _recommandBalanceLabel.textColor = [UIColor redColor];
    _recommandBalanceLabel.textAlignment = UITextAlignmentCenter;
    _recommandBalanceLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:_recommandBalanceLabel];
    [_recommandBalanceLabel release];
    
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"刷新账号" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(refreshClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];

}

- (void)refreshClick:(id)sender
{
    [_dialog showProgress:self withLabel:@"刷新账户中"];
    [[AdManager sharedInstance] reqUploadScore];
    [[CommonParam sharedInstance] requestUserInfo];
    
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
