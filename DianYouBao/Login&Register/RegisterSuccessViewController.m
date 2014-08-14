//
//  RegisterSuccessViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "RegisterSuccessViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RTLabel.h"
#import "Dialog.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "NSString+MD5.h"
#import "CommonParam.h"
#import "TransformData.h"
#import "SVProgressHUD.h"
#import "LanuchViewController.h"
#import "AppDelegate.h"

@interface RegisterSuccessViewController ()
{
    Dialog *_dialog;
    AppDelegate *_appDel;
}

@property (nonatomic, retain) ASIFormDataRequest *reqLogin;

@end

@implementation RegisterSuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initWithCustomView];
    _dialog = [[Dialog alloc] init];
    _appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    SAFE_RELEASE(_dialog);
    ASI_SAFE_RELEASE(_reqLogin);
    
    [super dealloc];
}

#pragma mark RequestDidFinish
- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dict = [jsonDecoder objectWithData:[request responseData]];
    
    NSString *requestType = [request.userInfo objectForKey:kRequestKey];
    if ([requestType isEqualToString:@"login"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
   
            [CommonParam sharedInstance].isLogin = YES;
            NSUserDefaults *defaultuserinfo=[NSUserDefaults standardUserDefaults];
            [defaultuserinfo setObject:self.uuid forKey:@"account"];
            [defaultuserinfo setObject:self.password forKey:@"password"];
            [defaultuserinfo synchronize];
            
            [CommonParam sharedInstance].uuid = self.uuid;
            [CommonParam sharedInstance].password = self.password;
            [CommonParam sharedInstance].isLogin = YES;
            
            int encryptType = [[dict objectForKey:@"encryptCode"] intValue];
            NSDictionary *dataDetaiDict = [TransformData transformData:encryptType dict:dict];
            [CommonParam sharedInstance].session = [dataDetaiDict objectForKey:@"session"];
            [CommonParam sharedInstance].key = [dataDetaiDict objectForKey:@"key"];
            [_appDel initWithTabbarController];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
        [_dialog hideProgress];
    }

    [jsonDecoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"])
    {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}


#pragma mark PrivateFun

- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    NSString *text =  [NSString stringWithFormat:@"<font size=15 color=#939393> 恭喜您 :</font><font size=25 color=red>%@</font><font size=15 color=#939393> 用户</font>" , self.uuid];
    RTLabel *warnLabel = [[RTLabel alloc]initWithFrame:CGRectMake(30, 20, 290, 50)];
    warnLabel.text = text;
    [bgView addSubview:warnLabel];
    [warnLabel release];
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"登录" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];
}

- (IBAction)backClick:(id)sender
{
    NSArray *viewControllers = self.navigationController.viewControllers;
    for (UIViewController *controller in viewControllers)
    {
        if ([controller isKindOfClass:[LanuchViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)loginClick:(id)sender
{
    if (self.uuid && self.password)
    {
        [self requestLogin];
    }
}

- (void)requestLogin
{
    [_dialog showProgress:self withLabel:@"登录中..."];
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:self.uuid, @"userName", self.password, @"password",nil];
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:dataDict, kDataReq, kMd5Req,kEncryptTypeReq, nil];
    
    NSString *requestStr = [reqDict JSONString];
    NSString *signMD5 = [requestStr MD5];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=login&sign=%@", kServerUrl, signMD5]];
    
    [_reqLogin cancel];
    [self setReqLogin:[ASIFormDataRequest requestWithURL:url]];
    [_reqLogin setPostValue:requestStr forKey:kRequestRes];
    [_reqLogin setUserInfo:[NSDictionary dictionaryWithObject:@"login" forKey:kRequestKey]];
    [_reqLogin setDelegate:self];
    [_reqLogin startAsynchronous];
}

@end
