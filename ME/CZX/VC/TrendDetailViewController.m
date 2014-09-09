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
#import "SendComNoteView.h"
#import "User.h"

#define originY 62
@interface TrendDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int mid;
}
@property (strong, nonatomic) UIView *dimView; //发送评论时背影
@property (strong, nonatomic) SendComNoteView *sendComNoteView; //发送评论，笔记试图

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
    mid = model.mid;
    [self.userHeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.197.10.159:8080/images/user/%@", model.userPortrait]]];
    if (model.hmtime<=60)
    {
        if (model.hmtime<1)
        {
            self.timeLabel.text = @"刚刚";
        }
        else
        {
            self.timeLabel.text = [NSString stringWithFormat:@"%.f分钟前", model.hmtime];
        }
    }
    else if (model.hmtime<=60*24 && model.hmtime>60)
    {
        int hour = model.hmtime/60;
        self.timeLabel.text = [NSString stringWithFormat:@"%.d小时前", hour];
    }
    else if(model.hmtime>60*24)
    {
        int day = model.hmtime/(60*24);
        self.timeLabel.text = [NSString stringWithFormat:@"%.d天前", day];
    }
//    self.timeLabel.text = [NSString stringWithFormat:@"%.f分钟前", model.hmtime];
    self.userName.text = model.userName;
    self.trendLabel.text = model.content;
    [self.trendLabel resizeToFit];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.trendLabel.frame.origin.y+self.trendLabel.frame.size.height+20, 320, 1)];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.lineView];
    
    self.topView = [[UIView alloc]
                    initWithFrame:CGRectMake(0, originY, 320, self.lineView.frame.origin.y+1)];
    [self.topView addSubview:self.userHeadImage];
    [self.topView addSubview:self.userName];
    [self.topView addSubview:self.timeLabel];
    [self.topView addSubview:self.trendLabel];
    [self.topView addSubview:self.lineView];
//    [self.view addSubview:self.topView];
    
    self.commentTableView = [[UITableView alloc]
                             initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.commentTableView.tableHeaderView = self.topView;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.commentTableView];

    
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
    
    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [commentBtn setImage:[UIImage imageNamed:@"cmt.png"] forState:UIControlStateNormal];
    [commentBtn setTitle:@"评论" forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [commentBtn addTarget:self action:@selector(writeTrend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc] init];
}

- (void)initializeView
{
    self.userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 42, 42)];
    self.userHeadImage.layer.cornerRadius = 20;
    self.userHeadImage.backgroundColor = System_BlueColor;
//    [self.view addSubview:self.userHeadImage];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(52, 5, 100, 20)];
    self.userName.text = @"用户名";
    self.userName.font = [UIFont systemFontOfSize:15.0];
    self.userName.textColor = System_BlueColor;
//    [self.view addSubview:self.userName];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 90, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    self.timeLabel.text = @"1分钟前";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor darkGrayColor];
//    [self.view addSubview:self.timeLabel];
    
    self.trendLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 30, 248, 10)];
    self.trendLabel.text = @"他你我他你我他你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我你我他你我他你我他你我他你我他你我";
    [self.trendLabel resizeToFit];
//    [self.view addSubview:self.trendLabel];
    
//    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.trendLabel.frame.origin.y+self.trendLabel.frame.size.height+20, 320, 1)];
//    self.lineView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.lineView];
//
}

- (UIView *)dimView
{
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.frame];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.4;
    }
    return _dimView;
}


#pragma mark 写动态
- (void)writeTrend
{
//    if ([User sharedUser].info.isLogin) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.sendComNoteView];
        [self.sendComNoteView.textView becomeFirstResponder];
        self.sendComNoteView.titleLabel.text = @"写评论";
        self.sendComNoteView.textView.backgroundColor = [UIColor whiteColor];
        self.sendComNoteView.titleLabel.backgroundColor = [UIColor orangeColor];
        [UIView animateWithDuration:0.4f animations:^{
            [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, 20.0, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
            self.sendComNoteView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
//    }
}

- (void)sendComNoteViewBack
{
    [self.sendComNoteView.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.4f animations:^{
        [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, -_sendComNoteView.frame.size.height, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
        self.sendComNoteView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.dimView removeFromSuperview];
        self.sendComNoteView.textView.text = nil;
    }];
    
}

- (SendComNoteView *)sendComNoteView
{
    if (!_sendComNoteView) {
        
        _sendComNoteView = [[SendComNoteView alloc] init];
        _sendComNoteView.frame = CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, -_sendComNoteView.frame.size.height, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height);
        _sendComNoteView.alpha = 0.0;
        [_sendComNoteView.sendButton addTarget:self action:@selector(sendComNote) forControlEvents:UIControlEventTouchUpInside];
        [_sendComNoteView.backButton addTarget:self action:@selector(cancelSend) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendComNoteView;
}


- (void)sendComNote
{
#pragma waring 此处待实现上传评论，笔记 ,刷新数据
    NSLog(@"动态---%@",self.sendComNoteView.textView.text);
    [self sendTrendWithUserID:[User sharedUser].info.userId andContent:self.sendComNoteView.textView.text];
    //    [self sendTrendWithUserID:2 andContent:self.sendComNoteView.textView.text];
    [self sendComNoteViewBack];
    //self.sendComNoteView.textView.text = nil;
}

- (void)cancelSend
{
    [self sendComNoteViewBack];
}


- (void)sendTrendWithUserID:(NSInteger)userID andContent:(NSString *)content
{
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/uploadMcom?";
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"userId=%d&mid=%d&content=%@",userID, mid, content];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response, NSData *data,
                         NSError *error) {
         //         [[[TrendManage alloc] init] getData:self];
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
     }];
    
    
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
