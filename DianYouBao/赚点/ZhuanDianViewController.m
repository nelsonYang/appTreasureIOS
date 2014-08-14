//
//  ViewController.m
//  DianZhuanBao
//
//  Created by 林 贤辉 on 14-1-9.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "ZhuanDianViewController.h"
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

#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>


@interface ZhuanDianViewController ()<DianRuAdWallDelegate, YJFIntegralWallDelegate, DMOfferWallManagerDelegate, immobViewDelegate, MiidiAdWallShowAppOffersDelegate
                        , MiidiAdWallAwardPointsDelegate
                        , MiidiAdWallSpendPointsDelegate
                        , MiidiAdWallGetPointsDelegate
                        , MiidiAdWallRequestToggleDelegate
                        ,UITableViewDataSource
                        ,UITableViewDelegate
                        ,MFMessageComposeViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation ZhuanDianViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"赚钱";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"lab_icon_earn_pressing"] withFinishedUnselectedImage:[UIImage imageNamed:@"lab_icon_earn_normal"]];
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!iPhone5)
    {
        self.toolbar.frame = CGRectMake(0, 0, 320, 130);
    }
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"earn_icon_invite_friends"], @"icon", @"邀请朋友加入", @"title",@"", @"subTitle", nil];
//    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"赚点A区",@"title",@"点入平台，量大实惠，下一个应用，可以换取一天话费哟！", @"subTitle", nil];
//    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"赚点B区", @"title", @"有米平台，量大实惠，下一个应用，可以换取一天话费哟！", @"subTitle", nil];
//    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"赚点C区", @"title",@"易积分平台，量大实惠，下一个应用，可以换取一天话费哟！", @"subTitle", nil];
    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"earn_icon_earn_point"], @"icon", @"赚点A区", @"title",@"量大实惠！", @"subTitle", nil];
    NSDictionary *dict41 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"earn_icon_earn_point"], @"icon", @"赚点B区", @"title",@"插屏积分！", @"subTitle", nil];
    NSDictionary *dict42 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"earn_icon_earn_point"], @"icon", @"赚点C区", @"title",@"视频积分！", @"subTitle", nil];
//    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"赚点E区", @"title", @"力美平台，量大实惠，下一个应用，可以换取一天话费哟！", @"subTitle",nil];
//    NSDictionary *dict6 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"赚点F区",@"title", @"米迪平台,量大实惠，下一个应用，可以换取一天话费哟！", @"subTitle",nil];
    [self.dataArray addObject:dict0];
//    [self.dataArray addObject:dict1];
//    [self.dataArray addObject:dict2];
//    [self.dataArray addObject:dict3];
    [self.dataArray addObject:dict4];
    [self.dataArray addObject:dict41];
    [self.dataArray addObject:dict42];
//    [self.dataArray addObject:dict5];
//    [self.dataArray addObject:dict6];
    
    [self initWithCustomView];
//    [DianRuAdWall beforehandAdWallWithDianRuAppKey:@"0000DE11100000AA"];
//    [DianRuAdWall initAdWallWithDianRuAdWallDelegate:[AdManager sharedInstance]];
//    
//    [YouMiConfig launchWithAppID:@"bf5bca63ad8b4b49" appSecret:@"370d91f4c7e027ed"];
//    // 开启积分管理[本例子使用自动管理];
//    [YouMiPointsManager enableManually];
//    // 开启积分墙
//    [YouMiWall enable];
//    //YES 禁止主动向服务器请求
//    [YouMiPointsManager setManualCheck:YES];
//    
//    //开发者
//    [YJFUserMessage shareInstance].yjfUserAppId =@"14375";
//    [YJFUserMessage shareInstance].yjfUserDevId =@"17588";
//    [YJFUserMessage shareInstance].yjfAppKey =@"EM0LFKZ3G29DR7OY2PF8VTGSKXJR3XX8Y0";
//    [YJFUserMessage shareInstance].yjfChannel =@"IOS1.2.4";
//    
//    //初始化
//    YJFInitServer *InitData  = [[YJFInitServer alloc]init];
//    [InitData  getInitEscoreData];
//    [InitData  release];
    
    
//    if (!self.liMeiAdWall)
//    {
//        self.liMeiAdWall=[[immobView alloc] initWithAdUnitID:@"1a26c7527ac4e9f0b0d2f94b07ec2a6c"];
//        self.liMeiAdWall.delegate = [AdManager sharedInstance];
//        [self.liMeiAdWall.UserAttribute setObject:[CommonParam sharedInstance].uuid forKey:@"accountname"];
//        [self.liMeiAdWall immobViewRequest];
//        [self.view addSubview:self.liMeiAdWall];
//    }
//
//    
//    [MiidiManager setAppPublisher:@"16685" withAppSecret:@"x30cjsmc2w97yyr7" withTestMode:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(self.dataArray);
    SAFE_RELEASE(self.dmManager);
    SAFE_RELEASE(self.offerWallController);
    SAFE_RELEASE(self.liMeiAdWall);
    
    [_toolbar release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    iconView.image = [dict objectForKey:@"icon"];
    [cell.contentView addSubview:iconView];
    [iconView release];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, indexPath.row==0 ? 20: 5, 200, 25)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = [dict objectForKey:@"title"];
    textLabel.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:textLabel];
    [textLabel release];
    
    UILabel *subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 250, 25)];
    subTextLabel.backgroundColor = [UIColor clearColor];
    subTextLabel.text = [dict objectForKey:@"subTitle"];
    subTextLabel.font = [UIFont systemFontOfSize:12];
    subTextLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:subTextLabel];
    [subTextLabel release];
    
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [self showSMS];
    }
    else if (indexPath.row == 1)
    {
        [self DMClick:nil];
    }
    else if(indexPath.row == 2)
    {
        [self showChaPingAd];
    }
    else if(indexPath.row == 3)
    {
        [self showVideoAd];
    }
