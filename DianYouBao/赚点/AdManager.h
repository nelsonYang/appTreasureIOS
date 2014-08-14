//
//  AdManager.h
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonParam.h"

#import "DianRuAdWall.h"

#import "YouMiWall.h"
#import "YouMiPointsManager.h"

#import <Escore/YJFIntegralWall.h>
#import<Escore/YJFScore.h>

#import "DMOfferWallViewController.h"
#import "DMOfferWallManager.h"

#import <immobSDK/immobView.h>

#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "MiidiManager.h"
#import "MiidiAdWall.h"

#import "DianRuAdWall.h"

#import "YouMiConfig.h"
#import "YouMiPointsManager.h"
#import "YouMiWall.h"

#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>

@protocol AdManager <NSObject>

- (void)requestScoreDidFinish:(NSInteger)score;

@end

@interface AdManager : NSObject<DianRuAdWallDelegate, YJFIntegralWallDelegate, DMOfferWallManagerDelegate, immobViewDelegate, MiidiAdWallShowAppOffersDelegate
                    , MiidiAdWallAwardPointsDelegate
                    , MiidiAdWallSpendPointsDelegate
                    , MiidiAdWallGetPointsDelegate
                    , MiidiAdWallRequestToggleDelegate>

+ (AdManager *)sharedInstance;
- (void)reqUploadScore;
- (void)requestConsumeDMScore:(int)Vaule gid:(NSString *)gid orderId:(NSString *)orderId;

@end
