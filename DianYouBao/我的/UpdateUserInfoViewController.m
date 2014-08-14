//
//  UpdateUserInfoViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "UpdateUserInfoViewController.h"
#import "NSString+RegExp.h"

@interface UpdateUserInfoViewController ()<UITextFieldDelegate, UIActionSheetDelegate>
{
    UITextField *_userInfoTF;
    Dialog *_dialog;
}

@property (nonatomic, retain) ASIFormDataRequest *reqUpdateUserInfo;

@end

@implementation UpdateUserInfoViewController

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
    _dialog = [[Dialog alloc] init];
    [self initWithCustomView];
}

- (void)dealloc
{
    SAFE_RELEASE(_userInfoTF);
    ASI_SAFE_RELEASE(_reqUpdateUserInfo);
    SAFE_RELEASE(_dialog);
    [super dealloc];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.userInfoType == UserInfoType_sex)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
        [actionSheet showInView:self.view];
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updateClick:nil];
    return YES;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _userInfoTF.text  = @"男";
        [self requestUpdateUserInfo];
    }
    else if (buttonIndex == 1)
    {
        _userInfoTF.text = @"女";
        [self requestUpdateUserInfo];
    }
}
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [_dialog hideProgress];
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dict = [jsonDecoder objectWithData:[request responseData]];
    if (!dict) {
        return;
    }
    NSString *requestType = [request.userInfo objectForKey:kRequestKey];
    
    
    if ([requestType isEqualToString:@"updateUserInfo"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [ALToastView toastInView:self.view withText:@"更新成功"];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
    }
    [jsonDecoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark PrivateFunc

- (void)initWithCustomView
{
    //WLLog(@"%@", [CommonParam sharedInstance].userInfo);
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 290, 1)];
    line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line];
    [line release];
    
    _userInfoTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 25)];
    _userInfoTF.delegate = self;
    _userInfoTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userInfoTF.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:_userInfoTF];
    
    if (self.userInfoType == UserInfoType_sex)
    {
        if ([[[CommonParam sharedInstance].userInfo objectForKey:@"sex"] intValue] == 1)
        {
            _userInfoTF.text = @"男";
        }
        else
        {
            _userInfoTF.text = @"女";
        }
        _userInfoTF.placeholder = @"性别";
    }
    else if (self.userInfoType == UserInfoType_phone)
    {
        _userInfoTF.text = [[CommonParam sharedInstance].userInfo objectForKey:@"mobile"];
        _userInfoTF.placeholder = @"手机号";
    
    }
    else if (self.userInfoType == UserInfoType_email)
    {
        _userInfoTF.text =  [[CommonParam sharedInstance].userInfo objectForKey:@"email"];
        _userInfoTF.placeholder = @"QQ邮箱";
    }
    else if (self.userInfoType == UserInfoType_payment)
    {
        _userInfoTF.text = [[CommonParam sharedInstance].userInfo objectForKey:@"payAccount"];
        _userInfoTF.placeholder = @"支付宝账号";
    }
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"更新" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(updateClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];
}

- (void)updateClick:(id)sender
{
    [_userInfoTF resignFirstResponder];
    
    if (_userInfoTF.text.length == 0)
    {
        [ALToastView toastInView:self.view withText:@"请输入更新内容"];
    }
    else if (self.userInfoType == UserInfoType_phone && ![_userInfoTF.text isPhoneNumber])
    {
        [ALToastView toastInView:self.view withText:@"请输入正确的电话号码"];
    }
    else if (self.userInfoType == UserInfoType_email && ![_userInfoTF.text isQQEmail])
    {
        [ALToastView toastInView:self.view withText:@"请输入正确的QQ邮箱"];
    }
    else
    {
        [self requestUpdateUserInfo];
    }
}

- (void)requestUpdateUserInfo
{
    
    NSDictionary *dataDict = nil;
    
    if (self.userInfoType == UserInfoType_sex)
    {
        if ([_userInfoTF.text isEqualToString:@"男"])
        {
            dataDict = [NSDictionary dictionaryWithObject:@"1" forKey:@"sex"];
        }
        else
        {
            dataDict = [NSDictionary dictionaryWithObject:@"0" forKey:@"sex"];
        }
    }
    else if (self.userInfoType == UserInfoType_phone)
    {
        dataDict = [NSDictionary dictionaryWithObject:_userInfoTF.text  forKey:@"mobile"];
    }
    else if (self.userInfoType == UserInfoType_email)
    {
        dataDict = [NSDictionary dictionaryWithObject:_userInfoTF.text forKey:@"email"];
    }
    else if (self.userInfoType == UserInfoType_payment)
    {
        dataDict = [NSDictionary dictionaryWithObject:_userInfoTF.text forKey:@"payAccount"];
    }
    
    [_dialog showProgress:self withLabel:@"正在请求中..."];

    NSData *aesData= [dataDict JSONData];
    
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=updateUserInfo", kServerUrl]];
    
    [_reqUpdateUserInfo cancel];
    [self setReqUpdateUserInfo:[ASIFormDataRequest requestWithURL:url]];
    [_reqUpdateUserInfo setPostValue:requestStr forKey:kRequestRes];
    [_reqUpdateUserInfo setUserInfo:[NSDictionary dictionaryWithObject:@"updateUserInfo" forKey:kRequestKey]];
    [_reqUpdateUserInfo setDelegate:self];
    [_reqUpdateUserInfo startAsynchronous];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
