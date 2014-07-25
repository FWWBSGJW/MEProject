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

//#define KColor RGBCOLOR(80, 240, 180)
#define KColor [UIColor orangeColor];


@interface JJMeasurementViewController ()
{
    NSArray *queArray;
    NSArray *anArray;
    NSArray *currentAnArray;
<<<<<<< HEAD
    NSMutableArray *correctAnArray;
    NSMutableArray *numberOfCorrectAnArray;
=======
>>>>>>> parent of 0ea4e60... Merge branch 'master' of https://github.com/FWWBSGJW/MEProject
    int page;
    UILabel *textView;
    UITableView *measureTableView;
    NSMutableArray *personNumAnswerArray;
    NSMutableArray *personRealArray;
    UIAlertView *leaveAlertView;
    UILabel *timeLabel;
    int timeCount;
    NSTimer *timer;
    int mins;
    NSMutableArray *voidArray;
    UIViewController *modalVC;
<<<<<<< HEAD
    NSArray *optionArray;
    UIButton *rightButton;
    int subjectCount;
=======
>>>>>>> parent of 0ea4e60... Merge branch 'master' of https://github.com/FWWBSGJW/MEProject
}
@end

@implementation JJMeasurementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    timeCount = 1;
    mins = 0;
    page = 0;
<<<<<<< HEAD
    subjectCount = 0;
    optionArray = @[@"A. ", @"B. ", @"C. ", @"D. "];
    //    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    //    topView.backgroundColor = KColor;
    
    if (subjectArray.count>0)
    {
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
        
        measureTableView = [[UITableView alloc]
                            initWithFrame:self.view.bounds
                            style:UITableViewStylePlain];
        measureTableView.delegate = self;
        measureTableView.dataSource = self;
        
        [self getSubjectDetail];
        
        textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        textView.text = [NSString stringWithFormat:@"%d.%@", 1, [queArray objectAtIndex:0]];
        textView.font = [UIFont systemFontOfSize:18.0];
        [textView resizeToFit];
        
        currentAnArray = [anArray objectAtIndex:0];
        measureTableView.tableHeaderView = textView;
        measureTableView.tableFooterView = [[UIView alloc] init];
        
        //    [self.view addSubview:topView];
        [self.view addSubview:measureTableView];
        [self.view addSubview:self.upBtn];
        [self.view addSubview:self.downBtn];
        [self.view addSubview:timeLabel];
        [self createSubjectBtn];
        
        leaveAlertView = [[UIAlertView alloc] initWithTitle:@"正在测试中" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"继续测试" otherButtonTitles:@"我要退出",nil];
        
        personNumAnswerArray = [[NSMutableArray alloc] init];
        personRealArray = [[NSMutableArray alloc] init];
        for (int count=0; count<queArray.count; count++) {
            [personNumAnswerArray addObject:@"4"];
            [personRealArray addObject:@"4"];
        }
        
        rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        rightButton.titleLabel.textAlignment= NSTextAlignmentRight;
        rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightButton setTitle:[NSString stringWithFormat:@"%d/%d", subjectCount, queArray.count]
                     forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        
            [self startTimer];
    }
    else
    {
        UILabel *La = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 80)];
        La.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        La.textAlignment = NSTextAlignmentCenter;
        La.text = @"题目还没出好~~";
        [self.view addSubview:La];
    }
    
    
}

