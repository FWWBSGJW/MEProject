//
//  TrendDetailViewController.m
//  ME
//
//  Created by Johnny's on 14-9-5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "TrendDetailViewController.h"
#import "UILabel+dynamicSizeMe.h"
#import "UIImageView+WebCache.h"

#define originY 62
@interface TrendDetailViewController ()


@end


@implementation TrendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithTrendModel:(TrendModel *)model
{
    self = [super init];
    [self initializeView];
    
    [self.userHeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.197.10.159:8080/images/user/%@", model.userPortrait]]];
    self.timeLabel.text = [NSString stringWithFormat:@"%.f分钟前", model.hmtime];
    self.userName.text = model.userName;
    self.trendLabel.text = model.content;
    [self.trendLabel resizeToFit];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.trendLabel.frame.origin.y+self.trendLabel.frame.size.height+20, 320, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.lineView];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)initializeView
{
    self.userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+originY, 42, 42)];
    self.userHeadImage.layer.cornerRadius = 20;
    self.userHeadImage.backgroundColor = System_BlueColor;
    [self.view addSubview:self.userHeadImage];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(52, 5+originY, 100, 20)];
    self.userName.text = @"用户名";
    self.userName.font = [UIFont systemFontOfSize:15.0];
    self.userName.textColor = System_BlueColor;
    [self.view addSubview:self.userName];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 5+originY, 60, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    self.timeLabel.text = @"1分钟前";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.timeLabel];
    
    self.trendLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 30+originY, 248, 10)];
    self.trendLabel.text = @"他你我他你我他你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我";
    [self.trendLabel resizeToFit];
    [self.view addSubview:self.trendLabel];
    
//    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.trendLabel.frame.origin.y+self.trendLabel.frame.size.height+20, 320, 1)];
//    self.lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.lineView];
//
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
