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
#import "UILabel+dynamicSizeMe.h"
#import "TrendDetailViewController.h"
#import "TrendManage.h"
#import "TrendModel.h"
#import "UIImageView+WebCache.h"
#import "UserCenterTableViewController.h"

#define testString @"你我他你我你我他你我他你我他你我你我他你我他你我他你我你我他你我他你我他你我你我他你我他"

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

- (UIView *)dimView
{
    if (!_dimView) {
        _dimView = [[UIView alloc] initWithFrame:self.view.frame];
        _dimView.backgroundColor = [UIColor blackColor];
        _dimView.alpha = 0.4;
    }
    return _dimView;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trendsArray = [[NSMutableArray alloc] init];
    _page=0;
    
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
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, 230, 20, 20)];
    [self.activityView startAnimating];
    self.activityView.color = [UIColor blackColor];
    [self.view addSubview:self.activityView];
    self.trendsArray = (NSMutableArray *)[[[TrendManage alloc] init] analyseJsonForVC:self];
    if (self.trendsArray.count==10) {
        _page=2;
    }
    if (self.trendsArray.count > 0)
    {
        [self.activityView stopAnimating];
    }
    else
    {
        [[[TrendManage alloc] init] getData:self];
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
        self.sendComNoteView.textView.backgroundColor = [UIColor whiteColor];
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
//    [self.activityView startAnimating];
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/uploadMove";
//    urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?CId=%d&userid=%d&ccContent=#%@#",testID,userID,content]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *body = [NSString stringWithFormat:@"userId=%d&content=%@",userID,content];
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
//        [self.activityView startAnimating];
        if (self.trendsArray.count>=10)
        {
            _page = 2;
        }
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.trendsTableView.pullToRefreshView stopAnimating];
            [[[TrendManage alloc] init] getData:self];
        });
    }];
    
    [weakself.trendsTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.trendsTableView.infiniteScrollingView stopAnimating];
            if (_page!=0)
            {
//                NSString *str = [NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listMove?userId=%d&score=%d",[User sharedUser].info.userId, _page];
                NSArray *temArray = [[[TrendManage alloc] init] getUrlTrends:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listMove?userId=%d&score=%d",[User sharedUser].info.userId, _page]];
                if (temArray.count<10)
                {
                    _page = 0;
                }
                else
                {
                    _page++;
                }
                [self.trendsArray addObjectsFromArray:temArray];
                [self.trendsTableView reloadData];
            }
        });
    }];
    
}

#pragma mark tableview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendModel *model = [self.trendsArray objectAtIndex:[indexPath row]];
    CGFloat temHeight = [self heightForLabelWithString:model.content];
    if (temHeight>65)
    {
        return 61+30+30;
    }
    else
    {
        return temHeight+30+30;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trendsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendTableViewCell *lableSwitchCell;
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
    
    TrendModel *model = [self.trendsArray objectAtIndex:[indexPath row]];
    
    lableSwitchCell.userName.text = model.userName;
    if (model.hmtime<=60)
    {
        if (model.hmtime<1)
        {
            lableSwitchCell.timeLabel.text = @"刚刚";
        }
        else
        {
            lableSwitchCell.timeLabel.text = [NSString stringWithFormat:@"%.f分钟前", model.hmtime];
        }
    }
    else if (model.hmtime<=60*24 && model.hmtime>60)
    {
        int hour = model.hmtime/60;
        lableSwitchCell.timeLabel.text = [NSString stringWithFormat:@"%.d小时前", hour];
    }
    else if(model.hmtime>60*24)
    {
        int day = model.hmtime/(60*24);
        lableSwitchCell.timeLabel.text = [NSString stringWithFormat:@"%.d天前", day];
    }
    lableSwitchCell.timeLabel.textAlignment = NSTextAlignmentRight;
    [lableSwitchCell.userHeadImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.197.10.159:8080/images/user/%@", model.userPortrait]]];
    lableSwitchCell.userHeadImage.layer.cornerRadius = 20;
    [lableSwitchCell.headBtn addTarget:self action:@selector(touchHead) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *trendLabel = [[UILabel alloc] init];
    CGFloat temHeight = [self heightForLabelWithString:model.content];
    CGRect temFrame = CGRectMake(52, 30, 248, 0);
    if (temHeight>60)
    {
        temFrame.size.height = 61;
        trendLabel.numberOfLines = 3;
    }
    else if(temHeight>40 && temHeight<50)
    {
        temFrame.size.height = temHeight;
        trendLabel.numberOfLines = 2;
    }
    else
    {
        temFrame.size.height = temHeight;
    }
    trendLabel.frame = temFrame;
//    trendLabel.lineBreakMode = NSLineBreakByWordWrapping;
    trendLabel.text = model.content;
    [lableSwitchCell addSubview:trendLabel];

    UIButton *likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, trendLabel.frame.size.height+trendLabel.frame.origin.y+8, 60, 20)];
    likeBtn.tag = indexPath.row;
    [likeBtn setTitle:@"赞" forState:UIControlStateNormal];
    [likeBtn setTitleColor:RGBCOLOR(20, 84, 254) forState:UIControlStateNormal];
    likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [likeBtn setImage:[UIImage imageNamed:@"Ilike"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"IlikeUU"] forState:UIControlStateHighlighted];
    [likeBtn addTarget:self action:@selector(Ilike:) forControlEvents:UIControlEventTouchUpInside];
    [lableSwitchCell addSubview:likeBtn];
    
    return lableSwitchCell;
}

- (void)Ilike:(UIButton *)paramBtn
{
    if (paramBtn.tag<1000)
    {
        [paramBtn setImage:[UIImage imageNamed:@"IlikeUU"] forState:UIControlStateNormal];
        [paramBtn setTitle:@"已赞" forState:UIControlStateNormal];
        paramBtn.tag += 1000;
    }
    else
    {
        [paramBtn setImage:[UIImage imageNamed:@"Ilike"] forState:UIControlStateNormal];
        [paramBtn setTitle:@"赞" forState:UIControlStateNormal];
        paramBtn.tag -= 1000;
    }
}

- (void)touchHead
{
//    TrendModel *model = [self.trendsArray objectAtIndex:tag];
//    UserCenterTableViewController *detailVC = [[UserCenterTableViewController alloc] initWithUserId:(int)model.userId];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)heightForLabelWithString:(NSString *)text
{
    UILabel *temLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 30, 248, 10)];
    temLabel.text = text;
    [temLabel resizeToFit];
    return temLabel.frame.size.height;
}

#pragma mark tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendDetailViewController *trendDetaiVC = [[TrendDetailViewController alloc] initWithTrendModel:[self.trendsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:trendDetaiVC animated:YES];
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
