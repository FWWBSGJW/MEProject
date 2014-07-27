//
//  ExtendViewController.m
//  ME
//
//  Created by yato_kami on 14-7-28.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ExtendViewController.h"

@interface ExtendViewController ()

@end

@implementation ExtendViewController

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
    // Do any additional setup after loading the view.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor greenColor];
    [button setFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-50, 100, 100)];
    [button addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


- (void)backHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
