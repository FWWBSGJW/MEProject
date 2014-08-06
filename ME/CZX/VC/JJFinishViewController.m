//
//  JJFinishViewController.m
//  在线教育
//
//  Created by Johnny's on 14-7-11.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJFinishViewController.h"
#import "JJTestDetailViewController.h"
#import "ReviewController.h"
#import "ScoreTableViewCell.h"
#import "WrongSubjectViewController.h"
#import "JJSubjectManage.h"
#import "RangkingModel.h"
#import "UIImageView+WebCache.h"
#import "RankingManage.h"
#import <ShareSDK/ShareSDK.h>

@interface JJFinishViewController ()
{
    NSString *myScore;
    NSArray *myCorrectArray;
    NSArray *myPersonArray;
    NSArray *myQuestionArray;
    NSArray *myAnswerArray;
    int myMins;
    int mySeconds;
}

@property(nonatomic, strong) UILabel *alertLabel;
@end

@implementation JJFinishViewController
@synthesize scoreTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithScore:(NSString *)score correctAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray costMins:(int)paramMins costSeconds:(int)paramSeconds
{
    self = [super init];
    if (self) {
        myScore = score;
        myCorrectArray = correctArray;
        myPersonArray = personArray;
        myQuestionArray = queArray;
        myAnswerArray = anArray;
        myMins = paramMins;
        mySeconds = paramSeconds;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[[RankingManage alloc] init] analyseRankingJsonForVC:self withUrl:self.highScoreUrl];
}

- (IBAction)share:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    NSString *content = [NSString stringWithFormat:@"正在使用ME手机app学习java，c++等，还在测试中得了%d分，你们也来学习吧！", [myScore intValue]];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"分享"
                                                  url:nil
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)achieveScoreView
{
    scoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    scoreTableView.scrollEnabled = NO;
    scoreTableView.allowsSelection = NO;
    scoreTableView.delegate = self;
    scoreTableView.dataSource = self;
    [self.scoreView addSubview:scoreTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell * lableSwitchCell;
    UINib *n;
    static NSString *CellIdentifier = @"ScoreTableViewCell";
    lableSwitchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lableSwitchCell == nil)
    {
        NSArray *_nib=[[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell"
                                                    owner:self  options:nil];
        lableSwitchCell  = [_nib objectAtIndex:0];
        //通过这段代码，来完成LableSwitchXibCell的ReuseIdentifier的设置
        //这里是比较容易忽视的，若没有此段，再次载入LableSwitchXibCell时，dequeueReusableCellWithIdentifier:的值依然为nil
        n= [UINib nibWithNibName:@"PlayScoreviewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:n forCellReuseIdentifier:@"PlayScoreviewCell"];
    }
    lableSwitchCell.headView.backgroundColor = [UIColor orangeColor];
    lableSwitchCell.rankingLa.text = [NSString stringWithFormat:@"%d", [indexPath row]+1];
    if (indexPath.row<self.scoreArray.count)
    {
        RangkingModel *model = [self.scoreArray objectAtIndex:indexPath.row];
        [lableSwitchCell.headView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, model.userPortrait]]];
        lableSwitchCell.nameLa.text = model.userName;
        lableSwitchCell.scoreLa.text = [NSString stringWithFormat:@"考%d分", (int)model.score];
        lableSwitchCell.timeLa.text = [NSString stringWithFormat:@"时间%d", (int)model.time];
        lableSwitchCell.tag = indexPath.row;
        [lableSwitchCell.imageBtn addTarget:self action:@selector(touchHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return lableSwitchCell;
}

- (void)touchHeadImage:(id)sender
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = RGBCOLOR(222, 255, 170);
    self.scoreLa.text = myScore;
    self.timeLa.text = [NSString stringWithFormat:@"%02d:%02d", myMins, mySeconds];
    [self.reviewBtn addTarget:self action:@selector(review)
             forControlEvents:UIControlEventTouchUpInside];
    [self changeBackground:[myScore intValue]];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 230, 20, 20)];
    [self.activityView startAnimating];
    self.activityView.color = [UIColor blackColor];
    [self.view addSubview:self.activityView];
    if (self.result == 0)
    {
//        [self createWinView];
        self.winnerLabel.text = @"很可惜,没上榜...";
        self.winnerLabel.textColor = [UIColor blackColor];
        self.winnerLabel.font = [UIFont systemFontOfSize:20];
    }
    
//    [self achieveScoreView];
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT/2-60, 120, 60)];
        _alertLabel.layer.cornerRadius = 10;
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.backgroundColor = [UIColor whiteColor];
        _alertLabel.textColor = [UIColor orangeColor];
        _alertLabel.alpha = 0.9;
        _alertLabel.text = @"";
        [_alertLabel setTextAlignment:NSTextAlignmentCenter];
        _alertLabel.font = [UIFont systemFontOfSize:13.0];
        _alertLabel.text = @"恭喜上榜！";
    }
    return _alertLabel;
}

- (void)createWinView
{
    [[UIApplication sharedApplication].keyWindow addSubview:[self alertLabel]];
    [UIView animateKeyframesWithDuration:2.0f delay:0.6f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.alertLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.alertLabel removeFromSuperview];
        self.alertLabel = nil;
    }];
}

- (void)changeBackground:(int)paramScore
{
//    if (paramScore<60)
//    {
//        self.view.backgroundColor = [UIColor blueColor];
//    }
//    else if(paramScore>60 && paramScore<80)
//    {
//        self.view.backgroundColor = [UIColor greenColor];
//    }
//    else if(paramScore>80 && paramScore<90)
//    {
//        self.view.backgroundColor = [UIColor orangeColor];
//    }
//    else
//    {
//        self.view.backgroundColor = [UIColor redColor];
//    }
}

- (void)review
{
    [self.navigationController pushViewController:[[ReviewController alloc] initWithCorrectAnswer:myCorrectArray personAnswer:myPersonArray questionArray:myQuestionArray answerArray:myAnswerArray] animated:YES];
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