//    else if (indexPath.row == Channel_Type_DianRu - 1)
//    {
//        [self dianruClick:nil];
//    }
//    else if (indexPath.row == Channel_Type_YouMi - 1)
//    {
//        [self youMiClick:nil];
//    }
//    else if (indexPath.row == Channel_Type_YiJiFen - 1)
//    {
//        [self yiJiFenClick:nil];
//    }
//    else if (indexPath.row == Channel_Type_DuoMeng - 1)
//    {
//        [self DMClick:nil];
//    }
//    else if (indexPath.row == Channel_Type_LiMei- 1)
//    {
//        [self liMeiClick:nil];
//    }
//    else if (indexPath.row == Channel_Type_MiDi - 1)
//    {
//        [self midiClick:nil];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark PrivateFunc

- (void)initWithCustomView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, iPhone5 ? kScreenHeight-44 : kScreenHeight - 110) style:UITableViewStylePlain];
    tableView.backgroundColor = kViewBgColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
}

#pragma mark /************点入*************/

- (IBAction)dianruClick:(id)sender
{
    [DianRuAdWall showAdWall:self];
}

-(void)spendDianRuScore:(int)spendVaule
{
    //消费10个积分，异步方法，结果在代理中回调
    [DianRuAdWall spendPoint:spendVaule];
}

- (void)getDianRuScore
{
    //获取剩余积分，异步方法，结果在代理中进行回调
    [DianRuAdWall getRemainPoint];
}

#pragma mark 点入Delegate

/*
 用于消费积分结果的回调
 */
-(void)didReceiveSpendScoreResult:(BOOL)isSuccess
{

}

/*
 用于获取剩余积分结果的回调
 */
-(void)didReceiveGetScoreResult:(int)point
{

}

#pragma mark /************有米*************/

- (IBAction)youMiClick:(id)sender
{
    [YouMiWall showOffers:YES didShowBlock:^{
        //WLLog(@"有米积分墙已显示");
    } didDismissBlock:^{
        //WLLog(@"有米积分墙已退出");
    }];
}

- (NSUInteger)getYouMiScore
{
    return [YouMiPointsManager pointsRemained];
}

- (void)spendYouMiScore:(int)Vaule
{
    [YouMiPointsManager spendPoints:Vaule];
}

//手动获取积分
- (void)getScoreByRefresh
{
    [YouMiPointsManager checkPoints];
}

#pragma mark /************易积分*************/

- (IBAction)yiJiFenClick:(id)sender
{
    YJFIntegralWall *integralWall = [[YJFIntegralWall
                                      alloc]init];
    integralWall.delegate = self;
    [self presentViewController:integralWall animated:YES
                     completion:nil];
    [integralWall release];
}

- (void)getYjfScore
{
    [YJFScore getScore:[AdManager sharedInstance]];
}

- (void)spendYJFScore:(int)value
{
    [YJFScore consumptionScore:value delegate:self];
}

#pragma YJFIntegralWallDelegate
//获取积分1 消耗成功  0 消耗失败
-(void)getYjfScore:(int)_score  status:(int)_value unit:(NSString *) unit
{

}

//消耗积分 //1 消耗成功  0 消耗失败
-(void)consumptionYjfScore:(int)_score status:(int)_value
{

}

#pragma mark /************多盟*************/

- (IBAction)DMClick:(id)sender
{
    [self.offerWallController presentOfferWallWithViewController:self];
}

- (void)showChaPingAd
{
    if ([self.offerWallController isOfferWallInterstitialReady])
    {
        [self.offerWallController presentOfferWallInterstitial];
    }else
    {
        [ALToastView toastInView:self.view withText:@"初始化失败"];
    }
}

