//
//  CVieoPlayerontroller.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-10.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "CVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "DanmakuView.h"
#import "DanmakuModel.h"



@interface CVideoPlayerController ()
{
   // NSTimer *_playTimer;
    UILabel *_label;    
    NSInteger _lastArrayNum ; //弹幕内容数组控制
}


//自定义播放器控件
//下边栏控制条
@property (nonatomic, strong) UIView *controlBar;
//右边栏
@property (strong, nonatomic) UIView *chooseView;
//上边栏
@property (strong, nonatomic) UIView *topBar;
//定时器
@property (strong, nonatomic) NSTimer *timer;
//进度条开始时间label
@property (strong, nonatomic) UILabel *startTimeLabel;
//进度条
@property (strong, nonatomic) UISlider *sliderBar;
//结束播放时间label
@property (strong, nonatomic) UILabel *endTimeLabel;

//记录进度条手势快进秒数
@property (assign, nonatomic) double second;
//快进时候显示时间提示
@property (nonatomic, strong) UIView *showTimeView;
//timeShowLabel
@property (strong, nonatomic) UILabel *timeShowLabel;
//手势状态
@property (nonatomic, assign) int gestureStatus;
//记录起始点
@property (assign, nonatomic) float lastX;
@property (assign, nonatomic) float lastY;

@property (strong, nonatomic) NSString *movieTitle;
@property (strong, nonatomic) UIButton *bgButton;
//计时器
@property (strong, nonatomic) NSTimer *hiddenBgTimer;

//弹幕视图
@property (strong, nonatomic) UIView *danmakuView;
//弹幕管理模型
@property (strong, nonatomic) DanmakuModel *danmakuModel;
//发表评论按钮-移动弹幕
@property (strong, nonatomic) UIButton *sendCommentButton;
//发表笔记按钮-静止弹幕
@property (strong, nonatomic) UIButton *sendNoteButton;
//弹幕开关
@property (strong, nonatomic) UISwitch *dmSwitch;
//弹幕计时器
@property (strong, nonatomic) NSTimer *danmakuTimer;

@property (strong, nonatomic) NSArray *danmaku; //弹幕数组
@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSURL *url;

//@property (strong, nonatomic) UIView *myControlView; //自定义按钮存放试图

@end

@implementation CVideoPlayerController

#pragma getter and setter

- (DanmakuModel *)danmakuModel
{
    if (_danmakuModel == nil) {
        _danmakuModel = [[DanmakuModel alloc] init];
    }
    return _danmakuModel;
}

- (NSArray *)danmaku
{
    if (!_danmaku) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DamakuData.plist" ofType:nil];
        _danmaku = [NSArray arrayWithContentsOfFile:path];
    }
    return _danmaku;
}



- (void)playVideoWithVideoID : (NSInteger)videoID andVideoTitle:(NSString *)videoTitle
{
#warning 通过id获取视频url,弹幕 待实现
    self.url = [[NSBundle mainBundle] URLForResource:@"promo_full" withExtension:@"mp4"];
    self.moviePlayer.contentURL = self.url;
    self.title = videoTitle;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.moviePlayer prepareToPlay];
    
    _lastArrayNum = 0;
    //self.title = @"愤怒地小鸟";
    self.gestureStatus = -1;
    
    //监听视频文件预加载完成时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(movieStart) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    //监听播放状态
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stateChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //监听结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPlay) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    //NSLog(@"%f",self.moviePlayer.duration);
    //self.moviePlayer.initialPlaybackTime = 10.0; 通过这个可控制开始时间
    //设置计时器
    
    
    
    
    
    [self setUI];
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 弹幕实现

