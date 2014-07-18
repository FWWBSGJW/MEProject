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

@interface JJMeasurementViewController ()
{
    NSArray *queArray;
    NSArray *anArray;
    NSArray *nowAnArray;
    int i;
    int j;
    UILabel *textView;
    UITableView *measureTableView;
    NSMutableArray *personAnswerArray;
    NSMutableArray *personRealArray;
    UIAlertView *leaveAlertView;
    UILabel *timeLabel;
    int timeCount;
    NSTimer *timer;
    int mins;
//    NSIndexPath *lastIndexPath;
//    NSMutableArray *personAnswerIndexPathArray;
}
@end

@implementation JJMeasurementViewController

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
//    [JJTabBarViewController share].tabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    timeCount = 1;
    mins = 0;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    i=0;
    self.upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 440, 120, 40)];
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 440, 120, 40)];
    [self.upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [self.downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [self.upBtn setImage:[UIImage imageNamed:@"upUp"] forState:UIControlStateHighlighted];
    [self.downBtn setImage:[UIImage imageNamed:@"downUp"] forState:UIControlStateHighlighted];
    [self.upBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.downBtn setTitle:@"下一题" forState:UIControlStateNormal];
    self.upBtn.backgroundColor = RGBCOLOR(80, 240, 180);
    self.downBtn.backgroundColor = RGBCOLOR(80, 240, 180);
    [self.upBtn addTarget:self action:@selector(upPage) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(downPage) forControlEvents:UIControlEventTouchUpInside];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 440, 80, 40)];
    timeLabel.backgroundColor = RGBCOLOR(80, 240, 180);
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:20];
    
    measureTableView = [[UITableView alloc]
                                     initWithFrame:self.view.bounds style:UITableViewStylePlain];
    measureTableView.delegate = self;
    measureTableView.dataSource = self;
    measureTableView.scrollEnabled = NO;
    
    NSString *quePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
    queArray = [NSArray arrayWithContentsOfFile:quePath];
    nowAnArray = [[NSArray alloc] init];
    
    textView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    textView.backgroundColor = RGBCOLOR(175, 245, 220);
    textView.text = [queArray objectAtIndex:0];
    textView.font = [UIFont systemFontOfSize:18.0];
    [textView resizeToFit];
//    [self.view addSubview:textView];
    
    NSString *anPath = [[NSBundle mainBundle] pathForResource:@"answer" ofType:@"plist"];
    anArray = [NSArray arrayWithContentsOfFile:anPath];

    nowAnArray = [anArray objectAtIndex:0];
    measureTableView.tableHeaderView = textView;
    measureTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:measureTableView];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.downBtn];
    [self.view addSubview:timeLabel];
    self.upBtn.userInteractionEnabled = NO;
    
    leaveAlertView = [[UIAlertView alloc] initWithTitle:@"正在测试中" message:@"你确定要退出吗？" delegate:self cancelButtonTitle:@"继续测试" otherButtonTitles:@"我要退出",nil];
    
//    personAnswerArray = [NSMutableArray arrayWithCapacity:queArray.count];
    personAnswerArray = [[NSMutableArray alloc] init];
    personRealArray = [[NSMutableArray alloc] init];
    for (int count=0; count<queArray.count; count++) {
        [personAnswerArray addObject:@"-1"];
        [personRealArray addObject:@"-1"];
    }
    
    [self startTimer];
}

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

- (void)pop
{
    [leaveAlertView show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [nowAnArray objectAtIndex:[indexPath row]];
    [cell.textLabel resizeToFit];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    if (indexPath.row == [[personAnswerArray objectAtIndex:i] intValue])
    {
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
}

- (void)upPage
{
    i--;
    if (i != 9) {
        [[self.view viewWithTag:100] removeFromSuperview];
    }
    [self reloadMyTable];
}

- (void)downPage
{
    if (i<queArray.count-1)
    {
        if ([[personAnswerArray objectAtIndex:i] intValue] == -1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wrong" message:@"你还没有选择选项" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
        }else{
            i++;
            [self reloadMyTable];
        }
    }
}

- (void)reloadMyTable
{
    nowAnArray = [anArray objectAtIndex:i];
    textView.text = [queArray objectAtIndex:i];
    [textView resizeToFit];
    measureTableView.tableHeaderView = textView;
    [measureTableView reloadData];
    if (i == 0)
    {
        self.upBtn.userInteractionEnabled = NO;
    }else{
        self.upBtn.userInteractionEnabled = YES;
    }
    if (i == [queArray count]-1) {
        self.downBtn.userInteractionEnabled = NO;
        UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 440, 120, 40)];
        finishBtn.backgroundColor = RGBCOLOR(80, 240, 180);
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
        finishBtn.tag = 100;
        [self.view addSubview:finishBtn];
    }else{
        self.downBtn.userInteractionEnabled = YES;
    }
}

- (void)finishBtn:(id)sender
{
    if ([[personAnswerArray objectAtIndex:i] intValue] == -1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wrong" message:@"你还没有选择选项" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }else{
        NSArray *abc = @[@"A", @"B", @"C", @"D"];
        for (int count=0; count<=i; count++)
        {
            int a = [[personAnswerArray objectAtIndex:count] intValue];
            [personRealArray replaceObjectAtIndex:count withObject:[abc objectAtIndex:a]];
        }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定交卷？" message:@"" delegate:self cancelButtonTitle:@"取消，再检查一下" otherButtonTitles:@"确定", nil];
    alertView.delegate = (id<UIAlertViewDelegate>)self;
    [alertView show];
    }
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
            [self.navigationController pushViewController:[[JJFinishViewController alloc] init] animated:YES];
            NSLog(@"%@", personRealArray);
        }
    }
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
    [personAnswerArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d", newRow]];
    [self performSelector:@selector(downPage) withObject:self afterDelay:1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
