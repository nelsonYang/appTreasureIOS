//
//  ViewController.h
//  DianZhuanBao
//
//  Created by 林 贤辉 on 14-1-9.
//  Copyright (c) 2014年 linger. All rights reserved.
//


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
#import "AdManager.h"
#import "DMVideoViewController.h"

typedef enum
{
    Channel_Type_DianRu = 2,
    Channel_Type_YouMi = 3,
    Channel_Type_YiJiFen = 4,
    Channel_Type_DuoMeng = 5,
    Channel_Type_LiMei = 6,
    Channel_Type_MiDi = 7
} Channel_Type;

@interface ZhuanDianViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *toolbar;
@property (nonatomic, retain) DMOfferWallViewController *offerWallController;
@property (nonatomic, retain) DMVideoViewController *videoController;
@property (nonatomic, retain) DMOfferWallManager *dmManager;
@property (nonatomic, retain) immobView *liMeiAdWall;

- (void)getDMScore;
- (void)spendDMScore:(int)value;

@end
