//
//  FeedbackViewController.m
//  WeiLe
//
//  Created by linger on 09/08/13.
//  Copyright (c) 2013年 Fujian Yidinghuo Network Technology Co; ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "FeedbackViewController.h"
#import "ALToastView.h"
#import "JSONKit.h"
#import "CommonParam.h"
#import "Encryption.h"
#import "Base64.h"

#import "TransformData.h"
#import "UIButton+WebCache.h"
#import "NSString+FontHeight.h"
#import "ASIFormDataRequest.h"
#import "Dialog.h"
#import "ConverCD.h"


@interface FeedbackViewController ()<UITextViewDelegate>
{
    Dialog *_dialog;
    UIButton *_keyBordbtn;
    UITextView  *_textView;
}

@property (nonatomic, retain)ASIFormDataRequest *requestFeedBack;

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dialog = [[Dialog alloc] init];
    
    UIView *textBgView = [[UIView alloc]initWithFrame:CGRectMake(10,55, 300, 110)];
    textBgView.layer.cornerRadius = 5.0;
    textBgView.backgroundColor = [UIColor colorWithRed:252.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    textBgView.layer.shadowOffset = CGSizeMake(0,2);
    textBgView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    textBgView.layer.shadowRadius = 5.0;
    textBgView.layer.shadowOpacity = 0.5;
    textBgView.layer.shadowPath = [UIBezierPath bezierPathWithRect:textBgView.bounds].CGPath;
    [self.view addSubview:textBgView];
    [textBgView release];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, 100)];
    _textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    _textView.font = [UIFont systemFontOfSize:14.0];//设置字体名字和字体大小
    _textView.delegate = self;//设置它的委托方法
    _textView.text = @"请对您对我们的反馈，感谢您的一路相伴！";
    _textView.textColor = [UIColor grayColor];
    _textView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    _textView.returnKeyType = UIReturnKeyDone;//返回键的类型
    _textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    _textView.scrollEnabled = YES;//是否可以拖动
    [textBgView addSubview:_textView];
    [_textView release];
    
    UIImage *red_default_img = [UIImage imageNamed:@"btn_login_pink_long_normal"];
    UIImage *red_select_img = [UIImage imageNamed:@"btn_login_pink_long_pressing"];
    UIEdgeInsets _edge = UIEdgeInsetsMake(20, 10, 20, 10);
    red_default_img = [ConverCD resizeImageWithCapInsets:_edge with:red_default_img];
    red_select_img = [ConverCD resizeImageWithCapInsets:_edge with:red_select_img];
    
    UIButton *evaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    evaluationBtn.frame = CGRectMake(10, 200, 300, 44);
    evaluationBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [evaluationBtn setTitle:@"发送" forState:UIControlStateNormal];
    [evaluationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [evaluationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [evaluationBtn setBackgroundImage:red_default_img forState:UIControlStateNormal];
    [evaluationBtn setBackgroundImage:red_select_img forState:UIControlStateHighlighted];
    [evaluationBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:evaluationBtn];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(textViewbecomeFirstResponder) withObject:nil afterDelay:0.5];
}
-(void)textViewbecomeFirstResponder
{
    [_textView becomeFirstResponder];
}

- (void)dealloc
{
    [_requestFeedBack setDelegate:nil];
    [_requestFeedBack cancel];
    [_requestFeedBack release];
  
    SAFE_RELEASE(_dialog);

    [super dealloc];
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
    if ([requestType isEqualToString:@"insertFeedback"])
    {
        int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
        NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
        ////WLLog(@"dataDetailDict =  %@", dataDetailDict);
        if ([[dataDetailDict objectForKey:kResultCodeRes] integerValue] == 0)
        {
            _textView.text = @"请对您对我们的反馈，感谢您的一路相伴！";
            _textView.textColor = [UIColor grayColor];
            [ALToastView toastInView:self.view withText:@"感谢您的反馈"];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [self performSelector:@selector(AutoBackAction) withObject:nil afterDelay:1.0];
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
    [_dialog hideProgress];
        if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark PrivateFunc

- (void)submitClick:(id)sender
{
    [_textView resignFirstResponder];
    if ([_textView.text length] > 0 && _textView.textColor == [UIColor blackColor])
    {
        [self feedbackRequest];
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"请输入反馈内容"];
    }
}
-(void)AutoBackAction
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)feedbackRequest
{
    [_dialog showProgress:self withLabel:@"正在请求中..."];
    NSString *modle = [CommonParam sharedInstance].getMobileBrand;
    NSString *version = [CommonParam sharedInstance].getDeviceVersion;
    NSString *sendStr = [NSString stringWithFormat:@"%@\n【该用户设备:%@】\n【该用户设备系统版本:%@】", _textView.text, modle, version];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:sendStr, @"content", nil];
    NSData *aesData= [dict JSONData];
    
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=insertFeedback", kServerUrl]];
    
    [_requestFeedBack cancel];
    [self setRequestFeedBack:[ASIFormDataRequest requestWithURL:url]];
    [_requestFeedBack setPostValue:requestStr forKey:kRequestRes];
    [_requestFeedBack setUserInfo:[NSDictionary dictionaryWithObject:@"insertFeedback" forKey:kRequestKey]];
    [_requestFeedBack setDelegate:self];
    [_requestFeedBack startAsynchronous];
}
#pragma mark  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_textView.textColor == [UIColor grayColor])
    {
        _textView.text = nil;
        _textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        if (_textView.text.length==0) {
            _textView.text = @"请对您对我们的反馈，感谢您的一路相伴！";
            _textView.textColor = [UIColor grayColor];
        }
        return NO;
    }
    return YES;
}

#pragma mark touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    if (_textView.text.length==0) {
        _textView.text = @"请对您对我们的反馈，感谢您的一路相伴！";
        _textView.textColor = [UIColor grayColor];
    }
}


@end
