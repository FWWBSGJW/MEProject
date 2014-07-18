//
//  MainViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "MainViewController.h"
#import "CCourseViewController.h"
#import "DemoViewController.h"
#import "UserViewController.h"
#import "JJTestViewController.h"

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
    UITabBarItem *couseItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    couseNav.tabBarItem = couseItem;
    
    JJTestViewController *testVC = [[JJTestViewController alloc] init];
    
    UINavigationController *testNav = [[UINavigationController alloc] initWithRootViewController:testVC];
    UITabBarItem *testItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    testNav.tabBarItem = testItem;
    
    UserViewController *userVC = [[UserViewController alloc] init];
    UITabBarItem *userItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:3];
    userVC.tabBarItem = userItem;
    
    
    
    DemoViewController *demoVC2 = [[DemoViewController alloc] init];
    UINavigationController *demoNav2 = [[UINavigationController alloc] initWithRootViewController:demoVC2];
    UITabBarItem *demoItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:4];
    demoNav2.tabBarItem = demoItem2;
    
    DemoViewController *demoVC3 = [[DemoViewController alloc] init];
    UINavigationController *demoNav3 = [[UINavigationController alloc] initWithRootViewController:demoVC3];
    UITabBarItem *demoItem3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:5];
    demoNav3.tabBarItem = demoItem3;
    
    self.tabBar.tintColor = [UIColor greenColor];
    
    NSArray *array = @[couseNav,testNav,demoNav2,demoNav3,userVC];
    [self setViewControllers:array animated:YES];
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations {
    NSLog(@"%@",self.selectedViewController);
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
