//
//  JJMeasurementViewController.m
//  在线教育
//
//  Created by Johnny's on 14-7-10.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJMeasurementViewController.h"
#import "UILabel+dynamicSizeMe.h"
#import "JJFinishViewController.h"
#import "JJSubjectModel.h"
#import "JJSubjectManage.h"
#import "UserIntegralModel.h"

//#define KColor RGBCOLOR(222, 255, 170)
#define KColor RGBCOLOR(50, 126, 254)
//#define KColor [UIColor orangeColor]


@interface JJMeasurementViewController ()
{
    NSMutableArray *queArray;
    NSMutableArray *anArray;
    NSMutableArray *queIdArray;
    NSArray *currentAnArray;
    NSMutableArray *correctAnArray;
    NSMutableArray *numberOfCorrectAnArray;
    int page;
    UILabel *textView;
    NSMutableArray *personNumAnswerArray;
    NSMutableArray *personRealArray;
    UIAlertView *leaveAlertView;
    UILabel *timeLabel;
    int timeCount;
    NSTimer *timer;
    int mins;
    NSMutableArray *voidArray;
    UIViewController *modalVC;
    NSArray *optionArray;
    UIButton *rightButton;
    int subjectCount;
    int costTime;
    NSMutableParagraphStyle *textViewPS;
    NSDictionary *textViewAttribs;
    NSMutableArray *wrongSubjectArray;
}
@property(nonatomic, strong) UILabel *alertLabel;
@end

@implementation JJMeasurementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithSubjectDetailUrl:(NSString *)paramUrl time:(int)paramTime
{
    self = [super init];
    if(self){
        [[[JJSubjectManage alloc] init] analyseSubjectJson:paramUrl forSubjectVC:self];
        mins = paramTime-1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    costTime=1;
    timeCount = 1;
    page = 0;
    subjectCount = 0;
    optionArray = @[@"A. ", @"B. ", @"C. ", @"D. "];
    //    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    //    topView.backgroundColor = KColor;
    
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        backBtn.titleLabel.textAlignment= NSTextAlignmentLeft;
        backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        //    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn setTitle:@"退出" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        self.navigationItem.leftBarButtonItem = backBarItem;
        //    [topView addSubview:backBtn];
        //
        //    UILabel *testTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 22, 160, 40)];
        //    testTitle.text = @"Oracle PL实战测试";
        //    testTitle.textAlignment = NSTextAlignmentCenter;
        //    [topView addSubview:testTitle];
        
        [self createPagingBtn];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 440, 80, 40)];
        timeLabel.backgroundColor = KColor;
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
    //    timeLabel.textColor = [UIColor whiteColor];
        timeLabel.text = [NSString stringWithFormat:@"%d:59", mins];
        timeLabel.font = [UIFont systemFontOfSize:20];
        
        self.measureTableView = [[UITableView alloc]
                            initWithFrame:CGRectMake(0, 5, 320, SCREEN_HEIGHT-5)
                            style:UITableViewStylePlain];
        self.measureTableView.delegate = self;
        self.measureTableView.dataSource = self;
        
//        [self getSubjectDetail];
    
        
        currentAnArray = [anArray objectAtIndex:0];
        self.measureTableView.tableFooterView = [[UIView alloc] init];
        
        //    [self.view addSubview:topView];
        [self.view addSubview:self.measureTableView];
        [self.view addSubview:self.upBtn];
        [self.view addSubview:self.downBtn];
        [self.view addSubview:timeLabel];
        [self createSubjectBtn];
        
        leaveAlertView = [[UIAlertView alloc] initWithTitle:@"正在测试中" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"继续测试" otherButtonTitles:@"我要退出",nil];
        
    
        rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        rightButton.titleLabel.textAlignment= NSTextAlignmentRight;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitle:[NSString stringWithFormat:@"%d/%d", subjectCount, queArray.count]
                     forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 230, 20, 20)];
    [self.activityView startAnimating];
    self.activityView.color = [UIColor blackColor];
    [self.view addSubview:self.activityView];

//        [self startTimer];
    textViewPS = [[NSMutableParagraphStyle alloc] init];
    [textViewPS setLineSpacing:5.0];
    textViewAttribs = [NSDictionary new];
    textViewAttribs = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:16],NSParagraphStyleAttributeName:textViewPS};
    
    wrongSubjectArray = [[NSMutableArray alloc] init];
}

