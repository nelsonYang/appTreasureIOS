//
//  CommonParam.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "CommonParam.h"
#import "Reachability.h"
#import "AppDelegate.h"

@interface CommonParam()

@property (nonatomic, retain) ASIFormDataRequest *reqUserInfo;
@property (nonatomic, retain) ASIFormDataRequest *reqSessionAndKey;

@end

@implementation CommonParam

static CommonParam *instance;

+ (CommonParam *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CommonParam alloc] init];
    });
    
    return instance;
}

- (void)dealloc
{
    ASI_SAFE_RELEASE(_reqUserInfo);
    ASI_SAFE_RELEASE(_reqSessionAndKey);
    
    SAFE_RELEASE(_uuid);
    SAFE_RELEASE(_key);
    SAFE_RELEASE(_session);
    SAFE_RELEASE(_password);
    SAFE_RELEASE(_userInfo);
    
    [super dealloc];
}

- (NSString *)getMobileBrand
{
    return [UIDevice currentDevice].model;
}

- (NSString *)getWeiLeVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}

- (NSString *)getMobilePlatform
{
    return @"0"; // 0 iOS  1 android;
}

- (NSNumber *)getNetworkType
{
    int networkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    //微乐平台协议 0：wifi  1:蜂窝  2：无网络
	if(networkStatus == 2)
    {
        return [NSNumber numberWithInt:0];
    }
    else if(networkStatus == 1)
    {
        return [NSNumber numberWithInt:1];
    }
    else
    {
        return [NSNumber numberWithInt:2];
    }
}

- (NSNumber *)getChannel
{
    return [NSNumber numberWithInt:0];  //0 apple store 1 91市场
}

- (NSString *)getDeviceVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}

- (int)calualteBalance
{
    if (self.userInfo == nil)
    {
        return 0.0;
    }
    else
    {
        double totalBalance = 0.0;
       /* for (NSDictionary *dict in [self.userInfo objectForKey:@"accountDetailList"]) {
            int balance = [[dict objectForKey:@"balance"] intValue];
            totalBalance += balance;
        }*/
        totalBalance = [[self.userInfo objectForKey:@"balance"] intValue];
        return totalBalance;
    }
}
- (int) getReommandBalance
{
    if(self.userInfo == nil){
        return 0.0;
    }else{
    
         return [[self.userInfo objectForKey:@"recommandBalance"] intValue];
    }
}

- (void)responseCodeProcess:(int)responseCode taostViewController:(UIViewController *)controller
{
    switch (responseCode) {
        case 0:
            [ALToastView toastInView:controller.view withText:@"成功！"];
            break;

        case 9000://session过期
        {
            if (self.uuid != nil && self.password != nil)
            {
                [self requestSessionOrKeyWhenThemUnvailavle];
            }
            else
            {
                [ALToastView toastInView:controller.view withText:@"数据初始化失败，请重新登录"];
            }
        }
        break;
        case 9006://获取认证KEY失败
        {
            if (self.uuid != nil && self.password != nil)
            {
                [self requestSessionOrKeyWhenThemUnvailavle];
            }
            else
            {
                [ALToastView toastInView:controller.view withText:@"数据初始化失败，请重新登录"];
            }
        }
        break;
        case 9004: //参数错误
        {
            
        }
        break;
        case 9008://用户不存在
            [ALToastView toastInView:controller.view withText:@"用户不存在！"];
            break;

        case 9021://解密失败
        {

        }
            break;
        case 9018:
            [ALToastView toastInView:controller.view withText:@"旧密码错误"];
            break;
        default:
            [ALToastView toastInView:controller.view withText:@"未知错误请联系客服！"];
            break;
    }
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
    

    if ([requestType isEqualToString:@"inquireUserInfo"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            [CommonParam sharedInstance].userInfo = dataDetailDict;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReqUserInfoDidFinish object:dataDetailDict];
        }
    }
    else if ([requestType isEqualToString:@"requestSessionAndKey"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            [CommonParam sharedInstance].session = [dataDetailDict objectForKey:@"session"];
            [CommonParam sharedInstance].key = [dataDetailDict objectForKey:@"key"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReqSessionAndKeyDidFinish object:dataDetailDict];
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

- (void)requestSessionOrKeyWhenThemUnvailavle
{
    NSDictionary *dataDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].uuid, @"userName", [CommonParam sharedInstance].password, @"password",nil];
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:dataDict, kDataReq, kMd5Req,kEncryptTypeReq, nil];
    
    NSString *requestStr = [reqDict JSONString];
    NSString *signMD5 = [requestStr MD5];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=login&sign=%@", kServerUrl, signMD5]];
    
    [_reqSessionAndKey cancel];
    [self setReqSessionAndKey:[ASIFormDataRequest requestWithURL:url]];
    [_reqSessionAndKey setPostValue:requestStr forKey:kRequestRes];
    [_reqSessionAndKey setUserInfo:[NSDictionary dictionaryWithObject:@"requestSessionAndKey" forKey:kRequestKey]];
    [_reqSessionAndKey setDelegate:self];
    [_reqSessionAndKey startAsynchronous];
}

- (void)requestUserInfo
{
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireUserInfo", kServerUrl]];
    
    [_reqUserInfo cancel];
    [self setReqUserInfo:[ASIFormDataRequest requestWithURL:url]];
    [_reqUserInfo setPostValue:requestStr forKey:kRequestRes];
    [_reqUserInfo setUserInfo:[NSDictionary dictionaryWithObject:@"inquireUserInfo" forKey:kRequestKey]];
    [_reqUserInfo setDelegate:self];
    [_reqUserInfo startAsynchronous];
}

@end
