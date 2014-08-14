//
//  LoginViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FindPwdViewController.h"
#import "AppDelegate.h"
#import "AdManager.h"
#import "DMOfferWallManager.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_accountTF;
    UITextField *_pwdTF;
    Dialog *_dialog;
    AppDelegate *_appDel;
}

@property (nonatomic, retain) ASIFormDataRequest *reqLogin;

@end

@implementation LoginViewController

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
    [self initWithCustomView];
    
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    _accountTF.text = uuid;
    _pwdTF.text = pwd;
    
    if (!uuid || !pwd)
    {
        [_accountTF becomeFirstResponder];
    }
    _dialog = [[Dialog alloc] init];
    _appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)dealloc
{
    ASI_SAFE_RELEASE(_reqLogin);
    SAFE_RELEASE(_dialog);
    
    [super dealloc];
}
#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_accountTF resignFirstResponder])
    {
        [_pwdTF becomeFirstResponder];
    }
    else if ([_pwdTF resignFirstResponder])
    {
        [self loginClick:nil];
    }
    return YES;
}
#pragma mark RequestDidFinish
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dict = [jsonDecoder objectWithData:[request responseData]];
    
    NSString *requestType = [request.userInfo objectForKey:kRequestKey];
    if ([requestType isEqualToString:@"login"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            
            [CommonParam sharedInstance].isLogin = YES;
            NSUserDefaults *defaultuserinfo=[NSUserDefaults standardUserDefaults];
            [defaultuserinfo setObject:_accountTF.text forKey:@"account"];
            [defaultuserinfo setObject:_pwdTF.text forKey:@"password"];
            [defaultuserinfo synchronize];
            
            [CommonParam sharedInstance].uuid = _accountTF.text;
            [CommonParam sharedInstance].password = _pwdTF.text;
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

#pragma PrivateFunc

- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 290, 1)];
    line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line];
    
    _accountTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 25)];
    _accountTF.placeholder = @"请输入账号";
    _accountTF.delegate = self;
    _accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTF.returnKeyType = UIReturnKeyNext;
    [bgView addSubview:_accountTF];
    [_accountTF release];
    
    _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 49, 270, 25)];
    _pwdTF.placeholder = @"请输入密码";
    _pwdTF.delegate = self;
    _pwdTF.secureTextEntry = YES;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_pwdTF];
    [_pwdTF release];
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"登录" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];
    
    UIButton *findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPwdBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    findPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [findPwdBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [findPwdBtn addTarget:self action:@selector(findPwdClick:) forControlEvents:UIControlEventTouchUpInside];
    findPwdBtn.frame = CGRectMake(215, 195, 120, 40);
    [self.view addSubview:findPwdBtn];
}

- (void)loginClick:(id)sender
{
    if (_accountTF.text.length == 0)
    {
        [ALToastView toastInView:self.view withText:@"请输入账号"];
    }
    else if (_pwdTF.text.length < 5)
    {
        [ALToastView toastInView:self.view withText:@"输入密码小于6位"];
    }
    else
    {
        [self requestLogin];
    }
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)findPwdClick:(id)sender
{
    FindPwdViewController *findPwdVC = [[FindPwdViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:findPwdVC animated:YES];
    [findPwdVC release];
}

- (void)requestLogin
{
    [_dialog showProgress:self withLabel:@"登录中..."];
    
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:_accountTF.text, @"userName", _pwdTF.text, @"password",nil];
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
