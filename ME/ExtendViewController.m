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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
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
            [self presentViewController:[[RankingViewController alloc] init] animated:YES completion:^{}];
            break;
        default:
            break;
    }
}
@end