- (void)selectDanmuku
{
    //NSLog(@"过了1s");
    
    CGFloat danmukuY = 25.0;
    //NSLog(@"%@",self.danmaku);
    for (NSInteger i = _lastArrayNum; i < self.danmaku.count; i++) {
        if ((int)(self.moviePlayer.currentPlaybackTime) == [self.danmaku[i][@"Dtime"] integerValue]) {
            DanmakuView *danmakuView = [self.danmakuModel dequeueReusableDanmakuWithDanmakuType:moveDanmaku];
            if (danmakuView == nil) {
                //NSLog(@"nil");
                danmakuView = [[DanmakuView alloc] init];
            }
            
            [danmakuView setSizeWithComponent:self.danmaku[i][@"Dcomponent"]];
            CGSize dmSize = danmakuView.frame.size;
            [danmakuView setFrame:CGRectMake(SCREEN_HEIGHT, danmukuY, dmSize.width, dmSize.height)];
            [self.danmakuView addSubview:danmakuView];

            //设置弹幕动画
            [UIView animateWithDuration:4.0f animations:^{
                //CGPoint center = danmakuView.center;
                //center.x -= (SCREEN_HEIGHT + size.width);
                //danmakuView.center =center;
                [danmakuView setFrame:CGRectMake(0.0-danmakuView.frame.size.width, danmakuView.frame.origin.y, danmakuView.frame.size.width, danmakuView.frame.size.height)];
                //danmakuView setCenter:CGPointMake(danmakuView.center.x-SCREEN_HEIGHT-size, <#CGFloat y#>)
            } completion:^(BOOL finished) {
                if (danmakuView.frame.origin.x < (-danmakuView.frame.size.width)) {
                    [self.danmakuModel addNoUseDanmaku:danmakuView WithDanmakuType:moveDanmaku];
                }
                
            }];
            danmukuY += 40;
        }
        if ((int)(self.moviePlayer.currentPlaybackTime) < [self.danmaku[i][@"Dtime"] integerValue])
            break;
    }
}

