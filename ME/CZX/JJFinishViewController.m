//
//  JJFinishViewController.m
//  在线教育
//
//  Created by Johnny's on 14-7-11.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJFinishViewController.h"
#import "JJTestDetailViewController.h"

@interface JJFinishViewController ()

@end

@implementation JJFinishViewController

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
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)back:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
@end
