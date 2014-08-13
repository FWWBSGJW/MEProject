//
//  ShakeViewController.m
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ShakeViewController.h"
#import "User.h"
#import "UserIntegralModel.h"

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
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
//    NSLog(@"locationString:%@",locationString);

    if ([[User sharedUser].info isLogin]) {
        UserIntegralModel *model = [[[UserIntegralModel alloc] init] queryModels];
        if (model)
        {
            if ([model.uTime isEqualToString:locationString])
            {
                if (model.isSign == NO)
                {
                    [self signUp];
                    model.isSign = YES;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你今天已经签到过了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                model.isSign = YES;
                model.uTime = locationString;
                [self signUp];
            }
            [[[UserIntegralModel alloc] init] saveDirectionModel:model];
        }
        else
        {
            UserIntegralModel *temModel = [[UserIntegralModel alloc] init];
            temModel.userId = [User sharedUser].info.userId;
            temModel.uTime = locationString;
            temModel.isSign = YES;
            temModel.testCount = 0;
            [[[UserIntegralModel alloc] init] saveDirectionModel:temModel];
            [self signUp];
        }
    }
}

- (void)signUp
{
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%d&upoints=5", [User sharedUser].info.userId]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([data length] >0 &&
        error == nil){
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"HTML = %@", html);
    }
    else if ([data length] == 0 &&
             error == nil){
        NSLog(@"Nothing was downloaded.");
    }
    else if (error != nil){
        NSLog(@"Error happened = %@", error);
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜赢得5积分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
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
