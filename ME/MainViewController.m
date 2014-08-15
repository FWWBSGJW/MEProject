//
//  MainViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "MainViewController.h"
#import "CCourseViewController.h"
#import "UserCenterTableViewController.h"
#import "JJTestViewController.h"
#import "ExtendViewController.h"
#import "QAViewController.h"

@interface MainViewController ()

-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    CCourseViewController *couseViewController = [[CCourseViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *couseNav = [[UINavigationController alloc] initWithRootViewController:couseViewController];
    
    //[couseNav.navigationBar setBarTintColor:[UIColor greenColor]];
    //UITabBarItem *couseItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    //UIImage *image = [UIImage imageNamed:@"course"];
    UITabBarItem *couseItem = [[UITabBarItem alloc] initWithTitle:@"课程" image:[UIImage imageNamed:@"course"] tag:1];
    couseNav.tabBarItem = couseItem;
    
    JJTestViewController *testVC = [[JJTestViewController alloc] init];
    
    UINavigationController *testNav = [[UINavigationController alloc] initWithRootViewController:testVC];
    //UITabBarItem *testItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    UITabBarItem *testItem = [[UITabBarItem alloc] initWithTitle:@"测试" image:[UIImage imageNamed:@"Test"] tag:2];
    testNav.tabBarItem = testItem;
    
	UserCenterTableViewController *userCenter = [[UserCenterTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	userCenter.user = [User sharedUser];
	UINavigationController *userVC = [[UINavigationController alloc] initWithRootViewController:userCenter];
    //UITabBarItem *userItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:3];
    UITabBarItem *userItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"User"] tag:5];
    userVC.tabBarItem = userItem;
    
    
    
    ExtendViewController *extendVC = [[ExtendViewController alloc] init];
    UINavigationController *extendNav = [[UINavigationController alloc] initWithRootViewController:extendVC];
    //UITabBarItem *demoItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:3];
    UITabBarItem *addItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"Clear"] tag:3];
    extendVC.tabBarItem = addItem;
    
    
    
    QAViewController *qaVC3 = [QAViewController shareQA];
    UINavigationController *qaNav = [[UINavigationController alloc] initWithRootViewController:qaVC3];
    //UITabBarItem *demoItem3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:4];
    UITabBarItem *qaItem = [[UITabBarItem alloc] initWithTitle:@"交流" image:[UIImage imageNamed:@"Q&A"] tag:4];
    qaVC3.tabBarItem = qaItem;
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    //self.tabBar.tintColor = [UIColor colorWithRed:88/255.0 green:246/255.0 blue:76/255.0 alpha:1.0];
    
    NSArray *array = @[couseNav,testNav,extendNav,qaNav,userVC];
    
    
    
    [self setViewControllers:array animated:YES];
    
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5.0f*2, 0, SCREEN_WIDTH/5.0f, 44.0)];
    clearView.backgroundColor = [UIColor clearColor];
    [self.tabBar addSubview:clearView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(SCREEN_WIDTH*2/5.0+10,5,SCREEN_WIDTH/5.0-20,40)];
    [button setBackgroundImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [self.tabBar addSubview:button];
    [button addTarget:self action:@selector(modalAddView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 模态工具试图
- (void)modalAddView
{
    ExtendViewController *exVC = [[ExtendViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:exVC];

    //exVC.view.backgroundColor = [UIColor colorWithRed:88/255.0 green:246/255.0 blue:76/255.0 alpha:1.0];
    [self presentViewController:nav animated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
//    NSLog(@"%@",self.selectedViewController);
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
