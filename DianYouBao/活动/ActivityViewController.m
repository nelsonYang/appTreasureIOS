//
//  ActivityViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "ActivityViewController.h"
#import "WLTextPlayView.h"
#import "ExchangeViewController.h"
#import "GoodsDetailViewController.h"
#import "AdManager.h"
#import "UserInfoViewController.h"
#import "AppDelegate.h"
#import "ZhuanDianViewController.h"

@interface ActivityViewController ()<UITableViewDataSource, UITableViewDelegate, RefreshHeaderAndFooterViewDelegate>
{
    WLTextPlayView *_textPlay;
    NSMutableArray *_dataArray;
    
    BOOL                  reloading;
    BOOL                  refresh;
    NSInteger             _currentTweetPage;
    int                   viewH;
    RefreshHeaderAndFooterView  *refreshView;
    UITableView *_tableView;
    Dialog *_dialog;
}

@property (nonatomic, retain) ASIFormDataRequest *reqActivity;
@property (nonatomic, retain) ASIFormDataRequest *reqNotification;
@property (nonatomic, retain) ASIFormDataRequest *reqUserInfo;
@property (nonatomic, retain) ASIFormDataRequest *reqconsumeIntegration;
@property (nonatomic, retain) ASIFormDataRequest *reqUpdateQualificationStatus;
@property (nonatomic, retain) NSString *changeTag;
@property (nonatomic, retain) NSString *currentConsumeIntergration;
@property (nonatomic, retain) NSString *currentExchangeProductId;

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"兑换";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"lab_icon_activity_pressing"] withFinishedUnselectedImage:[UIImage imageNamed:@"lab_icon_activity_normal"]];
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestNotification];
    [[CommonParam sharedInstance] requestUserInfo];
    [[AdManager sharedInstance] reqUploadScore];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dialog = [[Dialog alloc] init];
    
    if (!iPhone5)
    {
        self.toolbar.frame = CGRectMake(0, 0, 320, 130);
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidFinish:) name:kReqUserInfoDidFinish object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consumeSuccess:) name:kNotifyConsumedSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(consumeFailed:) name:kNotifyConsumedFailed object:nil];
    _dataArray = [[NSMutableArray alloc] init];
    [self initWithCustomView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ASI_SAFE_RELEASE(_reqUpdateQualificationStatus);
    ASI_SAFE_RELEASE(_reqconsumeIntegration);
    SAFE_RELEASE(_dialog);
    SAFE_RELEASE(_dataArray);
    ASI_SAFE_RELEASE(_reqActivity);
    ASI_SAFE_RELEASE(_reqUserInfo);
    ASI_SAFE_RELEASE(_reqNotification);
    
    [_dianBiLabel release];
    [_toolbar release];
    [super dealloc];
}

