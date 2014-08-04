//
//  UserViewController.m
//  Online_learning
//
//  Created by qf on 14/7/15.
//  Copyright (c) 2014年 qf. All rights reserved.
// 同步

#import "UserViewController.h"
#import "LoginViewController.h"
#import "UserCenterTableViewController.h"
#import "User.h"
@interface UserViewController ()
@property (nonatomic,strong) LoginViewController *logv;
@property (nonatomic,strong) UserCenterTableViewController *uvc;
@end

@implementation UserViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	User *user = [User sharedUser];
	if (!user.info.isLogin) {
		_logv = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
//		[user gotoUserLoginFrom:[self.viewControllers objectAtIndex:0]];
//		[self pushViewController:_logv animated:YES];
		self.viewControllers = @[_logv];
		
	}else{
		_uvc = [[UserCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		self.viewControllers = @[_uvc];
	}
	
//	UITabBarItem *item = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:1];
//	self.tabBarItem = item;
//	self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",9];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	User *user = [User sharedUser];
	if (!user.info.isLogin) {
		_logv = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
		//		[user gotoUserLoginFrom:[self.viewControllers objectAtIndex:0]];
		//		[self pushViewController:_logv animated:YES];
		self.viewControllers = @[_logv];
		
	}else{
		_uvc = [[UserCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
		self.viewControllers = @[_uvc];
	}
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
