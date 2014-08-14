//
//  ExchangeViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "QueryExchangeViewController.h"
#import "ExchageDetailViewController.h"
#import "HaveExchangedViewController.h"
#import "AddAddrViewController.h"
#import "UserInfoViewController.h"

@interface QueryExchangeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *unExchangeTableView;
@property (nonatomic, retain) UITableView *exchangeTableView;
@property (nonatomic, retain) NSMutableArray *unExchangeArray;
@property (nonatomic, retain) NSMutableArray *exchangeArray;
@property (nonatomic, retain) ASIFormDataRequest *reqUnExchange;
@property (nonatomic, retain) ASIFormDataRequest *reqExchange;
@property (nonatomic, retain) UILabel *sliderLabel;

@end

@implementation QueryExchangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CommonParam sharedInstance] requestUserInfo];
//    [self requestUnExchange];
    [self requestExchange];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidFinish:) name:kReqUserInfoDidFinish object:nil];
    self.exchangeArray = [[NSMutableArray alloc] init];
    [self initWithCustomView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(self.sliderLabel);
    SAFE_RELEASE(self.exchangeArray);
    SAFE_RELEASE(self.unExchangeArray);
    ASI_SAFE_RELEASE(_reqExchange);
    ASI_SAFE_RELEASE(_reqUnExchange);
    
    [_unExchangeBtn release];
    [_exchangedBtn release];
    [_balanceLabel release];
    [super dealloc];
}

#pragma mark TabelViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exchangeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExchangeCell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    NSDictionary *dict = [self.exchangeArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"productName"];
    
    return cell;

}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
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
    if ([requestType isEqualToString:@"requestExchange"])
    {
        [self.exchangeArray removeAllObjects];
        int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
        NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
        NSArray *commentArray = [dataDetailDict objectForKey:@"productList"];
        [self.exchangeArray addObjectsFromArray:commentArray];
        [self.exchangeTableView reloadData];
    }
    [jsonDecoder release];
}

- (void)requestFailed:(ASIHTTPRequest *)request;
{
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark UserInfoNotification

- (void)userInfoDidFinish:(NSNotification *)notifity
{
    self.balanceLabel.text = [NSString stringWithFormat:@"%d分", [[CommonParam sharedInstance] calualteBalance]];
}

#pragma mark PrivateFunc

- (void)initWithCustomView
{
    
    self.exchangeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44.f, kScreenWidth, kScreenHeight - 44.f) style:UITableViewStylePlain];
    self.exchangeTableView.dataSource = self;
    self.exchangeTableView.delegate = self;
    [self.view addSubview:self.exchangeTableView];
    [self.exchangeTableView release];
    [self.view addSubview:self.exchangeTableView];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestExchange
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"100", kPageCountReq, @"1", kCurrentIndexReq, nil];
    NSData *aesData= [dict JSONData];
    NSString *aesEncryptStr = [[aesData AES256EncryptWithKey:[CommonParam sharedInstance].key] base64EncodedString];
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, aesEncryptStr, kDataReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquirePageExchangeList", kServerUrl]];
    [_reqExchange cancel];
    [self setReqExchange:[ASIFormDataRequest requestWithURL:url]];
    [_reqExchange setPostValue:requestStr forKey:kRequestRes];
    [_reqExchange setUserInfo:[NSDictionary dictionaryWithObject:@"requestExchange" forKey:kRequestKey]];
    [_reqExchange setDelegate:self];
    [_reqExchange startAsynchronous];
}

- (void)viewDidUnload {
    [self setExchangedBtn:nil];
    [self setBalanceLabel:nil];
    [super viewDidUnload];
}
@end