#pragma mark UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 100, 60)];
        iconView.tag = 100;
        [cell addSubview:iconView];
        [iconView release];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 40)];
        textLabel.tag = 101;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.numberOfLines = 2;
        textLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:textLabel];
        [textLabel release];
        
        RTLabel *priceLabel = [[RTLabel alloc] initWithFrame:CGRectMake(105, 52, 180, 35)];
        priceLabel.tag = 103;
        priceLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:priceLabel];
        
        RTLabel *leftCountLabel = [[RTLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 55, 120, 35)];
        leftCountLabel.tag = 104;
        leftCountLabel.textAlignment = UITextAlignmentRight;
        leftCountLabel.backgroundColor = [UIColor clearColor];
        [cell addSubview:leftCountLabel];
    }
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    
    //qualificationCount 1 表示已经预约  0 表示未预约
    int orderValue = [[dict objectForKey:@"qualificationCount"] intValue];
    
    //productNum 表示还剩多少库存
    //totalQualificationCount 总的库存
    
    UIImageView *icon = (UIImageView *)[cell viewWithTag:100];
    NSArray *images = [dict objectForKey:@"images"];
    NSString *url = nil;
    if (images.count > 0)
    {
        url = [[images objectAtIndex:0] objectForKey:@"smallImage"];
    }
    [icon setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic_default_small.jpg"]];
    
    UILabel *desLabel = (UILabel *)[cell viewWithTag:101];
    desLabel.text = [dict objectForKey:@"productName"];
    if (orderValue == 1) {
        desLabel.textColor = [UIColor grayColor];
    }
    
    NSString *priceText =  [NSString stringWithFormat:@"<font size=16 color=red> %@分</font><font size=13 color=#939393>  价值:%@元</font>" , [dict objectForKey:@"integration"], [dict objectForKey:@"price"]];
    RTLabel *priceLabel = (RTLabel *)[cell viewWithTag:103];
    priceLabel.text = priceText;
    
    NSString *leftStr =  [NSString stringWithFormat:@"<font size=13 color=#939393>库存:</font><font size=13 color=red>%@</font>" , [dict objectForKey:@"productNum"]];
    RTLabel *leftCount = (RTLabel *)[cell viewWithTag:104];
    leftCount.text = leftStr;
    
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    GoodsDetailViewController *goodsDetailVC = [[GoodsDetailViewController alloc] initWithNibName:nil bundle:nil];
    goodsDetailVC.goodsID = [dict objectForKey:@"productId"];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView)
    {
        refreshView.hidden = NO;
        if (scrollView.contentSize.height < viewH)
        {
            refreshView.frame = CGRectMake(0, 0, 320, viewH);
        }
        else
        {
            refreshView.frame = CGRectMake(0, 0, 320, scrollView.contentSize.height);
        }
        [refreshView RefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableView)
    {
        [refreshView RefreshScrollViewDidEndDragging:scrollView];
    }
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view
{
	reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading)//下拉刷新动作的内容
    {
        //WLLog(@"header");
        refresh = YES;
        _currentTweetPage = 1;

        [self requestActivityGoods:_currentTweetPage];
  
    }
    else if(view.refreshFooterView.state == PullRefreshLoading) //上拉加载更多动作的内容
    {
        refresh = NO;
        _currentTweetPage ++;
        [self requestActivityGoods:_currentTweetPage];
    }
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view
{
	return reloading; // should return if data source model is reloading
}
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view{
    return [NSDate date];
}
- (void)doneLoadingViewData
{
	//  model should call this when its done loading
	reloading = NO;
    [refreshView RefreshScrollViewDataSourceDidFinishedLoading:_tableView];
    [_tableView reloadData];
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
    
    if ([requestType isEqualToString:@"reqActivity"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            if (refresh)
            {
                [_dataArray removeAllObjects];
            }
            refresh = NO;
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            NSArray *commentArray = [dataDetailDict objectForKey:@"productList"];
            [_dataArray addObjectsFromArray:commentArray];
            [_tableView reloadData];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
        [self doneLoadingViewData];
    }
    else if ([requestType isEqualToString:@"inquireBulletin"])
    {
        int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
        NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
        NSArray *commentArray = [dataDetailDict objectForKey:@"dataList"];
        NSMutableString *noticeStr = [NSMutableString string];
        for (NSDictionary *dcit in commentArray) {
            [noticeStr appendString:[dcit objectForKey:@"content"]];
        }
        [_textPlay stopPlayText];
        [_textPlay startPlayText:noticeStr];
    }
    else if ([requestType isEqualToString:@"consumeIntegration"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [self requestUpdateOrderStatus];
        }
        else
        {
            [[CommonParam sharedInstance] responseCodeProcess:[[dict objectForKey:kResultCodeRes] intValue] taostViewController:self];
        }
    }
    else if ([requestType isEqualToString:@"updateEventQualificationStatus"])
    {
        [ALToastView toastInView:self.view withText:@"兑换成功, 1-3个工作日到账"];
        [[CommonParam sharedInstance] requestUserInfo];
    }
    [jsonDecoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    [_dialog hideProgress];
    [self doneLoadingViewData];
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark UserInfoNotification

- (void)userInfoDidFinish:(NSNotification *)notifity
{
    self.dianBiLabel.text = [NSString stringWithFormat:@"当前余额:%d分",[[CommonParam sharedInstance] calualteBalance]];
}

#pragma mark PrivateFunc
- (void)initWithCustomView
{
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, kScreenHeight - 44.f)];
    bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"view_bg"]];
    bgView.contentSize = CGSizeMake(320, 580);
    [self.view addSubview:bgView];
    
    UILabel *rechageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)] autorelease];
    rechageLabel.text = @"话费充值";
    rechageLabel.backgroundColor = [UIColor clearColor];
    rechageLabel.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:rechageLabel];
    
    NSArray *array = [NSArray arrayWithObjects:@"话费5元（500分）", @"话费15元（1500分）", @"话费30元（3000分）", @"话费10元（1000分）", @"话费20元（2000分）",    @"话费50元（5000分）", nil];
    
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            if(i == 0)
            {
                [button setTitle:[array objectAtIndex:j] forState:UIControlStateNormal];
                button.tag = j;
            }
            else
            {
                [button setTitle:[array objectAtIndex:3+j] forState:UIControlStateNormal];
                button.tag = j + 3;
            }
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            button.frame = CGRectMake((1 + i)*20+i*130 , j*40 + 40, 130, 25);
            [button addTarget:self action:@selector(moblieRechageAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
        }
    }
    
    UILabel *lineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 1)] autorelease];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    lineLabel.alpha = 0.4f;
    [bgView addSubview:lineLabel];
    
    UILabel *payLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 180, 200, 20)] autorelease];
    payLabel.text = @"支付宝提现";
    payLabel.backgroundColor = [UIColor clearColor];
    payLabel.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:payLabel];
    
    NSArray *payArray = [NSArray arrayWithObjects:@"提现5元（500分）", @"提现15元（1500分）", @"提现30元（3000分）", @"提现10元（1000分）", @"提现20元（2000分）",    @"提现50元（5000分）", nil];
    
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            if(i == 0)
            {
                [button setTitle:[payArray objectAtIndex:j] forState:UIControlStateNormal];
                button.tag = j + 1000;
            }else
            {
                [button setTitle:[payArray objectAtIndex:3+j] forState:UIControlStateNormal];
                button.tag = 3 + j+1000;
            }
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            button.frame = CGRectMake((1 + i)*20+i*130 , j*40 + 210, 130, 25);
            [button addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
        }
    }
    
    UILabel *qqlineLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 1)] autorelease];
    qqlineLabel.backgroundColor = [UIColor lightGrayColor];
    qqlineLabel.alpha = 0.4f;
    [bgView addSubview:qqlineLabel];
    
    UILabel *qqpayLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 330, 320, 20)] autorelease];
    qqpayLabel.text = @"Q币充值(请在“我的-我的资料”绑定qq邮箱)";
    qqpayLabel.backgroundColor = [UIColor clearColor];
    qqpayLabel.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:qqpayLabel];
    
    NSArray *qqArray = [NSArray arrayWithObjects:@"q币1元（100分）", @"q币15元（1500分）", @"q币30元（3000分）", @"q币10元（1000分）", @"q币20元（2000分）",    @"q币50元（5000分）",nil];
    
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
            if(i == 0)
            {
                [button setTitle:[qqArray objectAtIndex:j] forState:UIControlStateNormal];
                button.tag = j + 2000;
            }else
            {
                [button setTitle:[qqArray objectAtIndex:3+j] forState:UIControlStateNormal];
                button.tag = 3 + j+2000;
            }
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.f];
            button.frame = CGRectMake((1 + i)*20+i*130 , j*40 + 370, 130, 25);
            [button addTarget:self action:@selector(qqPayAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
        }
    }


}

