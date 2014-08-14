//
//  AddViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AddAddrViewController.h"

@interface AddAddrViewController ()<UITextFieldDelegate>
{
    UITextField *_addressTF;
    UITextField *_nameTF;
    Dialog *_dialog;
}

@property (nonatomic, retain) ASIFormDataRequest *reqInsertAddr;
@property (nonatomic, retain) ASIFormDataRequest *reqUpdateAddr;

@end

@implementation AddAddrViewController

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
    SAFE_RELEASE(_dialog);
    ASI_SAFE_RELEASE(_reqInsertAddr);
    ASI_SAFE_RELEASE(_reqUpdateAddr);
    [super dealloc];
}

#pragma UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_addressTF resignFirstResponder])
    {
        [_nameTF becomeFirstResponder];
    }
    else if ([_nameTF resignFirstResponder])
    {
        if (self.currentAddr)
        {
            [self updateAddrClick:nil];
        }
        else
        {
            [self insertAddrClick:nil];
        }
    }
    return YES;
}
#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder * jsonDecoder = [[JSONDecoder alloc] init];
    NSDictionary *dict = [jsonDecoder objectWithData:[request responseData]];
    if (!dict) {
        return;
    }
    NSString *requestType = [request.userInfo objectForKey:kRequestKey];
    
    if ([requestType isEqualToString:@"updateAddress"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [ALToastView toastInView:self.view withText:@"更新收货人地址成功"];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
    }
    else if ([requestType isEqualToString:@"insertAddress"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [ALToastView toastInView:self.view withText:@"添加收货人地址成功"];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [self backClick:nil];
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
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark PrivateFunc

- (void)initWithCustomView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 300, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:bgView];
    [bgView release];
    
    _addressTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, 270, 25)];
    _addressTF.placeholder = @"如：深圳市高新科技园北区，深南大道10000号";
    _addressTF.delegate = self;
    _addressTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addressTF.returnKeyType = UIReturnKeyNext;
    _addressTF.text = self.currentAddr;
    [bgView addSubview:_addressTF];
    [_addressTF release];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 290, 1)];
    line.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.6];
    [bgView addSubview:line];
    
    _nameTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 49, 270, 25)];
    _nameTF.placeholder = @"如：张三";
    _nameTF.delegate = self;
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTF.returnKeyType = UIReturnKeyDone;
    _nameTF.text = self.name;
    [bgView addSubview:_nameTF];
    [_nameTF release];
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:self.currentAddr ? @"更新收件人地址" : @"添加收件人地址" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_pressing"] forState:UIControlStateHighlighted];
    if (self.currentAddr)
    {
        [verifycontactBtn addTarget:self action:@selector(updateAddrClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [verifycontactBtn addTarget:self action:@selector(insertAddrClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    verifycontactBtn.frame = CGRectMake(10, bgView.frame.origin.y + bgView.frame.size.height + 20, 300, 40);
    [self.view addSubview:verifycontactBtn];

}

- (void)updateAddrClick:(id)sender
{
    if (self.addressId != nil && _addressTF.text.length > 0)
    {
        [self requestUpdateAddress];
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"无法更新"];
    }
}

- (void)insertAddrClick:(id)sender
{
    if (_addressTF.text.length > 0 && _nameTF.text.length > 0)
    {
        [self requestInsertAddress];
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"请输入详细地址和收件人姓名"];
    }
}

- (void)requestInsertAddress
{
    [_dialog showProgress:self withLabel:@"正在请求中..."];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"DYB", @"province",@"DYB", @"city",@"DYB", @"region",_addressTF.text, @"street", @"DYB", @"post",_nameTF.text, @"name", nil];
    NSData *aesData= [dict JSONData];
    
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=insertAddress", kServerUrl]];
    
    [_reqInsertAddr cancel];
    [self setReqInsertAddr:[ASIFormDataRequest requestWithURL:url]];
    [_reqInsertAddr setPostValue:requestStr forKey:kRequestRes];
    [_reqInsertAddr setUserInfo:[NSDictionary dictionaryWithObject:@"insertAddress" forKey:kRequestKey]];
    [_reqInsertAddr setDelegate:self];
    [_reqInsertAddr startAsynchronous];
}

- (void)requestUpdateAddress
{
    [_dialog showProgress:self withLabel:@"正在请求中..."];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_addressTF.text, @"street", _nameTF.text, @"name", self.addressId, @"addressId", nil];
    NSData *aesData= [dict JSONData];
    
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=updateAddress", kServerUrl]];
    
    [_reqInsertAddr cancel];
    [self setReqInsertAddr:[ASIFormDataRequest requestWithURL:url]];
    [_reqInsertAddr setPostValue:requestStr forKey:kRequestRes];
    [_reqInsertAddr setUserInfo:[NSDictionary dictionaryWithObject:@"updateAddress" forKey:kRequestKey]];
    [_reqInsertAddr setDelegate:self];
    [_reqInsertAddr startAsynchronous];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
