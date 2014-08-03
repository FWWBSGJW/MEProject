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

- (void)achieveScoreView
{
    scoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    scoreTableView.scrollEnabled = NO;
    scoreTableView.userInteractionEnabled = NO;
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
    }
    
    return lableSwitchCell;
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

//    [self achieveScoreView];
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

- (IBAction)wrongSubject:(id)sender
{
    [self.navigationController pushViewController:[[WrongSubjectViewController alloc] initWithWrongSubjectArray:[[[JJSubjectManage alloc] init] queryModels]] animated:YES];
}
@end