#pragma mark 无数据
- (void)noData
{
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(100, 220, 120, 40)];
    la.textAlignment = NSTextAlignmentCenter;
    la.text = @"没题目";
    [self.view addSubview:la];
}


#pragma mark reload
- (void)getSubjectDetail
{
    queArray = [[NSMutableArray alloc] init];
    queIdArray = [[NSMutableArray alloc] init];
    anArray = [[NSMutableArray alloc] init];
    correctAnArray = [[NSMutableArray alloc] init];
    numberOfCorrectAnArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.subjectArray.count; i++)
    {
        JJSubjectModel *subjectModel = [self.subjectArray objectAtIndex:i];
        [queArray addObject:subjectModel.ceContext];
        [queIdArray addObject:[NSString stringWithFormat:@"%d", subjectModel.ceId]];
        [anArray addObject:subjectModel.options];
        [correctAnArray addObject:subjectModel.ceAnswer];
    }
    NSArray *temArray = @[@"a", @"b", @"c", @"d"];
    for (int i=0; i<correctAnArray.count; i++)
    {
        for (int j=0; j<temArray.count; j++)
        {
            NSString *aStr = [temArray objectAtIndex:j];
            NSString *bStr = [correctAnArray objectAtIndex:i];
            if ([aStr isEqual: bStr])
            {
                [numberOfCorrectAnArray addObject:[NSString stringWithFormat:@"%d", j]];
                break;
            }
        }
    }

    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    textView.font = [UIFont systemFontOfSize:18.0];
    textView.text = [NSString stringWithFormat:@"%d.%@", 1, [queArray objectAtIndex:0]];
//    NSMutableAttributedString *textViewString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d.%@", 1, [queArray objectAtIndex:0]] attributes:textViewAttribs];
//    textView.attributedText = textViewString;
    [textView resizeToFit];
    self.measureTableView.tableHeaderView = textView;
    personNumAnswerArray = [[NSMutableArray alloc] init];
    personRealArray = [[NSMutableArray alloc] init];
    for (int count=0; count<queArray.count; count++) {
        [personNumAnswerArray addObject:@"4"];
        [personRealArray addObject:@"4"];
    }
    currentAnArray = [anArray objectAtIndex:page];
    [rightButton setTitle:[NSString stringWithFormat:@"%d/%d", subjectCount, queArray.count]
                 forState:UIControlStateNormal];
}

