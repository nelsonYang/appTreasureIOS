//
//  RegisterViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "RegisterViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "Dialog.h"
#import "NSString+MD5.h"
#import "CommonParam.h"
#import "SVProgressHUD.h"
#import "RegisterSuccessViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    UITextField *_pwdTF;
    UITextField *_confirmPwdTF;
    UITextField *_recommandAccount;
    Dialog *_dialog;
}

@property(nonatomic,retain) ASIFormDataRequest *reqRegister;

@end

@implementation RegisterViewController

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
    _dialog = [[Dialog alloc] init];
    [_pwdTF becomeFirstResponder];
}

- (void)dealloc
{
    ASI_SAFE_RELEASE(_reqRegister);
    SAFE_RELEASE(_dialog);
    
    [super dealloc];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_pwdTF resignFirstResponder])
    {
        [_confirmPwdTF becomeFirstResponder];
    }
    else if ([_confirmPwdTF resignFirstResponder])
    {
        [self registerClick:nil];
    }
    return YES;
}

#pragma mark ASIRequDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    JSONDecoder *jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dict = [jsonDecoder objectWithData:[request responseData]];
    NSString *requesttype = [request.userInfo objectForKey:kRequestKey];
    if([requesttype isEqualToString:@"register"])
    {
        if ([[dict objectForKey:@"resultCode"] intValue] == 0)
        {
            [CommonParam sharedInstance].password = _pwdTF.text;
            NSString *uuid = [[dict objectForKey:@"data"] objectForKey:@"userName"];
            
            RegisterSuccessViewController *registerSuccessVC = [[RegisterSuccessViewController alloc] initWithNibName:nil bundle:nil];
            registerSuccessVC.uuid = uuid;
            registerSuccessVC.password = _confirmPwdTF.text;
            [self.navigationController pushViewController:registerSuccessVC animated:YES];
            [registerSuccessVC release];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:@"resultCode"] intValue] taostViewController:self];
        }
    }
    
    [jsonDecoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    //推送特殊处理
    NSString *requestType = [request.userInfo objectForKey:kRequestKey];
    if ([requestType isEqualToString:@"cancelBindPushMsg"] || [requestType isEqualToString:@"addBindPushMsg"])
    {
        return;
    }
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma PrivateFunc

- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 125)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 290, 1)];
    line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line];
    [line release];
    
    _pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 25)];
    _pwdTF.placeholder = @"请输入大于6位数密码";
    _pwdTF.delegate = self;
    _pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdTF.returnKeyType = UIReturnKeyNext;
    _pwdTF.secureTextEntry = YES;
    [bgView addSubview:_pwdTF];
    [_pwdTF release];
    
    
    _confirmPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 49, 270, 25)];
    _confirmPwdTF.placeholder = @"请输入确认密码";
    _confirmPwdTF.delegate = self;
    _confirmPwdTF.secureTextEntry = YES;
    _confirmPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmPwdTF.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_confirmPwdTF];
    [_confirmPwdTF release];
    
    _recommandAccount = [[UITextField alloc] initWithFrame:CGRectMake(10, 90, 300, 25)];
    _recommandAccount.placeholder = @"请输入推荐人账号";
    _recommandAccount.delegate = self;
    _recommandAccount.clearButtonMode = UITextFieldViewModeWhileEditing;
    _recommandAccount.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_recommandAccount];
    [_recommandAccount release];
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"注册" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerClick:(id)sender
{
    if (_pwdTF.text.length < 5)
    {
        [ALToastView toastInView:self.view withText:@"请输入6位以上密码"];
    }
    else if (![_confirmPwdTF.text isEqualToString:_pwdTF.text])
    {
        [ALToastView toastInView:self.view withText:@"输入密码与确认密码不一致"];
    }
    else
    {
        [self requestRegistion];
    }
}

- (void)requestRegistion
{
    [_dialog showProgress:self withLabel:@"注册请求中..."];
    NSDictionary *reqDic;
    if(_recommandAccount.text != nil && ![_recommandAccount.text isEqualToString:@""]){
           reqDic= [NSDictionary dictionaryWithObjectsAndKeys:_confirmPwdTF.text, @"password",_recommandAccount.text, @"recommandAccount",nil];
    }else{
       reqDic= [NSDictionary dictionaryWithObjectsAndKeys:_confirmPwdTF.text, @"password",nil];
    }
    NSString *requestStr = [reqDic JSONString];
    NSString *signMD5 = [requestStr MD5];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=register&sign=%@",kServerUrl,signMD5]];
    
    [_reqRegister cancel];
    [self setReqRegister:[ASIFormDataRequest requestWithURL:url]];
    [_reqRegister setPostValue:requestStr forKey:kRequestReq];
    [_reqRegister setUserInfo:[NSDictionary dictionaryWithObject:@"register" forKey:kRequestKey]];
    [_reqRegister setDelegate:self];
    [_reqRegister startAsynchronous];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    if(touch.tapCount == 1)
    {
        [_pwdTF resignFirstResponder];
        [_confirmPwdTF resignFirstResponder];
    }
}

@end