#pragma mark - 控制旋转
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 设置UI
- (void)setUI
{
    //影藏播放器原始控件
    [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
    //设置播放器背景颜色
    [self.moviePlayer.backgroundView setBackgroundColor:[UIColor blackColor]];
    
    
    //添加弹幕视图
    UIView *danmakuView = [[UIView alloc] initWithFrame:self.view.frame];
    self.danmakuView = danmakuView;
    [self.moviePlayer.view addSubview:self.danmakuView];
    
    
    
    /*
    //添加背景按钮
    */
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bgButton = bgButton;
    [bgButton setFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    [bgButton setAlpha:0.2f];
    [bgButton addTarget:self action:@selector(bgButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.moviePlayer.view addSubview:bgButton];
    //self.bgButton.selected = YES;
    //
    //重写控制条
    //
    UIView *controlBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-55, SCREEN_HEIGHT, 55.0)];
    self.controlBar = controlBar;
    [self.controlBar setBackgroundColor:[UIColor blackColor]];
    [self.controlBar setAlpha:0.7f];
    [self.moviePlayer.view addSubview:self.controlBar];
    
    //发送弹幕按钮
    
    UIButton *sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[sendCommentButton setTitle:@"发送弹幕" forState:UIControlStateNormal];
    sendCommentButton.frame = CGRectMake(50, 10, 30, 30);
    [sendCommentButton setBackgroundImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [sendCommentButton addTarget:self action:@selector(sendDanmaku:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar addSubview:sendCommentButton];
    
    UIButton *sendNoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendNoteButton.frame = CGRectMake(100, 10, 30, 30);
    [sendNoteButton setBackgroundImage:[UIImage imageNamed:@"笔记"] forState:UIControlStateNormal];
    [sendNoteButton addTarget:self action:@selector(sendDanmaku:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar addSubview:sendNoteButton];
    
    //弹幕开关
    UILabel *dmLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 167, 10, 40, 30)];
    dmLabel.text = @"弹幕";
    dmLabel.textColor = [UIColor whiteColor];
    dmLabel.font = [UIFont systemFontOfSize:12.0];
    //dmLabel.backgroundColor = [UIColor whiteColor];
    [self.controlBar addSubview:dmLabel];
    
    UISwitch *dmSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT - 137, 10, 20, 15)];
    self.dmSwitch = dmSwitch;
    [dmSwitch addTarget:self action:@selector(showOrHidDM:) forControlEvents:UIControlEventValueChanged];
    [self.controlBar addSubview:dmSwitch];
    
    //开始/暂停按钮
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:CGRectMake((SCREEN_HEIGHT-40)/2.0, 10, 40, 30)];
    [playButton setImage:[UIImage imageNamed:@"details_stop.png"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"details_stop_select.png"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar addSubview:playButton];
    
    //快进
    UIButton *playUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playUpButton setFrame:CGRectMake((SCREEN_HEIGHT-40)/2.0 + 60, 10, 40, 30)];
    [playUpButton setImage:[UIImage imageNamed:@"details_down.png"] forState:UIControlStateNormal];
    [playUpButton setImage:[UIImage imageNamed:@"details_down_select.png"] forState:UIControlStateSelected];
    [playUpButton addTarget:self action:@selector(playUpButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar addSubview:playUpButton];
    
    //后退
    UIButton *playDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playDownButton setFrame:CGRectMake((SCREEN_HEIGHT-40)/2.0 - 60, 10, 40, 30)];
    [playDownButton setImage:[UIImage imageNamed:@"details_up.png"] forState:UIControlStateNormal];
    [playDownButton setImage:[UIImage imageNamed:@"details_up_select.png"] forState:UIControlStateSelected];
    [playDownButton addTarget:self action:@selector(playDownButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.controlBar addSubview:playDownButton];
    
    //进度条
    //开始时间
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT-90, 5, 45, 15)];
    self.startTimeLabel = startTimeLabel;
    [self.startTimeLabel setText:[NSString stringWithFormat:@"0"]];
    [self.startTimeLabel setTextColor:[UIColor whiteColor]];
    [self.startTimeLabel setBackgroundColor:[UIColor blackColor]];
    [self.startTimeLabel setAlpha:0.6f];
    [self.startTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.startTimeLabel setFont:[UIFont systemFontOfSize:10]];
    [self.controlBar addSubview:self.startTimeLabel];
    
    //进度条
    UISlider *sliderBar = [[UISlider alloc] initWithFrame:CGRectMake(0, -12, SCREEN_HEIGHT, 25)];
    _sliderBar = sliderBar;
    [self.sliderBar setMinimumValue:0];
    [self.sliderBar setMaximumValue:self.moviePlayer.duration];
    //NSLog(@"%f",self.moviePlayer.duration);
    
    [self.sliderBar setMinimumTrackImage:[UIImage imageNamed:@"details_progress_select"] forState:UIControlStateNormal];
    [self.sliderBar setMaximumTrackImage:[UIImage imageNamed:@"details_progress"] forState:UIControlStateNormal];
    [self.sliderBar setThumbImage:[UIImage imageNamed:@"details_Progress of the point"] forState:UIControlStateNormal];
    [self.sliderBar setThumbImage:[UIImage imageNamed:@"details_Progress of the point"] forState:UIControlStateHighlighted];
    
    //self.sliderBar.value = 50;
    [self.sliderBar addTarget:self action:@selector(sliderBarTouchUpClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sliderBar addTarget:self action:@selector(sliderBarTouchDown:) forControlEvents:UIControlEventTouchDown];
    //[self.sliderBar addTarget:self action:@selector(sliderBarTouchDown:) forControlEvents:UIControlEventValueChanged];
    [self.controlBar addSubview:self.sliderBar];
    
    //时间分隔
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-48, 5, 3, 15)];
    [line setText:@"/"];
    [line setTextColor:[UIColor whiteColor]];
    [line setBackgroundColor:[UIColor blackColor]];
    [line setAlpha:0.6f];
    [line setFont:[UIFont systemFontOfSize:10]];
    [self.controlBar addSubview:line];
    
    //结束时间(总时间)
    UILabel *endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_HEIGHT-45, 5, 45, 15)];;
    self.endTimeLabel = endTimeLabel;
    [self.endTimeLabel setText:@"0"];
    [self.endTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.endTimeLabel setTextColor:[UIColor whiteColor]];
    [self.endTimeLabel setFont:[UIFont systemFontOfSize:10]];
    [self.endTimeLabel setBackgroundColor:[UIColor blackColor]];
    [self.endTimeLabel setAlpha:0.6f];
    [self.controlBar addSubview:self.endTimeLabel];
    
    
    
    /*
    //top bar
    */
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
    self.topBar = topBar;
    [self.topBar setBackgroundColor:[UIColor blackColor]];
    [self.topBar setAlpha:0.5f];
    [self.moviePlayer.view addSubview:self.topBar];
    
    //视频标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    //self.title是视频title
    [titleLabel setText:self.title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.topBar addSubview:titleLabel];
    
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"details_button_back.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"details_button_back_select.png"] forState:UIControlStateSelected];
    [backButton setFrame:CGRectMake( 3, 2, 30, 30)];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    //backButton.backgroundColor = [UIColor whiteColor];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(finishedPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:backButton];
    
#pragma mark 手势
    //滑动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAction:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [self.moviePlayer.view addGestureRecognizer:panRecognizer];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //CGPoint translatedPoint = [gestureRecognizer locationInView:self.moviePlayer.view];
    self.lastX = 0;
    self.lastY = 0;
    self.gestureStatus = -1;
    return YES;
}

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