- (void)createPagingBtn
{
    self.upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 440, 60, 40)];
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 440, 60, 40)];
    [self.upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    //    [self.downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"upUp"] forState:UIControlStateHighlighted];
    //    [self.downBtn setImage:[UIImage imageNamed:@"downUp"] forState:UIControlStateHighlighted];
    [self.upBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.downBtn setTitle:@"下一题" forState:UIControlStateNormal];
    self.upBtn.backgroundColor = KColor;
    self.downBtn.backgroundColor = KColor;
    [self.upBtn addTarget:self action:@selector(upPage) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(downPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createSubjectBtn
{
    self.handInBtn = [[UIButton alloc] initWithFrame:CGRectMake(60, 440, 60, 40)];
    self.reviewBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 440, 60, 40)];
    [self.handInBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reviewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.handInBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.reviewBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.handInBtn setTitle:@"交卷" forState:UIControlStateNormal];
    [self.reviewBtn setTitle:@"查看" forState:UIControlStateNormal];
    self.handInBtn.backgroundColor = KColor;
    self.reviewBtn.backgroundColor = KColor;
    [self.handInBtn addTarget:self action:@selector(verifyHangIn)
             forControlEvents:UIControlEventTouchUpInside];
    [self.reviewBtn addTarget:self action:@selector(review:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.handInBtn];
    [self.view addSubview:self.reviewBtn];
}

#pragma mark 空题
- (void)searchVoidSubject
{
    voidArray = [[NSMutableArray alloc] init];
    for (int i=0; i<queArray.count; i++)
    {
        if ([[personNumAnswerArray objectAtIndex:i]  isEqual: @"4"])
        {
            [voidArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}


#pragma mark 交卷
- (void)verifyHangIn
{
    [self searchVoidSubject];
    if (voidArray.count>0)
    {
        NSString *message = [NSString stringWithFormat:@"你还有%d题还没做", voidArray.count];
        UIAlertView *handInAlert = [[UIAlertView alloc] initWithTitle:@"确认交卷吗" message:message delegate:self cancelButtonTitle:@"继续答题" otherButtonTitles:@"确认交卷", nil];
        [handInAlert show];
    }
    else
    {
        UIAlertView *handInAlert = [[UIAlertView alloc] initWithTitle:@"全部完成了！" message:@"交卷还是检查一下" delegate:self cancelButtonTitle:@"检查" otherButtonTitles:@"交卷", nil];
        [handInAlert show];
    }
}

- (void)handIn
{
    [timer invalidate];
    timer = nil;
    
    int myMins = costTime/60;
    int mySeconds = costTime%60;
    int score = 0;
    JJSubjectManage *manage = [[JJSubjectManage alloc] init];
//    [manage saveDirectionModel:[[NSArray alloc] init]];
    wrongSubjectArray = [[NSMutableArray alloc] init];
    [wrongSubjectArray addObjectsFromArray:[manage queryModels]];
    int a = wrongSubjectArray.count;
    for (int i=0; i<numberOfCorrectAnArray.count; i++)
    {
        NSString *aStr = [numberOfCorrectAnArray objectAtIndex:i];
        NSString *bStr = [personNumAnswerArray objectAtIndex:i];
        if ([aStr isEqual:bStr])
        {
            score++;
        }
        if (![[personNumAnswerArray objectAtIndex:i] isEqualToString:@"4"])
        {
            if (![[personNumAnswerArray objectAtIndex:i] isEqualToString:[numberOfCorrectAnArray objectAtIndex:i]])
            {
                JJSubjectModel *model = [self.subjectArray objectAtIndex:i];
                int aCount=0;
                for (int i=0; i<wrongSubjectArray.count; i++)
                {
                    JJSubjectModel *aModel = [wrongSubjectArray objectAtIndex:i];
                    if (model.ceId==aModel.ceId)
                    {
                        break;
                    }
                    aCount++;
                }
                if (wrongSubjectArray == nil) {
                    [wrongSubjectArray addObject:model];
                }
                else if (aCount==wrongSubjectArray.count) {
                    [wrongSubjectArray addObject:model];
                }
            }
        }
    }
    [manage saveDirectionModel:wrongSubjectArray];
    int b = wrongSubjectArray.count-a;
    if (b>0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%d题加入错题本", b] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    NSArray *abc = @[@"A", @"B", @"C", @"D", @"E"];
    for (int count=0; count<queArray.count; count++)
    {
        int a = [[personNumAnswerArray objectAtIndex:count] intValue];
        [personRealArray replaceObjectAtIndex:count withObject:[abc objectAtIndex:a]];
    }
    
    float rate = score/queArray.count;
    int intergral = 0;
    if (rate>=0.6 && rate<0.8)
    {
        intergral = 3;
    }
    else if (rate>=0.8 && rate<0.9)
    {
        intergral = 5;
    }
    else if(rate>=0.9 && rate<1.0)
    {
        intergral = 6;
    }
    else if(rate==1.0)
    {
        intergral = 7;
    }
    else
    {
        intergral = 1;
    }
    
    //现在的时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  nowTime = [dateformatter stringFromDate:senddate];
    
    UserIntegralModel *model = [[[UserIntegralModel alloc] init] queryModels];
    if (model)
    {
        if (model.testCount)
        {
            if ([model.uTime isEqualToString:nowTime])
            {
                if (model.testCount<5)
                {
                    [self postIntergral:intergral];
                    model.testCount++;
                    [[[UserIntegralModel alloc] init] saveDirectionModel:model];
                }
            }
            else
            {
                model.uTime = nowTime;
                model.testCount = 1;
                [self postIntergral:intergral];
                [[[UserIntegralModel alloc] init] saveDirectionModel:model];
            }
        }
        else
        {
            model.uTime = nowTime;
            model.testCount = 1;
            [self postIntergral:intergral];
            [[[UserIntegralModel alloc] init] saveDirectionModel:model];
        }
    }
    else
    {
        UserIntegralModel *model = [[UserIntegralModel alloc] init];
        model.uTime = nowTime;
        model.testCount = 1;
        model.userId = [User sharedUser].info.userId;
        [self postIntergral:intergral];
        [[[UserIntegralModel alloc] init] saveDirectionModel:model];
    }
    
//    NSLog(@"%@", personRealArray);
    JJFinishViewController *vc = [[JJFinishViewController alloc]
                                  initWithScore:[NSString stringWithFormat:@"%d", score*10]
                                  correctAnswer:numberOfCorrectAnArray
                                  personAnswer:personNumAnswerArray
                                  questionArray:queArray
                                  answerArray:anArray costMins:myMins costSeconds:mySeconds];
    vc.highScoreUrl = self.highScoreUrl;
    vc.result = [self postGrade:score*10 withTCid:self.tcid hmtime:myMins hstime:mySeconds];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)postIntergral:(int)paramIntergral
{
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%d&upoints=%d", [User sharedUser].info.userId, paramIntergral]];
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
    
    UIAlertView *aalert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"恭喜你获得%d积分", paramIntergral] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [aalert show];
}

- (int)postGrade:(int)score withTCid:(int)tcid hmtime:(int)hmtime hstime:(int)hstime
{
    User *user = [User sharedUser];
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/uploadScore";
    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%d&hscore=%d&tcId=%d&hmtime=%d&hstime=%d",user.info.userId, score, tcid, hmtime, hstime]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.5f];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([data length] >0 &&
        error == nil){
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"HTML = %@", html);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        return [[dict objectForKey:@"success"] intValue];
    }
    else if ([data length] == 0 &&
             error == nil){
        NSLog(@"Nothing was downloaded.");
    }
    else if (error != nil){
        NSLog(@"Error happened = %@", error);
    }
    return 0;
}

#pragma mark 回顾
- (void)review:(id)sender
{
    [self createModalVC];
}

#pragma mark 计时
- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeUp:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timeUp:(NSTimer *)paramTimer
{
    costTime++;
    timeCount++;
    if (timeCount==60)
    {
        timeCount=1;
        mins --;
    }
    if (timeCount>=51)
    {
        timeLabel.text = [NSString stringWithFormat:@"%d:0%d", mins, 60-timeCount];
    }
    else
    {
        timeLabel.text = [NSString stringWithFormat:@"%d:%2.d", mins, 60-timeCount];
    }
    if (mins==0&&timeCount==59)
    {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark 离开按钮
- (void)pop
{
    [leaveAlertView show];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return currentAnArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableAttributedString *str =[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [optionArray objectAtIndex:indexPath.row], [currentAnArray objectAtIndex:[indexPath row]]]                                                              attributes:textViewAttribs];

    return [self returnHeight:str];
}

- (CGFloat)returnHeight:(NSMutableAttributedString *)paramStr
{
    CGFloat height = ([paramStr size].width/200+1)*[paramStr size].height;
    if (height<43) {
        return 43;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [optionArray objectAtIndex:indexPath.row], [currentAnArray objectAtIndex:[indexPath row]]]                                                              attributes:textViewAttribs];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, [self returnHeight:aStr])];
    label.numberOfLines = 0;
    label.attributedText = aStr;
    [cell addSubview:label];
    if (indexPath.row == [[personNumAnswerArray objectAtIndex:page] intValue])
    {
        cell.backgroundColor = KColor;
    }
    if (indexPath.row == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        view.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:view];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.measureTableView setUserInteractionEnabled:NO];
    int newRow = [indexPath row];
    for (int index=0; index<4; index++)
    {
        NSIndexPath *temindexpath = [NSIndexPath indexPathForRow:index inSection:0];
        [tableView cellForRowAtIndexPath:temindexpath].backgroundColor = [UIColor clearColor];
    }
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[tableView cellForRowAtIndexPath:indexPath] cache:YES];
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = KColor;
    [UIView commitAnimations];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [personNumAnswerArray replaceObjectAtIndex:page withObject:[NSString stringWithFormat:@"%d", newRow]];
    [self performSelector:@selector(downPage) withObject:self afterDelay:0.8];
    subjectCount ++;
    [self searchVoidSubject];
    [rightButton setTitle:[NSString stringWithFormat:@"%d/%d", queArray.count-voidArray.count, queArray.count]
                 forState:UIControlStateNormal];
    [self performSelector:@selector(tableViewUserEnabled) withObject:nil afterDelay:0.8];
}

