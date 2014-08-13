//
//  ShakeViewController.m
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ShakeViewController.h"
#import "User.h"

@interface ShakeViewController ()
{

}
@end

@implementation ShakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLa.text = @"摇一摇";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLa];
    titleView.userInteractionEnabled = YES;
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
    [dismissBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissBtn];
    [self.view addSubview:titleView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 0.5)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self startAnimation];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(shake)];
    [self.phoneImageView addGestureRecognizer:self.tapGestureRecognizer];
    self.phoneImageView.userInteractionEnabled = YES;
    self.tapGestureRecognizer.numberOfTapsRequired = 2;
}

#pragma mark 按钮事件
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}

- (void)shake
{
    [self userCheck];
    if ([[User sharedUser].info isLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜赢得5积分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark 旋转动画
-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.phoneImageView.transform = CGAffineTransformMakeRotation(30 * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startAnimation)];
    self.phoneImageView.transform = CGAffineTransformMakeRotation(-30 * (M_PI / 180.0f));
    [UIView commitAnimations];
}

#pragma mark 摇一摇
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self shake];
    }
}

#pragma mark 用户相关
- (void)userCheck
{
    User *user = [User sharedUser];
    if (!user.info.isLogin) {
//        [user gotoUserLoginFrom:self];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请登录后再签到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