//移动手势
- (void)moveAction:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.moviePlayer.view];
    if (self.gestureStatus == -1) { //刚触发过
        self.gestureStatus = 1;
        self.second = self.moviePlayer.currentPlaybackTime;
    } else if (self.gestureStatus == 1){//进度
        [self.moviePlayer pause];
        if (self.showTimeView == nil) {
            UIView *showTimeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_HEIGHT/2.0-100, 100, 200, 100)];
            self.showTimeView = showTimeView;
        }
        [self.showTimeView setAlpha:0.7f];
        [self.showTimeView setBackgroundColor:[UIColor blackColor]];
        [self.showTimeView.layer setCornerRadius:8];
        [self.moviePlayer.view addSubview:self.showTimeView];
        [self.showTimeView setHidden:NO];
        
        if (self.lastX<translatedPoint.x && self.second < self.moviePlayer.duration) {
            self.second =self.second + self.moviePlayer.duration*0.005;
        }
        if (self.lastX>translatedPoint.x && self.second >0) {
            self.second = self.second - self.moviePlayer.duration*0.005;
        }
        self.lastX = translatedPoint.x;
        
        if (self.timeShowLabel == nil) {
            UILabel *timeShowLabel = [[UILabel alloc]initWithFrame:self.showTimeView.bounds];
            self.timeShowLabel = timeShowLabel;
            [self.showTimeView addSubview:self.timeShowLabel];
            [self.timeShowLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [self.timeShowLabel setTextAlignment:NSTextAlignmentCenter];
            [self.timeShowLabel setBackgroundColor:[UIColor clearColor]];
            [self.timeShowLabel setTextColor:[UIColor whiteColor]];
        }
        [self.timeShowLabel setText:[NSString stringWithFormat:@"%@ / %@",[self secondTimeChange:[NSString stringWithFormat:@"%f",self.second]] ,self.endTimeLabel.text]];
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"手指离开");
        if (self.gestureStatus == 1) {
            self.sliderBar.value = self.second;
            self.moviePlayer.currentPlaybackTime = self.sliderBar.value;
            [self.moviePlayer play];
        }
        [self.showTimeView setHidden:YES];
    }

}

- (void)hiddenControlView
{
    [UIView animateWithDuration:0.6f animations:^{
        [UIView animateWithDuration:0.3f animations:^{
            [self.controlBar setFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_HEIGHT,55.0)];
        //[self.chooseView setFrame:CGRectMake(SCREEN_HEIGHT+40, 50, 40, 150)];
            [self.topBar setFrame:CGRectMake(0, -30, SCREEN_HEIGHT, 30.0)];
        }];
        [self.controlBar setAlpha:0.0f];
        //[self.chooseView setAlpha:0.0f];
        [self.topBar setAlpha:0.0f];
    }];
    [self.bgButton setSelected:YES];
    
    [self.hiddenBgTimer invalidate];
    if (self.hiddenBgTimer) {
        self.hiddenBgTimer = nil;
    }
}


#pragma mark - Actions
//

//显示和隐藏控制器
- (void)bgButtonTouched:(UIButton *)sender
{
   
    if (![sender isSelected]) {
        [self hiddenControlView];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [UIView animateWithDuration:0.3f animations:^{
                [self.controlBar setFrame:CGRectMake(0, SCREEN_WIDTH-55, SCREEN_HEIGHT, 55.0)];
                [self.topBar setFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
            }];
            [self.controlBar setAlpha:0.6f];
            //[self.chooseView setAlpha:0.6f];
            [self.topBar setAlpha:0.6f];
        }];
        [sender setSelected:NO];
        [self.hiddenBgTimer invalidate];
        if (self.hiddenBgTimer) {
            self.hiddenBgTimer = nil;
        }
        self.hiddenBgTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hiddenControlView) userInfo:nil repeats:NO];
    }
}

//播放/暂停按钮
- (void)playButtonClicked:(UIButton *)sender
{
    if ([sender isSelected]) {
        [self.moviePlayer play];
        [self.timer setFireDate:[NSDate date]];//重写开始定时器
        [sender setSelected:NO];
        [sender setImage:[UIImage imageNamed:@"details_stop_select.png"] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"details_stop.png"] forState:UIControlStateNormal];
    }else {
        [self.moviePlayer pause];
        [sender setSelected:YES];
        [sender setImage:[UIImage imageNamed:@"details_start.png"] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"details_start_select.png"] forState:UIControlStateNormal];
        [self.timer setFireDate:[NSDate distantFuture]]; //暂停定时器
    }
}

