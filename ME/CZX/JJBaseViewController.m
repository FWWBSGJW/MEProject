//
//  JJBaseViewController.m
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJBaseViewController.h"
#import "JJTestDetailViewController.h"
#import "JJTestDivideViewController.h"

@interface JJBaseViewController ()

@end

@implementation JJBaseViewController

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
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)paramGestureRecognizer
{
    if (paramGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        UIView *view = paramGestureRecognizer.view;
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[JJTestDetailViewController class]])
        {
            JJTestDetailViewController *vc = (JJTestDetailViewController *)nextResponder;
            [vc.navigationController popViewControllerAnimated:YES];
        }
        if([nextResponder isKindOfClass:[JJTestDivideViewController class]])
        {
            JJTestDivideViewController *vc = (JJTestDivideViewController *)nextResponder;
            [vc.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
