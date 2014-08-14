//
//  AddressManagerViewController.m
//  DianYouBao
//
//  Created by linger on 13/01/14.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "AddAddrViewController.h"

@interface AddressManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ASIFormDataRequest *reqAddress;
@property (nonatomic, retain) NSMutableArray *addressArray;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation AddressManagerViewController

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
    self.addressArray = [[NSMutableArray alloc] init];
    [self requestAddressList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initWithCustomView];
}

- (void)dealloc
{
    SAFE_RELEASE(_addressArray);
    ASI_SAFE_RELEASE(_reqAddress);
    [super dealloc];
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
    
    
    if ([requestType isEqualToString:@"inquireAddress"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            [self.addressArray removeAllObjects];
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            [self.addressArray addObjectsFromArray:[dataDetailDict objectForKey:@"dataList"]];
            [self.tableView reloadData];
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
    if (![[request.error.userInfo objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request was cancelled"]) {
        [SVProgressHUD showErrorWithStatus:@"网络异常" duration:1];
    }
}

#pragma mark TabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.addressArray count];
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
    
    NSDictionary *dict = [self.addressArray objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 25)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [NSString stringWithFormat:@"姓名:%@",[dict objectForKey:@"name"]];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    UILabel *detailAddrLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 250, 40)];
    detailAddrLabel.backgroundColor = [UIColor clearColor];
    detailAddrLabel.text = [NSString stringWithFormat:@"地址:%@",[dict objectForKey:@"street"]];
    detailAddrLabel.font = [UIFont systemFontOfSize:12];
    detailAddrLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:detailAddrLabel];
    [detailAddrLabel release];
    
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.addressArray objectAtIndex:indexPath.row];
    AddAddrViewController *addAddrVC = [[AddAddrViewController alloc] initWithNibName:nil bundle:nil];
    addAddrVC.addressId = [dict objectForKey:@"addressId"];
    addAddrVC.name = [dict objectForKey:@"name"];
    addAddrVC.currentAddr = [dict objectForKey:@"street"];
    [self.navigationController pushViewController:addAddrVC animated:YES];
    [addAddrVC release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark PrivateFunc
- (void)requestAddressList
{
    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireAddress", kServerUrl]];
    
    [_reqAddress cancel];
    [self setReqAddress:[ASIFormDataRequest requestWithURL:url]];
    [_reqAddress setPostValue:requestStr forKey:kRequestRes];
    [_reqAddress setUserInfo:[NSDictionary dictionaryWithObject:@"inquireAddress" forKey:kRequestKey]];
    [_reqAddress setDelegate:self];
    [_reqAddress startAsynchronous];
}

- (void)initWithCustomView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)AddAddressClick:(id)sender
{
//    AddAddrViewController *addAddrVC = [[AddAddrViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:addAddrVC animated:YES];
//    [addAddrVC release];
}

- (void)viewDidUnload {
    [self setAddAddrBtn:nil];
    [super viewDidUnload];
}
@end
