//
//  MoreViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//


#import "MoreViewController.h"
#import "FindPwdViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"
#import "AbountViewController.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    Dialog *_dialog;
}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) ASIFormDataRequest *reqUpdate;
@property (nonatomic, retain) NSDictionary *updateDict;

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"更多";
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"lab_icon_more_pressing"] withFinishedUnselectedImage:[UIImage imageNamed:@"lab_icon_more_normal"]];
        self.view.backgroundColor = kViewBgColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _updateDict = [[NSDictionary alloc] init];
    _dialog = [[Dialog alloc] init];
    if (!iPhone5)
    {
        self.toolbar.frame = CGRectMake(0, 0, 320, 130);
    }
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more_icon_settings"], @"icon", @"设置", @"title", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more_icon_feedback"], @"icon", @"意见反馈",@"title",nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more_icon_update"], @"icon", @"检查更新", @"title", nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more_icon_qq_service"], @"icon", @"客服QQ", @"title", nil];
//    NSDictionary *dict4 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon"], @"icon", @"使用帮助", @"title", nil];
    NSDictionary *dict5 = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"more_icon_about"], @"icon", @"关于点点赚", @"title", nil];

    [self.dataArray addObject:dict0];
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self.dataArray addObject:dict3];
//    [self.dataArray addObject:dict4];
    [self.dataArray addObject:dict5];
    [self initWithCustomView];
}

- (void)dealloc
{
    SAFE_RELEASE(_updateDict);
    SAFE_RELEASE(_dialog);
    ASI_SAFE_RELEASE(_reqUpdate);
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
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 25, 25)];
    iconView.image = [dict objectForKey:@"icon"];
    [cell.contentView addSubview:iconView];
    [iconView release];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 200, 25)];
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
        SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:settingVC animated:YES];
        [settingVC release];
    }
    else if (indexPath.row == 1)
    {
        FeedbackViewController *feedBackVC = [[FeedbackViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        [feedBackVC release];
    }
    else if (indexPath.row == 2)
    {
        [self requestUpdate];
    }
    else if (indexPath.row == 3)
    {
        FindPwdViewController *findPwdVC = [[FindPwdViewController alloc] initWithNibName:nil bundle:nil];
        findPwdVC.titileStr = @"客服QQ";
        [self.navigationController pushViewController:findPwdVC animated:YES];
        [findPwdVC release];
    }
    else
    {
        AbountViewController *aboutVC= [[AbountViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && _updateDict)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_updateDict objectForKey:@"downloadUrl"]]];
    }
    [_updateDict release];
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
    
    if ([requestType isEqualToString:@"inquireVersion"])
    {
        if ([[dict objectForKey:kResultCodeRes] intValue] == 0)
        {
            int encryptType = [[dict objectForKey:kEncryptCodeRes] intValue];
            NSDictionary *dataDetailDict = [TransformData transformData:encryptType dict:dict];
            _updateDict = [[NSDictionary alloc] initWithDictionary:dataDetailDict];
            if ([[CommonParam sharedInstance].getWeiLeVersion isEqualToString:[dataDetailDict objectForKey:@"versionCode"]]) {
                [ALToastView toastInView:self.view withText:@"已经是最新版本"];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:[_updateDict objectForKey:@"versionContent"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
                [alertView show];
                [alertView release];
            }
            
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

- (void)initWithCustomView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, iPhone5 ? kScreenHeight-44 : kScreenHeight - 110) style:UITableViewStylePlain];
    tableView.backgroundColor = kViewBgColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView release];
}

- (void)requestUpdate
{
    [_dialog showProgress:self withLabel:@"检查更新中..."];

    NSDictionary *reqDict = [NSDictionary dictionaryWithObjectsAndKeys:[CommonParam sharedInstance].session , kSessionReq, kAESReq, kEncryptTypeReq, nil];
    NSString *requestStr = [reqDict JSONString];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@act=inquireVersion", kServerUrl]];
    
    [_reqUpdate cancel];
    [self setReqUpdate:[ASIFormDataRequest requestWithURL:url]];
    [_reqUpdate setPostValue:requestStr forKey:kRequestRes];
    [_reqUpdate setUserInfo:[NSDictionary dictionaryWithObject:@"inquireVersion" forKey:kRequestKey]];
    [_reqUpdate setDelegate:self];
    [_reqUpdate startAsynchronous];
}

@end
