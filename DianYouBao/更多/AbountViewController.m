//
//  AbountViewController.m
//  DianYouBao
//
//  Created by 林 贤辉 on 14-1-15.
//  Copyright (c) 2014年 linger. All rights reserved.
//

#import "AbountViewController.h"

@interface AbountViewController ()

@end

@implementation AbountViewController

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
    self.versionLabel.text = [NSString stringWithFormat:@"Version:%@", [[CommonParam sharedInstance] getWeiLeVersion]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_versionLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
