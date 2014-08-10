//
//  ExtendViewController.m
//  ME
//
//  Created by yato_kami on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ExtendViewController.h"
#import "ShakeViewController.h"
#import "RankingViewController.h"
#import "CDownloadViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            [self presentViewController:[[ShakeViewController alloc] init] animated:YES completion:^{}];
            break;
        case 2:
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RankingViewController alloc] init]] animated:YES completion:^{
            }];
            break;
        case 3:
            [self.navigationController pushViewController:[[CDownloadViewController alloc] init] animated:YES];
            //[self presentViewController:[[CDownloadViewController alloc] init] animated:YES completion:nil];
        default:
            break;
    }
}
@end