- (void)tableViewUserEnabled
{
    [self.measureTableView setUserInteractionEnabled:YES];
}


#pragma mark 翻页
- (void)upPage
{
    if (page == 0)
    {
        [self createView];
    }
    else
    {
        page--;
        [self reloadMyTable];
    }
}

- (UILabel *)alertLabel
{
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT/2-60, 120, 60)];
        _alertLabel.layer.cornerRadius = 10;
        _alertLabel.layer.masksToBounds = YES;
        _alertLabel.backgroundColor = [UIColor blackColor];
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.alpha = 0.9;
        _alertLabel.text = @"";
        [_alertLabel setTextAlignment:NSTextAlignmentCenter];
        _alertLabel.font = [UIFont systemFontOfSize:13.0];
        _alertLabel.text = @"已到第一页";
    }
    return _alertLabel;
}

- (void)createView
{
    [[UIApplication sharedApplication].keyWindow addSubview:[self alertLabel]];
    [UIView animateKeyframesWithDuration:0.4f delay:0.6f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.alertLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.alertLabel removeFromSuperview];
        self.alertLabel = nil;
    }];
}


- (void)downPage
{
    if (page<queArray.count-1)
    {
        page++;
        [self reloadMyTable];
    }
    else
    {
        [self searchVoidSubject];
        if (voidArray.count>0)
        {
            NSString *message = [NSString stringWithFormat:@"已经到最后一题，但你还有%d题还没做，要交卷吗？", voidArray.count];
            UIAlertView *handInAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"继续答题" otherButtonTitles:@"确认交卷", nil];
            [handInAlert show];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"已经到最后一题,要交卷吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"交卷", nil];
            [alertView show];
        }
    }
}