- (IBAction)getMoneyClick:(id)sender
{
    ExchangeViewController *exchangeVC = [[ExchangeViewController alloc] init];
    [self.navigationController pushViewController:exchangeVC animated:YES];
    [exchangeVC release];
}

- (void)requestActivityGoods:(int)page
{
    [_dialog showProgress:self withLabel:@"正在请求中..."];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kPageCount, kPageCountReq, [NSNumber numberWithInt:page], kCurrentIndexReq, nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireProductList", kServerUrl]];
    
    [_reqActivity cancel];
    [self setReqActivity:[ASIFormDataRequest requestWithURL:url]];
    [_reqActivity setPostValue:requestStr forKey:kRequestRes];
    [_reqActivity setUserInfo:[NSDictionary dictionaryWithObject:@"reqActivity" forKey:kRequestKey]];
    [_reqActivity setDelegate:self];
    [_reqActivity startAsynchronous];
}

- (void)requestNotification
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:kPageCount, kPageCountReq, @"1", kCurrentIndexReq, nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireBulletin", kServerUrl]];

    [_reqNotification cancel];
    [self setReqNotification:[ASIFormDataRequest requestWithURL:url]];
    [_reqNotification setPostValue:requestStr forKey:kRequestRes];
    [_reqNotification setUserInfo:[NSDictionary dictionaryWithObject:@"inquireBulletin" forKey:kRequestKey]];
    [_reqNotification setDelegate:self];
    [_reqNotification startAsynchronous];
}

