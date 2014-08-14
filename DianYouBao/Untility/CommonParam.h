//
//  CommonParam.h
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-11.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonParam : NSObject

@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *session;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, retain) NSDictionary *userInfo;

+ (CommonParam *)sharedInstance;
- (NSString *)getMobileBrand;
- (NSString *)getWeiLeVersion;
- (NSString *)getMobilePlatform;
- (NSNumber *)getNetworkType;
- (NSNumber *)getChannel;
- (NSString *)getDeviceVersion;
- (BOOL)isJailbroken;
- (int)calualteBalance;
- (int) getReommandBalance;
- (void)responseCodeProcess:(int)responseCode taostViewController:(UIViewController *)controller;
- (void)requestUserInfo;
- (void)requestSessionOrKeyWhenThemUnvailavle;


@end
