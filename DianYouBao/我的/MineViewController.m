//
//  MineViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "MineViewController.h"
#import "AddressManagerViewController.h"
#import "AccountViewController.h"
#import "UserInfoViewController.h"
#import "QueryExchangeViewController.h"
#import "AddAddrViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIImageView *_myInfoIV;
    UIImageView *_myAddrIV;
}
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation MineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"lab_icon_my_pressing"] withFinishedUnselectedImage:[UIImage imageNamed:@"lab_icon_my_normal"]];
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[AdManager sharedInstance] reqUploadScore];
    [[CommonParam sharedInstance] requestUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!iPhone5)
    {
        self.toolbar.frame = CGRectMake(0, 0, 320, 130);
    }
    self.dataArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoDidFinish:) name:kReqUserInfoDidFinish object:nil];
    NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"my_icon_data"], @"icon", @"我的资料", @"title",@"完善我的资料，才能兑换点点赚产品", @"subTitle", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"my_icon_account"], @"icon", @"我的账户",@"title",@"查看我的点币，赚点明细", @"subTitle", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"my_icon_exchange"], @"icon", @"兑换记录", @"title", @"查看预约记录，兑换记录", @"subTitle", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"my_icon_address"], @"icon", @"收货地址", @"title",@"添加正确收货地址，确保您能准时收到礼品", @"subTitle", nil];

    [self.dataArray addObject:dict0];
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self.dataArray addObject:dict3];
    
    [self initWithCustomView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SAFE_RELEASE(self.dataArray);
    [_toolbar release];
    [super dealloc];
}

#pragma mark TabelViewDataSource

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
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 25)];
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
    
    if (indexPath.row == 0)
    {
        _myInfoIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10, 8, 8)];
        _myInfoIV.image = [UIImage imageNamed:@"red_circle"];
        [cell.contentView addSubview:_myInfoIV];
        _myInfoIV.hidden = YES;
        [_myInfoIV release];
    }
    
    if (indexPath.row == 3)
    {
        _myAddrIV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 10, 8, 8)];
        _myAddrIV.image = [UIImage imageNamed:@"red_circle"];
        _myAddrIV.hidden = YES;
        [cell.contentView addSubview:_myAddrIV];
        [_myAddrIV release];
    }
    
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:userInfoVC animated:YES];
        [userInfoVC release];
    }
    else if (indexPath.row == 1)
    {
        AccountViewController *accountVC = [[AccountViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:accountVC animated:YES];
        [accountVC release];
    }
    else if (indexPath.row == 2)
    {
        QueryExchangeViewController *accountVC = [[QueryExchangeViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:accountVC animated:YES];
        [accountVC release];
    }
    else if (indexPath.row == 3)
    {
        NSString *addInfo = [[CommonParam sharedInstance].userInfo objectForKey:@"street"];
        NSString *addUserName = [[CommonParam sharedInstance].userInfo objectForKey:@"name"];
        if (addUserName.length == 0 || addInfo.length == 0)
        {
            AddAddrViewController *addAddrVC = [[AddAddrViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:addAddrVC animated:YES];
            [addAddrVC release];
        }
        else
        {
            AddressManagerViewController *addressVC = [[AddressManagerViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:addressVC animated:YES];
            [addressVC release];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark UserInfoNotification

- (void)userInfoDidFinish:(NSNotification *)notifity
{
    [self showRedDotView];
}

#pragma mark PrivateFunc

- (void)showRedDotView
{
    NSString *addInfo = [[CommonParam sharedInstance].userInfo objectForKey:@"street"];
    NSString *addUserName = [[CommonParam sharedInstance].userInfo objectForKey:@"name"];
    if (addUserName.length == 0 || addInfo.length == 0)
    {
        _myAddrIV.hidden = NO;
    }
    else
    {
        _myAddrIV.hidden = YES;
    }
    
    NSString *email = [[CommonParam sharedInstance].userInfo objectForKey:@"email"];
    NSString *mobile = [[CommonParam sharedInstance].userInfo objectForKey:@"mobile"];
    NSString *payAccount = [[CommonParam sharedInstance].userInfo objectForKey:@"payAccount"];
    if (email.length == 0 || mobile.length == 0 || payAccount.length == 0)
    {
        _myInfoIV.hidden = NO;
    }
    else
    {
        _myInfoIV.hidden = YES;
    }
    
    if (email.length == 0 || mobile.length == 0 || payAccount.length == 0 || addUserName.length == 0 || addInfo.length == 0)
    
    {
        self.tabBarItem.badgeValue = @"1";
    }
    else
    {
        self.tabBarItem.badgeValue = nil;
    }
}

- (void)initWithCustomView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, iPhone5 ? kScreenHeight-44 : kScreenHeight - 110) style:UITableViewStylePlain];
    tableView.backgroundColor = kViewBgColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
}

@end
