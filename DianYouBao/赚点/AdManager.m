//
//  AdManager.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AdManager.h"
#import "AppDelegate.h"
#import "ZhuanDianViewController.h"

@interface AdManager()

@property (nonatomic, retain) ASIFormDataRequest *reqUploadDuoMengScore;
@property (nonatomic, retain) ASIFormDataRequest *reqConsumeDuoMengScore;

@end

@implementation AdManager

static AdManager *instance;

+ (AdManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AdManager alloc] init];
    });
    
    return instance;
}

- (void)dealloc
{
    ASI_SAFE_RELEASE(_reqUploadDuoMengScore);
    ASI_SAFE_RELEASE(_reqConsumeDuoMengScore);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma markPrivateFunc

- (void)reqUploadScore
{
    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDel.zhuanDianVC getDMScore];
}

- (void)requestConsumeDMScore:(int)Vaule gid:(NSString *)gid orderId:(NSString *)orderId
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:orderId, @"eventQualificationId", gid, @"productId", @"1", @"num",nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireConsumeChannelByProduct", kServerUrl]];
    
    [_reqConsumeDuoMengScore cancel];
    [self setReqConsumeDuoMengScore:[ASIFormDataRequest requestWithURL:url]];
    [_reqConsumeDuoMengScore setPostValue:requestStr forKey:kRequestRes];
    [_reqConsumeDuoMengScore setUserInfo:[NSDictionary dictionaryWithObject:@"inquireConsumeChannelByProduct" forKey:kRequestKey]];
    [_reqConsumeDuoMengScore setDelegate:self];
    [_reqConsumeDuoMengScore startAsynchronous];
}

#pragma mark DianRuDelegate

- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed
{
    //WLLog(@"获取多盟点数= %d", totalPoint);
    [self requestUploadDuoMengScore:totalPoint - consumed];
}


- (void)requestUploadDuoMengScore:(int)score
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Channel_Type_DuoMeng], @"channel", [NSNumber numberWithInt:score],@"rewardAmount",nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=insertGold", kServerUrl]];
    
    [_reqUploadDuoMengScore cancel];
    [self setReqUploadDuoMengScore:[ASIFormDataRequest requestWithURL:url]];
    [_reqUploadDuoMengScore setPostValue:requestStr forKey:kRequestRes];
    [_reqUploadDuoMengScore setUserInfo:[NSDictionary dictionaryWithObject:@"reqDuoMeng" forKey:kRequestKey]];
    [_reqUploadDuoMengScore setDelegate:self];
    [_reqUploadDuoMengScore startAsynchronous];
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
    if ([requestType isEqualToString:@"reqDuoMeng"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            //WLLog(@"reqDuoMeng:上传成功");
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

#pragma mark ConsumeResult
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyConsumedSuccess object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:totalPoint], @"totalPoint",[NSNumber numberWithInt:consumed], @"consumed", nil]];
}
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyConsumedFailed object:error];
}

@end