- (void)moblieRechageAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.changeTag = [NSString stringWithFormat:@"%d", btn.tag];
    NSDictionary *userDict = [CommonParam sharedInstance].userInfo;
    if ([[userDict objectForKey:@"mobile"] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号尚未绑定" message:@"去绑定？" delegate:self cancelButtonTitle:@"绑定"otherButtonTitles:@"取消", nil];
        alertView.tag = 999;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"话费充值" message:@"是否兑换" delegate:self cancelButtonTitle:@"确定兑换"otherButtonTitles:@"取消", nil];
        alertView.tag = 1000;
        [alertView show];
    }
}

- (void)payAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.changeTag = [NSString stringWithFormat:@"%d", btn.tag];
    NSDictionary *userDict = [CommonParam sharedInstance].userInfo;
    if ([[userDict objectForKey:@"payAccount"] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付宝账号尚未绑定" message:@"去绑定？" delegate:self cancelButtonTitle:@"绑定"otherButtonTitles:@"取消", nil];
        alertView.tag = 998;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"支付宝体现" message:@"是否兑换" delegate:self cancelButtonTitle:@"确定兑换"otherButtonTitles:@"取消", nil];
        alertView.tag = 1001;
        [alertView show];
    }
}

- (void)qqPayAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.changeTag = [NSString stringWithFormat:@"%d", btn.tag];
    NSDictionary *userDict = [CommonParam sharedInstance].userInfo;
    if ([[userDict objectForKey:@"email"] length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"qq邮箱账号尚未绑定" message:@"去绑定？" delegate:self cancelButtonTitle:@"绑定"otherButtonTitles:@"取消", nil];
        alertView.tag = 1999;
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Q币充值" message:@"是否充值" delegate:self cancelButtonTitle:@"确定充值"otherButtonTitles:@"取消", nil];
        alertView.tag = 2000;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    int intergation = 0;
    int productId = 0;
    NSLog(@"[self.changeTag intValue] = %d", [self.changeTag intValue]);
    if([self.changeTag intValue] == 0)
    {
        intergation = 500;
        productId = 1;
    }
    else if([self.changeTag intValue] == 1)
    {
        intergation = 1500;
        productId = 2;
    }
    else if([self.changeTag intValue] == 2)
    {
        intergation = 3000;
        productId = 3;
    }
    else if([self.changeTag intValue] == 3)
    {
        intergation = 1000;
        productId = 4;
    }
    else if([self.changeTag intValue] == 4)
    {
        intergation = 2000;
        productId = 5;
    }
    else if([self.changeTag intValue] == 5)
    {
        intergation = 5000;
        productId = 6;
    }
    if([self.changeTag intValue] == 1000)
    {
        intergation = 500;
        productId = 7;
    }
    else if([self.changeTag intValue] == 1001)
    {
        intergation = 1500;
        productId = 8;
    }
    else if([self.changeTag intValue] == 1002)
    {
        intergation = 3000;
        productId = 9;
    }
    else if([self.changeTag intValue] == 1003)
    {
        intergation = 1000;
        productId = 10;
    }
    else if([self.changeTag intValue] == 1004)
    {
        intergation = 2000;
        productId = 11;
    }
    else if([self.changeTag intValue] == 1005)
    {
        intergation = 5000;
        productId = 12;
    }
    if([self.changeTag intValue] == 2000)
    {
        intergation = 100;
        productId = 13;
    }
    else if([self.changeTag intValue] == 2001)
    {
        intergation = 1500;
        productId = 14;
    }
    else if([self.changeTag intValue] == 2002)
    {
        intergation = 3000;
        productId = 15;
    }
    else if([self.changeTag intValue] == 2003)
    {
        intergation = 1000;
        productId = 16;
    }
    else if([self.changeTag intValue] == 2004)
    {
        intergation = 2000;
        productId = 17;
    }
    else if([self.changeTag intValue] == 2005)
    {
        intergation = 5000;
        productId = 18;
    }
     NSLog(@"tag = %d", alertView.tag);
    NSLog(@"productId = %d", productId);
    NSLog(@"intergation = %d", intergation);
    self.currentConsumeIntergration = [NSString stringWithFormat:@"%d", intergation];
    self.currentExchangeProductId = [NSString stringWithFormat:@"%d", productId];
    //绑定手机号
    if (alertView.tag == 999)
    {
        if (buttonIndex == 0)
        {
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:userInfoVC animated:YES];
            [userInfoVC release];
        }
        else
        {
            return;
        }
    }
    //话费充值
    else if (alertView.tag == 1000)
    {
        if (buttonIndex == 0)
        {
            if ([[CommonParam sharedInstance] calualteBalance] < intergation)
            {
                [ALToastView toastInView:self.view withText:@"点币不够，再去赚一点吧！~"];
            }
            else
            {
                [_dialog showProgress:self withLabel:@"兑换中"];
                int integeration = [[CommonParam sharedInstance] calualteBalance] - [[CommonParam sharedInstance] getReommandBalance];
                if(integeration > 0){
                    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDel.zhuanDianVC spendDMScore:intergation];
                }else{
                    [self requestConsumeIntegration];
                }
            }
        }
        else
        {
            return;
        }
    }
    //支付宝体现
    else if (alertView.tag == 1001)
    {
        if (buttonIndex == 0)
        {
            if ([[CommonParam sharedInstance] calualteBalance] < intergation)
            {
                [ALToastView toastInView:self.view withText:@"点币不够，再去赚一点吧！~"];
            }
            else
            {
                [_dialog showProgress:self withLabel:@"兑换中"];
                int integeration = [[CommonParam sharedInstance] calualteBalance] - [[CommonParam sharedInstance] getReommandBalance];
                if(integeration > 0){
                    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDel.zhuanDianVC spendDMScore:intergation];
                }else{
                    [self requestConsumeIntegration];
                }
            }
        }
        else
        {
            return;
        }
    }
    //绑定支付宝账号
    else if (alertView.tag == 998)
    {
        if (buttonIndex == 0)
        {
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:userInfoVC animated:YES];
            [userInfoVC release];
        }
        else
        {
            return;
        }
    }
    
    //Q币充值
    else if (alertView.tag == 2000)
    {
        if (buttonIndex == 0)
        {
            if ([[CommonParam sharedInstance] calualteBalance] < intergation)
            {
                [ALToastView toastInView:self.view withText:@"点币不够，再去赚一点吧！~"];
            }
            else
            {
                [_dialog showProgress:self withLabel:@"兑换中"];
                int integeration = [[CommonParam sharedInstance] calualteBalance] - [[CommonParam sharedInstance] getReommandBalance];
                if(integeration > 0){
                    AppDelegate *appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appDel.zhuanDianVC spendDMScore:intergation];
                }else{
                    [self requestConsumeIntegration];
                }
            }
        }
        else
        {
            return;
        }
    }
    //绑定支付宝账号
    else if (alertView.tag == 1999)
    {
        if (buttonIndex == 0)
        {
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:userInfoVC animated:YES];
            [userInfoVC release];
        }
        else
        {
            return;
        }
    }
}


