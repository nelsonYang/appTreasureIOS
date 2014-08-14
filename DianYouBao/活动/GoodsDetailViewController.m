//
//  GoodsDetailViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "WLViewPager.h"
#import "UIButton+WebCache.h"
#import "FGalleryViewController.h"

@interface GoodsDetailViewController ()<WLViewPagerDelegate, FGalleryViewControllerDelegate>
{
    Dialog *_dialog;
    UIButton *_joinBtn;
    NSDictionary *_goodsDetailDict;
    FGalleryViewController *_galleryVC;
}

@property (nonatomic, retain) ASIFormDataRequest *reqGoodsDetail;
@property (nonatomic, retain) ASIFormDataRequest *reqJoinAct;
@property (nonatomic, retain) NSMutableArray *imagesArray;

@end

@implementation GoodsDetailViewController

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
    _goodsDetailDict = [[NSDictionary alloc] init];
    _imagesArray = [[NSMutableArray alloc] init];
    [self requestGoodsDetailInfo];
}

- (void)dealloc
{
    SAFE_RELEASE(_imagesArray);
    SAFE_RELEASE(_goodsDetailDict);
    SAFE_RELEASE(_dialog);
    ASI_SAFE_RELEASE(_reqGoodsDetail);
    ASI_SAFE_RELEASE(_reqJoinAct)
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
    
    if ([requestType isEqualToString:@"inquireProudctById"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            _goodsDetailDict = [dataDetailDict retain];
            [self initViewWithDict:dataDetailDict];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
    }
    else if([requestType isEqualToString:@"insertEventQualification"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [_joinBtn setTitle:@"预约成功" forState:UIControlStateNormal];
            [_joinBtn setEnabled:NO];
            [ALToastView toastInView:self.view withText:@"恭喜您，成功预约了！"];
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
#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
	return [_imagesArray count];
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption = [_imagesArray objectAtIndex:index];
    
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [_imagesArray objectAtIndex:index];
}


#pragma mark PrivateFunc

- (void)requestGoodsDetailInfo
{
    [_dialog showProgress:self withLabel:@"数据加载中..."];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.goodsID, @"productId", nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireProudctById", kServerUrl]];
    
    [_reqGoodsDetail cancel];
    [self setReqGoodsDetail:[ASIFormDataRequest requestWithURL:url]];
    [_reqGoodsDetail setPostValue:requestStr forKey:kRequestRes];
    [_reqGoodsDetail setUserInfo:[NSDictionary dictionaryWithObject:@"inquireProudctById" forKey:kRequestKey]];
    [_reqGoodsDetail setDelegate:self];
    [_reqGoodsDetail startAsynchronous];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagesClick:(id)sender
{
    //NSLog(@"%@", _goodsDetailDict);

    for (NSDictionary *dcit in [_goodsDetailDict objectForKey:@"images"])
    {
        if ([[dcit objectForKey:@"type"] intValue] == 3)
        {
            [_imagesArray addObject:[dcit objectForKey:@"mageURL"]];
        }
    }
    if (_imagesArray.count > 0)
    {
        _galleryVC = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:_galleryVC animated:YES];
        [_galleryVC release];
    }
}

- (void)initViewWithDict:(NSDictionary *)dict
{
    UIScrollView *scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44)];
    [self.view addSubview:scorllView];
    if (!iPhone5) {
        scorllView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 20);
    }
    
    UIButton *detailImage = [UIButton buttonWithType:UIButtonTypeCustom];
    detailImage.frame = CGRectMake(0, 0, 320, 192);
    NSArray *images = [dict objectForKey:@"images"];
    NSString *url = nil;
    if (images.count > 1)
    {
        NSDictionary *dictionary = [images objectAtIndex:1];
        url = [dictionary objectForKey:@"mageURL"];
    }
    [detailImage addTarget:self action:@selector(imagesClick:) forControlEvents:UIControlEventTouchUpInside];
    [detailImage setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_default_big.jpg"]];
    [scorllView addSubview:detailImage];
    
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
    NSString *leftStr = [NSString stringWithFormat:@"<font size=16 color=black>库存:</font><font size=16 color=black>%@份</font>" , [dict objectForKey:@"productNum"]];
    NSString *orderStatusStr = [NSString stringWithFormat:@"<font size=16 color=black>预约情况:</font><font size=16 color=black>%@</font><font size=13 color=#939393></font>" , [[dict objectForKey:@"qualificationCount"] boolValue] ? @"已预约":@"未预约"];
    NSString *orderExchageStatus = nil;
    if ([[dict objectForKey:@"orderStatus"] intValue] == 1)
    {
        orderExchageStatus = [NSString stringWithFormat:@"<font size=16 color=black>兑换情况:</font><font size=16 color=#939393>已兑换</font>"];
    }
    else
    {
        orderExchageStatus = [NSString stringWithFormat:@"<font size=16 color=black>兑换情况:</font><font size=16 color=#939393>未兑换</font>"];
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
    
    UILabel *postLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, orderExchangeLabel.frame.size.height+orderExchangeLabel.frame.origin.y + 5, kScreenWidth, 15)];
    postLabel.text = @"亲~包邮哦！";
    [scorllView addSubview:postLabel];
    [postLabel release];
    
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, postLabel.frame.size.height+postLabel.frame.origin.y + 10, kScreenWidth, 1)];
    lineLabel1.backgroundColor = [UIColor lightGrayColor];
    [scorllView addSubview:lineLabel1];
    [lineLabel1 release];
    
    _joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _joinBtn.frame = CGRectMake(40, lineLabel1.frame.origin.y + 15, 240, 40);
    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_normal"] forState:UIControlStateNormal];
    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_pink_pressing"] forState:UIControlStateHighlighted];
    [_joinBtn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
    [scorllView addSubview:_joinBtn];
    
    if([[dict objectForKey:@"productNum"] intValue] < 1)
    {
        [_joinBtn setTitle:@"预约名额没有了" forState:UIControlStateNormal];
        [_joinBtn setEnabled:NO];
    }
    else if ([[dict objectForKey:@"qualificationCount"] boolValue])
    {
        [_joinBtn setTitle:@"已经预约" forState:UIControlStateNormal];
        [_joinBtn setEnabled:NO];
    }
    else
    {
        [_joinBtn setTitle:@"马上预约" forState:UIControlStateNormal];
    }
    
}

- (void)orderClick:(id)sender
{
    if([[_goodsDetailDict objectForKey:@"productNum"] intValue] < 1)
    {
        [ALToastView toastInView:self.view withText:@"已经预约完毕了，请等待下一次活动"];
    }
    else if (self.goodsID)
    {
        [self requestJoinActivity];
    }
    else
    {
        [ALToastView toastInView:self.view withText:@"初始化失败"];
    }
}

- (void)requestJoinActivity
{
    [_dialog showProgress:self withLabel:@"预约中..."];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.goodsID, @"productId", nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=insertEventQualification", kServerUrl]];
    
    [_reqJoinAct cancel];
    [self setReqJoinAct:[ASIFormDataRequest requestWithURL:url]];
    [_reqJoinAct setPostValue:requestStr forKey:kRequestRes];
    [_reqJoinAct setUserInfo:[NSDictionary dictionaryWithObject:@"insertEventQualification" forKey:kRequestKey]];
    [_reqJoinAct setDelegate:self];
    [_reqJoinAct startAsynchronous];
}

@end
