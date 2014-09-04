//
//  TrendsViewController.m
//  ME
//
//  Created by Johnny's on 14-9-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "TrendsViewController.h"
#import "TrendTableViewCell.h"
#import "SVPullToRefresh.h"
#import "User.h"
#import "SendComNoteView.h"

@interface TrendsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (strong, nonatomic) UIView *dimView; //发送评论时背影
@property (strong, nonatomic) SendComNoteView *sendComNoteView; //发送评论，笔记试图

@end

@implementation TrendsViewController

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
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"动态";
    self.trendsTableView = [[UITableView alloc]
                            initWithFrame:self.view.bounds style:UITableViewStylePlain];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn addTarget:self action:@selector(writeTrend)
              forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"write"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"writeUp"] forState:UIControlStateHighlighted];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.trendsTableView.delegate = self;
    self.trendsTableView.dataSource = self;
    self.trendsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.trendsTableView];
    [self adjustTableViewInsert];
    [self addTableViewTrag];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self adjustTableViewInsert];
    }
}

#pragma mark 写动态
- (void)writeTrend
{
    if ([User sharedUser].info.isLogin) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.sendComNoteView];
        [self.sendComNoteView.textView becomeFirstResponder];
        self.sendComNoteView.titleLabel.text = @"发动态";
        self.sendComNoteView.textView.backgroundColor = [UIColor lightGrayColor];
        self.sendComNoteView.titleLabel.backgroundColor = [UIColor orangeColor];
        [UIView animateWithDuration:0.4f animations:^{
            [self.sendComNoteView setFrame:CGRectMake((SCREEN_WIDTH-_sendComNoteView.frame.size.width)/2.0, 20.0, _sendComNoteView.frame.size.width, _sendComNoteView.frame.size.height)];
            self.sendComNoteView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
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
    //评论
        NSLog(@"动态---%@",self.sendComNoteView.textView.text);
//    [self userCheck];
    User *user = [User sharedUser];
//    [self sendTestCommentWithTestID:self.myModel.tcId
//                          andUserID:user.info.userId
//                         andContent:self.sendComNoteView.textView.text];
    [self sendComNoteViewBack];
    //self.sendComNoteView.textView.text = nil;
}

- (void)cancelSend
{
    [self sendComNoteViewBack];
}


- (void)sendTrendWithUserID:(NSInteger)userID andContent:(NSString *)content
{
    //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@MobileEducation/uploadCTest",kBaseURL]];
    //
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    [request setHTTPMethod:@"POST"];
    //
    //    NSString *bodyStr = [NSString stringWithFormat:@"CId=%d&userid=%d&ccContent=%@",testID,userID,content];
    //
    ////    NSLog(@"%@",bodyStr);
    //
    //    NSData *body = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    [request setHTTPBody:body];
    //    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    //    [connection start];
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/uploadCTest";
    //    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?CId=%d&userid=%d&ccContent=#%@#",testID,userID,content]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
//    NSString *body = [NSString stringWithFormat:@"?CId=%d&userid=%d&ccContent=%@",testID,userID,content];
//    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response, NSData *data,
                         NSError *error) {
//         self.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:self withCommentUrl:self.myModel.commentLink];
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

#pragma mark tableview上拉下拉
- (void)adjustTableViewInsert
{
    UIEdgeInsets insets = self.trendsTableView.contentInset;
    insets.top = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    self.trendsTableView.contentInset = insets;
    self.trendsTableView.scrollIndicatorInsets = insets;
}

- (void)addTableViewTrag
{
    __weak TrendsViewController *weakself = self;
    [weakself.trendsTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.trendsTableView.pullToRefreshView stopAnimating];

        });
    }];
    
    [weakself.trendsTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.trendsTableView.infiniteScrollingView stopAnimating];

        });
    }];
    
}

#pragma mark tableview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendTableViewCell * lableSwitchCell;
    UINib *n;
    static NSString *CellIdentifier = @"TrendTableViewCell";
    lableSwitchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lableSwitchCell == nil)
    {
        NSArray *_nib=[[NSBundle mainBundle] loadNibNamed:@"TrendTableViewCell"
                                                    owner:self  options:nil];
        lableSwitchCell  = [_nib objectAtIndex:0];
        //通过这段代码，来完成LableSwitchXibCell的ReuseIdentifier的设置
        //这里是比较容易忽视的，若没有此段，再次载入LableSwitchXibCell时，dequeueReusableCellWithIdentifier:的值依然为nil
        n= [UINib nibWithNibName:@"PlayTrendTableViewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:n forCellReuseIdentifier:@"PlayTrendTableViewCell"];
    }
    
    lableSwitchCell.userHeadImage.layer.cornerRadius = 20;
    
    return lableSwitchCell;
}

#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