#pragma mark ConsumeNotify
- (void)consumeSuccess:(NSNotification *)notity
{
    //NSLog(@"object = %@", notity.object);
    //NSLog(@"userInfo = %@", notity.userInfo);
    [self requestConsumeIntegration];
}

- (void)consumeFailed:(NSNotification *)notity
{
    [ALToastView toastInView:self.view withText:@"兑换失败"];
}

- (void)requestConsumeIntegration
{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:Channel_Type_DuoMeng], @"channel", self.currentConsumeIntergration, @"amount", nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=consumeIntegration", kServerUrl]];
    
    [_reqconsumeIntegration cancel];
    [self setReqconsumeIntegration:[ASIFormDataRequest requestWithURL:url]];
    [_reqconsumeIntegration setPostValue:requestStr forKey:kRequestRes];
    [_reqconsumeIntegration setUserInfo:[NSDictionary dictionaryWithObject:@"consumeIntegration" forKey:kRequestKey]];
    [_reqconsumeIntegration setDelegate:self];
    [_reqconsumeIntegration startAsynchronous];
}

- (void)requestUpdateOrderStatus
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.currentExchangeProductId, @"productId", @"1", @"num", nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=updateEventQualificationStatus", kServerUrl]];
    
    [_reqUpdateQualificationStatus cancel];
    [self setReqUpdateQualificationStatus:[ASIFormDataRequest requestWithURL:url]];
    [_reqUpdateQualificationStatus setPostValue:requestStr forKey:kRequestRes];
    [_reqUpdateQualificationStatus setUserInfo:[NSDictionary dictionaryWithObject:@"updateEventQualificationStatus" forKey:kRequestKey]];
    [_reqUpdateQualificationStatus setDelegate:self];
    [_reqUpdateQualificationStatus startAsynchronous];
}

@end
