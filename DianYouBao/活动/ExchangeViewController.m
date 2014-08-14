//
//  ExchangeViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-12.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "ExchangeViewController.h"

@interface ExchangeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_packageLabel;
    Money_Type moneyType;
}

@property(nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation ExchangeViewController

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
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSDictionary *dict0 = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝                  50元（15000点）", @"title", nil];
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝                  100元（30000点）", @"title", nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"支付宝                  200元（60000点）", @"title", nil];
    
    [self.dataArray addObject:dict0];
    [self.dataArray addObject:dict1];
    [self.dataArray addObject:dict2];
    [self initWithCustomView];
    
}

- (void)dealloc
{
    SAFE_RELEASE(self.dataArray);
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
    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 25)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = [dict objectForKey:@"title"];
    textLabel.font = [UIFont systemFontOfSize:16];
    
    [cell.contentView addSubview:textLabel];
    [textLabel release];
    
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    _packageLabel.text = [dict objectForKey:@"title"];
    if (indexPath.row == 0)
    {
        moneyType = Money_Type_50;
    }
    else if (indexPath.row == 1)
    {
        moneyType = Money_Type_100;
    }
    else
    {
        moneyType = Money_Type_200;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

#pragma markPrivateFunc
- (void)initWithCustomView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.0, kScreenWidth, 100)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.layer.borderWidth = 1.0;
    headView.layer.borderColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:0.8].CGColor;
    [self.view addSubview:headView];
    [headView release];
    
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.text = @"兑现套餐（提现）";
    desLabel.textColor = [UIColor grayColor];
    [headView addSubview:desLabel];
    [desLabel release];
    
    _packageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 20)];
    _packageLabel.backgroundColor = [UIColor clearColor];
    _packageLabel.text = @"支付宝提现50元（15000点）";
    _packageLabel.textColor = [UIColor redColor];
    [headView addSubview:_packageLabel];
    [_packageLabel release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.frame.origin.y + headView.frame.size.height, kScreenWidth, 120) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    moneyType = Money_Type_50;
    [self.view addSubview:tableView];
    [tableView release];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    UIButton *verifycontactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [verifycontactBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [verifycontactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    verifycontactBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_normal"] forState:UIControlStateNormal];
    [verifycontactBtn setBackgroundImage:[UIImage imageNamed:@"register_btn_green_pressing"] forState:UIControlStateHighlighted];
    [verifycontactBtn addTarget:self action:@selector(exchangeClick:) forControlEvents:UIControlEventTouchUpInside];
    verifycontactBtn.frame = CGRectMake(230, tableView.frame.origin.y + tableView.frame.size.height + 20, 70, 40);
    [self.view addSubview:verifycontactBtn];
}

- (void)exchangeClick:(id)sender
{

}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