- (void)showVideoAd
{
    [self.videoController presentVideoAdViewWithController:self];
}

- (void)getDMScore
{
    [self.dmManager requestOnlinePointCheck];
}

- (void)spendDMScore:(int)value
{   int integeration = [[CommonParam sharedInstance] calualteBalance] - [[CommonParam sharedInstance] getReommandBalance];
    if(integeration < value){
        value = integeration;
    }
    if(value >0){
        [self.dmManager requestOnlineConsumeWithPoint:value];
    }
}

#pragma DMOfferWallManagerDelegate
// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed
{

}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
- (void)offerWallDidFailCheckPointWithError:(NSError *)error
{

}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed
{

}
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error
{

}

#pragma mark CheckOfferWall Enable Callbacks

- (void)offerWallDidCheckEnableState:(BOOL)enable
{

}


#pragma mark /************力美***********/

- (IBAction)liMeiClick:(id)sender
{
    //WLLog(@"%@", self.view.subviews);
    if (self.liMeiAdWall.isAdReady )
    {   
        [self.liMeiAdWall immobViewDisplay];
        [self.liMeiAdWall immobViewShow];
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"该渠道不能正常使用"];
    }
}

- (UIViewController *)immobViewController
{
    return self;
}


- (void)getLiMeiScore
{
    [self.liMeiAdWall immobViewQueryScoreWithAdUnitID:@"1a26c7527ac4e9f0b0d2f94b07ec2a6c" WithAccountID:[CommonParam sharedInstance].uuid];
}

- (void)spendLiMeiScore:(int)vaule
{
    [self.liMeiAdWall immobViewReduceScore:vaule WithAdUnitID:@"1a26c7527ac4e9f0b0d2f94b07ec2a6c" WithAccountID:[CommonParam sharedInstance].uuid];
}

#pragma mark immobViewDelegate
/**
 *查询积分接口回调
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message{
    
    //
    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"积分查询" message: ![message isEqualToString:@""]?[NSString stringWithFormat:@"%@",message]:[NSString stringWithFormat:@"当前积分为:%i",score]  delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [uA show];
    [uA release];
}

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message{
    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:status?@"积分减少成功":@"积分减少失败" message: status?@"":[NSString stringWithFormat:@"%@",message] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [uA show];
    [uA release];
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    
    UIAlertView *uA=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前广告不可用" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
    [uA show];
    [uA release];
    
    
    //如果想实现隐藏积分墙按钮功能，请将下面代码注释去掉
    //    if (isFirst) {
    //       adwallb.hidden=NO;
    //        isFirst=NO;
    //       }
    
    //WLLog(@"errorCode:%i",errorCode);
}

#pragma mark /**********米迪***********/

- (IBAction)midiClick:(id)sender
{
    [MiidiAdWall showAppOffers:self withDelegate:self];
}

- (void)getMiDiScore
{
    [MiidiAdWall requestGetPoints:[AdManager sharedInstance]];
}

- (void)spendMidiScore:(int)score
{
    [MiidiAdWall requestSpendPoints:score withDelegate:[AdManager sharedInstance]];
}

#pragma MiidiAdWallAwardPointsDelegate

// 请求奖励积分成功后调用
//
// 详解:当接收服务器返回的奖励积分成功后调用该函数
// 补充：totalPoints: 返回用户的总积分
- (void)didReceiveAwardPoints:(NSInteger)totalPoints
{

}

// 请求奖励积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAwardPoints:(NSError *)error
{

}

#pragma mark MiidiAdWallSpendPointsDelegate
// 请求消耗积分成功后调用
//
// 详解:当接收服务器返回的消耗积分成功后调用该函数
// 补充：totalPoints: 返回用户的总积分

- (void)didReceiveSpendPoints:(NSInteger)totalPoints
{

}

// 请求消耗积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveSpendPoints:(NSError *)error
{

}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            [ALToastView toastInView:self.view withText:@"短信取消发送"];
            break;
        case MessageComposeResultSent:
            [ALToastView toastInView:self.view withText:@"短信发送成功"];
            break;
        case MessageComposeResultFailed:
            [ALToastView toastInView:self.view withText:@"短信发送失败"];
            break;
        default:
            [ALToastView toastInView:self.view withText:@"短信发送失败"];
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}



- (void)showSMS
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            [ALToastView toastInView:self.view withText:@"设备没有短信功能"];
        }
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"iOS版本低于4.0"];
    }
}

-(void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *registerText = [NSString stringWithFormat:@"http://115.29.137.120/DianZhuan/register.html?userName=%@",[[CommonParam sharedInstance].userInfo objectForKey:@"userName"]];
    picker.body = [NSString stringWithFormat:@"欢迎下载点点赚：地址:%@   注册地址:%@",@"http://115.29.137.120/DuoMeng/dz.htm",registerText];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


@end