- (void)getSubjectDetail
{
    queArray = [[NSMutableArray alloc] init];
    queIdArray = [[NSMutableArray alloc] init];
    anArray = [[NSMutableArray alloc] init];
    correctAnArray = [[NSMutableArray alloc] init];
    numberOfCorrectAnArray = [[NSMutableArray alloc] init];
    for (int i=0; i<subjectArray.count; i++)
    {
        JJSubjectModel *subjectModel = [subjectArray objectAtIndex:i];
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
    NSLog(@"%@,%@", correctAnArray, numberOfCorrectAnArray);
=======
    
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
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.text = [NSString stringWithFormat:@"%d:59", mins];
    timeLabel.font = [UIFont systemFontOfSize:20];
    
    measureTableView = [[UITableView alloc]
                        initWithFrame:self.view.bounds
                        style:UITableViewStylePlain];
    measureTableView.delegate = self;
    measureTableView.dataSource = self;
    measureTableView.scrollEnabled = NO;
    
    NSString *quePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    queArray = [NSArray arrayWithContentsOfFile:quePath];
    currentAnArray = [[NSArray alloc] init];
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    textView.text = [queArray objectAtIndex:0];
    textView.font = [UIFont systemFontOfSize:18.0];
    [textView resizeToFit];
    
    NSString *anPath = [[NSBundle mainBundle] pathForResource:@"answer" ofType:@"plist"];
    anArray = [NSArray arrayWithContentsOfFile:anPath];
    
    currentAnArray = [anArray objectAtIndex:0];
    measureTableView.tableHeaderView = textView;
    measureTableView.tableFooterView = [[UIView alloc] init];
    
    //    [self.view addSubview:topView];
    [self.view addSubview:measureTableView];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.downBtn];
    [self.view addSubview:timeLabel];
    [self createSubjectBtn];
    
    leaveAlertView = [[UIAlertView alloc] initWithTitle:@"正在测试中" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"继续测试" otherButtonTitles:@"我要退出",nil];
    
    personAnswerArray = [[NSMutableArray alloc] init];
    personRealArray = [[NSMutableArray alloc] init];
    for (int count=0; count<queArray.count; count++) {
        [personAnswerArray addObject:@"4"];
        [personRealArray addObject:@"4"];
    }
    
    [self startTimer];
>>>>>>> parent of 0ea4e60... Merge branch 'master' of https://github.com/FWWBSGJW/MEProject
}

- (void)createPagingBtn
{
    self.upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 440, 60, 40)];
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 440, 60, 40)];
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
    int score = 0;
    for (int i=0; i<numberOfCorrectAnArray.count; i++)
    {
        NSString *aStr = [numberOfCorrectAnArray objectAtIndex:i];
        NSString *bStr = [personNumAnswerArray objectAtIndex:i];
        if ([aStr isEqual:bStr])
        {
            score++;
        }
    }
    NSArray *abc = @[@"A", @"B", @"C", @"D", @"E"];
    for (int count=0; count<queArray.count; count++)
    {
        int a = [[personNumAnswerArray objectAtIndex:count] intValue];
        [personRealArray replaceObjectAtIndex:count withObject:[abc objectAtIndex:a]];
    }
    NSLog(@"%@", personRealArray);
    [self.navigationController pushViewController:[[JJFinishViewController alloc]
                                                   initWithScore:[NSString stringWithFormat:@"%d", score*10]
                                                   correctAnswer:numberOfCorrectAnArray
                                                   personAnswer:personNumAnswerArray
                                                   questionArray:queArray
                                                   answerArray:anArray]
                                         animated:YES];
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
}

- (void)timeUp:(NSTimer *)paramTimer
{
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [currentAnArray objectAtIndex:[indexPath row]];
    [cell.textLabel resizeToFit];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    if (indexPath.row == [[personNumAnswerArray objectAtIndex:page] intValue])
    {
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor orangeColor];
    [UIView commitAnimations];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [personNumAnswerArray replaceObjectAtIndex:page withObject:[NSString stringWithFormat:@"%d", newRow]];
    [self performSelector:@selector(downPage) withObject:self afterDelay:0.8];
    subjectCount ++;
    [rightButton setTitle:[NSString stringWithFormat:@"%d/%d", subjectCount, queArray.count]
                 forState:UIControlStateNormal];
}


#pragma mark 翻页
- (void)upPage
{
    if (page == 0)
    {
        
    }
    else
    {
        page--;
        [self reloadMyTable];
    }
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
    textView.text = [queArray objectAtIndex:page];
    [textView resizeToFit];
    measureTableView.tableHeaderView = textView;
    [measureTableView reloadData];
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
        subjectBtn.backgroundColor = [UIColor orangeColor];
        [subjectBtn.layer setBorderWidth:0.3];
        [subjectBtn.layer setBorderColor:[UIColor blackColor].CGColor];
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