- (void)reloadMyTable
{
    currentAnArray = [anArray objectAtIndex:page];
    textView.text = [NSString stringWithFormat:@"%d.%@",page+1 ,[queArray objectAtIndex:page]];
//    NSMutableAttributedString *textViewString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d.%@",page+1 ,[queArray objectAtIndex:page]] attributes:textViewAttribs];
//    textView.attributedText = textViewString;
    [textView resizeToFit];
    CGRect frame = textView.frame;
    frame.size.height += 15;
    textView.frame = frame;

    self.measureTableView.tableHeaderView = textView;
    [self.measureTableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView == leaveAlertView)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self handIn];
        }
    }
}


#pragma mark 模态界面
- (void)createModalVC
{
    modalVC = [[UIViewController alloc] init];
    modalVC.view.backgroundColor = [UIColor whiteColor];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLa.text = @"查看题目";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLa];
    titleView.userInteractionEnabled = YES;
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
    [dismissBtn setTitle:@"返回" forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissBtn];
    [modalVC.view addSubview:titleView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, 320, 416)];
    [self searchVoidSubject];
    int voidCount = 0;
    int line = 0;
    for (int i=0; i<queArray.count; i++)
    {
        int row = i%4;
        line = i/4;
        UIButton *subjectBtn = [[UIButton alloc]
                                initWithFrame:CGRectMake(80*row, 80*line, 80, 80)];
        subjectBtn.tag = 100+i;
        [subjectBtn setTitle:[NSString stringWithFormat:@"%d", i+1]
                    forState:UIControlStateNormal];
        [subjectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [subjectBtn addTarget:self action:@selector(selectSubject:)
             forControlEvents:UIControlEventTouchUpInside];
        subjectBtn.backgroundColor = KColor;
        [subjectBtn.layer setBorderWidth:0.3];
        [subjectBtn.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        if (voidArray.count>0 && voidCount<voidArray.count && i==[[voidArray objectAtIndex:voidCount] intValue])
        {
            voidCount++;
            subjectBtn.backgroundColor = [UIColor whiteColor];
        }
        [scrollView addSubview:subjectBtn];
    }
    scrollView.contentSize = CGSizeMake(320, 80*(line+1));
    [modalVC.view addSubview:scrollView];
    [self presentViewController:modalVC animated:YES completion:^{
        
    }];
}

- (void)selectSubject:(UIButton *)subjectBtn
{
    [modalVC dismissViewControllerAnimated:YES completion:^{
        page = subjectBtn.tag - 100;
        [self reloadMyTable];
    }];
}

- (void)dismissViewController
{
    [modalVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
