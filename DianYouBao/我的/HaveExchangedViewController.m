//
//  HaveExchangedViewController.m
//  DianYouBao
//
//  Created by linger on 15/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "HaveExchangedViewController.h"

@interface HaveExchangedViewController ()
{
    Dialog *_dialog;
}

@property (nonatomic, retain) ASIFormDataRequest *reqEventQualificationId;

@end

@implementation HaveExchangedViewController

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
    [self requestGoodsDetailInfo];
}

- (void)dealloc
{
    ASI_SAFE_RELEASE(_reqEventQualificationId);
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
    
    if ([requestType isEqualToString:@"inquireEventQualificationById"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            [self initViewWithDict:dataDetailDict];
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

#pragma mark PrivateFunc

- (void)initViewWithDict:(NSDictionary *)dict
{
    UIScrollView *scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    [self.view addSubview:scorllView];
    if (!iPhone5) {
        scorllView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 20);
    }
    
    UIImageView *detailImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 192)];
    [scorllView addSubview:detailImage];
    NSArray *images = [dict objectForKey:@"images"];
    NSString *url = nil;
    if (images.count > 2)
    {
        NSDictionary *dictionary = [images objectAtIndex:2];
        url = [dictionary objectForKey:@"mageURL"];
    }
    [detailImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_default_big.jpg"]];
    [detailImage release];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, detailImage.frame.origin.y + detailImage.frame.size.height + 5, 300, 40)];
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.text = [dict objectForKey:@"productDesc"];
    desLabel.numberOfLines = 2;
    desLabel.font = [UIFont systemFontOfSize:14];
    [scorllView addSubview:desLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, desLabel.frame.size.height+desLabel.frame.origin.y, kScreenWidth, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [scorllView addSubview:lineLabel];
    [lineLabel release];
    
    NSString *marketPriceStr =  [NSString stringWithFormat:@"<font size=16 color=black>市场价:</font><font size=16 color=red>%@元</font>" , [dict objectForKey:@"price"]];
    NSString *integrationStr = [NSString stringWithFormat:@"<font size=16 color=black>兑换价:</font><font size=16 color=red>%@点币</font>" , [dict objectForKey:@"integration"]];
    NSString *leftStr = [NSString stringWithFormat:@"<font size=16 color=black>剩余:</font><font size=16 color=black>%@份</font>" , [dict objectForKey:@"productNum"]];
    NSString *orderStatusStr = [NSString stringWithFormat:@"<font size=16 color=black>预约情况:</font><font size=16 color=black>已预约</font><font size=13 color=#939393></font>"];
    NSString *orderExchageStatus = nil;
    if ([[dict objectForKey:@"orderStatus"] intValue] == 1)
    {
        orderExchageStatus = [NSString stringWithFormat:@"<font size=16 color=black>兑换情况:</font><font size=16 color=#939393>已兑换</font>"];
    }
    else
    {
        orderExchageStatus = [NSString stringWithFormat:@"<font size=16 color=black>兑换情况:</font><font size=16 color=#939393>已兑换</font>"];
    }
    
    RTLabel *markLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, lineLabel.frame.origin.y + 10, 300, 20)];
    markLabel.backgroundColor = [UIColor clearColor];
    markLabel.text = marketPriceStr;
    [scorllView addSubview:markLabel];
    [markLabel release];
    
    RTLabel *integrationLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, markLabel.frame.origin.y + markLabel.frame.size.height + 5, 300, 20)];
    integrationLabel.backgroundColor = [UIColor clearColor];
    integrationLabel.text = integrationStr;
    [scorllView addSubview:integrationLabel];
    [integrationLabel release];
    
    RTLabel *leftLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, integrationLabel.frame.origin.y + integrationLabel.frame.size.height + 5, 300, 20)];
    leftLabel.backgroundColor = [UIColor clearColor];
    leftLabel.text = leftStr;
    [scorllView addSubview:leftLabel];
    [leftLabel release];
    
    RTLabel *orderStatusLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, leftLabel.frame.origin.y + leftLabel.frame.size.height + 5, 300, 20)];
    orderStatusLabel.backgroundColor = [UIColor clearColor];
    orderStatusLabel.text = orderStatusStr;
    [scorllView addSubview:orderStatusLabel];
    [orderStatusLabel release];
    
    RTLabel *orderExchangeLabel = [[RTLabel alloc] initWithFrame:CGRectMake(10, orderStatusLabel.frame.origin.y + orderStatusLabel.frame.size.height + 5, 300, 20)];
    orderExchangeLabel.backgroundColor = [UIColor clearColor];
    orderExchangeLabel.text = orderExchageStatus;
    [scorllView addSubview:orderExchangeLabel];
    [orderExchangeLabel release];
    
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, orderExchangeLabel.frame.size.height+orderExchangeLabel.frame.origin.y + 10, kScreenWidth, 1)];
    lineLabel1.backgroundColor = [UIColor lightGrayColor];
    [scorllView addSubview:lineLabel1];
    [lineLabel1 release];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame = CGRectMake(40, lineLabel1.frame.origin.y + 15, 240, 40);
    [joinBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
//    [joinBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
//    [joinBtn addTarget:self action:@selector(exchangeClick:) forControlEvents:UIControlEventTouchUpInside];
    [scorllView addSubview:joinBtn];
    [joinBtn setTitle:@"亲，我们会尽快发货的！~" forState:UIControlStateNormal];
    
}


- (void)requestGoodsDetailInfo
{
    [_dialog showProgress:self withLabel:@"数据加载中..."];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.eventQualificationId, @"eventQualificationId", nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireEventQualificationById", kServerUrl]];
    
    [_reqEventQualificationId cancel];
    [self setReqEventQualificationId:[ASIFormDataRequest requestWithURL:url]];
    [_reqEventQualificationId setPostValue:requestStr forKey:kRequestRes];
    [_reqEventQualificationId setUserInfo:[NSDictionary dictionaryWithObject:@"inquireEventQualificationById" forKey:kRequestKey]];
    [_reqEventQualificationId setDelegate:self];
    [_reqEventQualificationId startAsynchronous];
}

@end