//快进按钮事件
- (void)playUpButtonClicked:(UIButton *)sender
{
    
    self.moviePlayer.currentPlaybackTime+=5;
    self.sliderBar.value = self.moviePlayer.currentPlaybackTime;
}

//快退按钮事件
- (void)playDownButtonClicked:(UIButton *)sender
{
    self.moviePlayer.currentPlaybackTime -=5;
    self.sliderBar.value = self.moviePlayer.currentPlaybackTime;
}

//定时器事件
- (void)timerClicked
{
    
    //设置开始时间
    //NSLog(@"%f",self.moviePlayer.currentPlaybackTime);
    NSLog(@"%f",self.sliderBar.maximumValue);
    [self.startTimeLabel setText:[self secondTimeChange:[NSString stringWithFormat:@"%f",self.moviePlayer.currentPlaybackTime]]];
    [self.sliderBar setMaximumValue:self.moviePlayer.duration];
    [self.sliderBar setValue:self.moviePlayer.currentPlaybackTime];
    //self.sliderBar.value = self.moviePlayer.currentPlaybackTime;
    NSLog(@"%f",self.sliderBar.value);
    [self.endTimeLabel setText:[self secondTimeChange:[NSString stringWithFormat:@"%f",self.moviePlayer.duration]]];
    [self selectDanmuku];
}

//slider value change
- (void)sliderBarTouchUpClicked:(UISlider *)sender
{
    
    self.moviePlayer.currentPlaybackTime= sender.value;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerClicked) userInfo:nil repeats:YES];
    }
    NSLog(@"%f",sender.value);
}

//slider touch down method
- (void)sliderBarTouchDown:(UISlider *)sender
{
    [self.timer invalidate];
    if (self.timer) {
        self.timer = nil;
    }
}

#pragma mark - 播放器事件监听

#pragma mark 播放状态改变
/*
 MPMoviePlaybackStateStopped,           停止
 MPMoviePlaybackStatePlaying,           播放
 MPMoviePlaybackStatePaused,            暂停
 MPMoviePlaybackStateInterrupted,       中断
 MPMoviePlaybackStateSeekingForward,    快进
 MPMoviePlaybackStateSeekingBackward    快退
 */
- (void)stateChange
{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePaused:
            //NSLog(@"duration%f",self.moviePlayer.duration);
            //NSLog(@"inittime,%f \n endplay%f",self.moviePlayer.initialPlaybackTime,self.moviePlayer.endPlaybackTime);
            //NSLog(@"%f",self.moviePlayer.currentPlaybackTime); //可获取当前时间
            
            break;
            
        default:
            break;
    }
}

#pragma mark 视频开始播放
- (void)movieStart
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerClicked) userInfo:nil repeats:YES];
    }
    if (!self.hiddenBgTimer) {
        self.hiddenBgTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hiddenControlView) userInfo:nil repeats:NO];
    }

//    if (!self.danmakuTimer) {
//        self.danmakuTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(selectDanmuku) userInfo:nil repeats:YES];
//    }
}


#pragma mark 播放结束
- (void)finishedPlay
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //[self.moviePlayer stop];
    
    //NSLog(@"播放完成,%f",self.moviePlayer.initialPlaybackTime);
    //[self dismissMoviePlayerViewControllerAnimated];
    //NSLog(@"%f",self.moviePlayer.duration);
    [self.danmakuView setHidden:YES];
    if ([self.danmakuTimer isValid]) {
        [self.danmakuTimer invalidate];
        if (_danmakuTimer) {
            _danmakuTimer = nil;
        }
    }
    if ([self.timer isValid]) {
        [self.timer invalidate];
        if (self.timer) {
            self.timer = nil;
        }
    }
    
    [self dismissMoviePlayerViewControllerAnimated];
    if (self.moviePlayer.currentPlaybackTime < self.moviePlayer.duration) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


//进度条秒数格式转换
- (NSString *)secondTimeChange:(NSString *)second
{
    int s = (int)[second doubleValue];
    int m = 0 ;
    int h = 0;
    if (s>=3600) {
        h = s/3600;
    }
    if ((s-h*3600)>=60) {
        m = (s-h*3600)/60;
    }
    s = s%60;
    
    NSString *string = [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
    return string;
}

@end
