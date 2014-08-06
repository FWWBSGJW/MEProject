//
//  JJTestDetailViewController.m
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJTestDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CCommentCell.h"
#import "JJCommentManage.h"
#import "UIImageView+WebCache.h"
#import "SingleTestManage.h"
#import "User.h"
#import "SendComNoteView.h"
#import "SVPullToRefresh.h"
#import "DetailViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface JJTestDetailViewController ()
{
}
@property (strong, nonatomic) UIView *dimView; //发送评论时背影
@property (strong, nonatomic) SendComNoteView *sendComNoteView; //发送评论，笔记试图

@end


@implementation JJTestDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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


- (IBAction)writeComment:(id)sender
{
    [self userCheck];
    if ([User sharedUser].info.isLogin) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.dimView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.sendComNoteView];
        [self.sendComNoteView.textView becomeFirstResponder];
        self.sendComNoteView.titleLabel.text = @"发送评论";
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
//        NSLog(@"评论---%@",self.sendComNoteView.textView.text);
    [self userCheck];
    User *user = [User sharedUser];
    [self sendTestCommentWithTestID:self.myModel.tcId
                          andUserID:[user.info.userId intValue]
                         andContent:self.sendComNoteView.textView.text];
    [self sendComNoteViewBack];
    //self.sendComNoteView.textView.text = nil;
}

- (void)cancelSend
{
    [self sendComNoteViewBack];
}


- (void)sendTestCommentWithTestID:(NSInteger)testID andUserID:(NSInteger)userID andContent:(NSString *)content
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
    NSString *body = [NSString stringWithFormat:@"?CId=%d&userid=%d&ccContent=%@",testID,userID,content];
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response, NSData *data,
                         NSError *error) {
         self.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:self withCommentUrl:self.myModel.commentLink];
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

- (id)initWithModel:(JJTestModel *)paramModel
{
    self = [super init];
    if (self) {
        self.myModel = paramModel;
        self.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:self withCommentUrl:self.myModel.commentLink];
    }
    
    return self;
}

+ (instancetype)testDetailVCwithTestID:(NSInteger)testID;
{
    JJTestDetailViewController *vc = [[JJTestDetailViewController alloc] init];
    vc.myModel = [[[SingleTestManage alloc] init]
                  analyseTestJson:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/getSTestModel?tcId=%d", testID]];
    vc.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:vc withCommentUrl:vc.myModel.commentLink];
//    [vc loadModel];
    return vc;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadModel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarButton;

    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"shareUp"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBarButton;
    
    self.navigationItem.title = @"测试详情";

    
    [self.likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    User *user = [User sharedUser];
    if(user.info.isLogin == YES)
    {
        for (int i=0; i<user.info.testcollection.count; i++)
        {
            NSDictionary *dict = [user.info.testcollection objectAtIndex:i];
            int dictTCID = [[dict objectForKey:@"tcId"] intValue];
            int mymodelTCID = self.myModel.tcId;
            if (dictTCID == mymodelTCID)
            {
                [self.likeBtn setImage:[UIImage imageNamed:@"likeUp"] forState:UIControlStateNormal];
                [self.likeBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                break;
            }
        }
    }
    
    self.commentTableView = [[UITableView alloc]
                         initWithFrame:self.commentView.bounds style:UITableViewStylePlain];
    [self.commentView addSubview:self.commentTableView];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.tableFooterView = [[UIView alloc] init];
    [self addTableViewTrag];
    
    [self.introduceButton addTarget:self action:@selector(introduceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
//    self.commentButton.backgroundColor = RGBCOLOR(227, 227, 227);
}

- (void)addTableViewTrag
{
    __weak JJTestDetailViewController *weakself = self;
//    [weakself.commentTableView addPullToRefreshWithActionHandler:^{
//        int64_t delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^{
//            [weakself.testTableView.pullToRefreshView stopAnimating];
//            if (self.testArray.count==0)
//            {
//                self.testArray = [[NSMutableArray alloc] init];
//                NSArray *temArray = [[[JJTestModelManage alloc] init] analyseTestJson:originUrl];
//                [self.testArray addObjectsFromArray:temArray];
//                [self.testTableView reloadData];
//            }
//        });
//    }];
    
    [weakself.commentTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.commentTableView.infiniteScrollingView stopAnimating];
            if (self.nextPage)
            {
                NSMutableArray *temArray = [[[JJCommentManage alloc] init] analyseCommentJsonWithCommentUrl:self.nextPage];
                [self.commentArray addObjectsFromArray:temArray];
                if (temArray.count == 13) {
                    JJCommentModel *model = [self.commentArray lastObject];
                    self.nextPage = model.nextPage;
                    [self.commentArray removeLastObject];
                }
                else
                {
                    self.nextPage = @"";
                }
                [self.commentTableView reloadData];
            }
        });
    }];
    
}


- (void)loadModel
{
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.myModel.tcPhotoUrl]]];
    self.directionLa.text = [NSString stringWithFormat:@"方向：%d", self.myModel.tdirection];
    self.timeLa.text = [NSString stringWithFormat:@"时长：%d", self.myModel.tcTime];
    self.subjectNumLa.text = [NSString stringWithFormat:@"题数：%d", self.myModel.subjectnums];
    self.scoreLa.text = [NSString stringWithFormat:@"总分：%d", self.myModel.tcScore];
//    self.priceLa.text = [NSString stringWithFormat:@"价格：%d", self.myModel.tcPrice];
    self.testName.text = self.myModel.tcName;
    self.introduceView.text = self.myModel.tcIntro;
}

#pragma mark 收藏
- (void)like
{
    [self userCheck];
    if ([User sharedUser].info.isLogin) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.likeBtn cache:YES];
        if ([self.likeBtn.titleLabel.text  isEqual: @"收藏"])
        {
            [self.likeBtn setImage:[UIImage imageNamed:@"likeUp"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        }else{
            [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            [self.likeBtn setTitle:@"收藏" forState:UIControlStateNormal];
        }
        [UIView commitAnimations];

        NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
        urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=%d&CId=%d", [[User sharedUser].info.userId intValue], self.myModel.tcId]];
//        urlAsString = [urlAsString stringByAppendingString:[NSString stringWithFormat:@"?userId=1&CId=%d", self.myModel.tcId]];
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
    }
}



- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCommentCell * lableSwitchCell;
    UINib *n;
    static NSString *CellIdentifier = @"CCommentCell";
    lableSwitchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lableSwitchCell == nil)
    {
        NSArray *_nib=[[NSBundle mainBundle] loadNibNamed:@"CCommentCell"
                                                    owner:self  options:nil];
        lableSwitchCell  = [_nib objectAtIndex:0];
        //通过这段代码，来完成LableSwitchXibCell的ReuseIdentifier的设置
        //这里是比较容易忽视的，若没有此段，再次载入LableSwitchXibCell时，dequeueReusableCellWithIdentifier:的值依然为nil
        n= [UINib nibWithNibName:@"PlayCCommentCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:n forCellReuseIdentifier:@"PlayCCommentCell"];
    }
    JJCommentModel *commentModel = [self.commentArray objectAtIndex:indexPath.row];
    [lableSwitchCell.headImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, commentModel.userPortrait]]];
    lableSwitchCell.userNameLable.text = commentModel.userSign;
    lableSwitchCell.commentLabel.text = commentModel.ccContent;
    lableSwitchCell.dateLable.text = commentModel.ccDate;
    lableSwitchCell.imageButton.tag = indexPath.row;
    [lableSwitchCell.imageButton addTarget:self action:@selector(touchHeadImage:) forControlEvents:UIControlEventTouchUpInside];

    
    return lableSwitchCell;
}

#pragma mark touch headImageButton
- (void)touchHeadImage:(UIButton *)sender
{
    JJCommentModel *model = [self.commentArray objectAtIndex:sender.tag];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithUserId:
                                      [NSString stringWithFormat:@"%d", (int)model.userid]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)introduceButton:(id)sender
{
//    self.commentButton.backgroundColor = RGBCOLOR(227, 227, 227);
//    self.introduceButton.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.introduceView];
}

- (void)commentButton:(id)sender
{
//    self.commentButton.backgroundColor = [UIColor whiteColor];
//    self.introduceButton.backgroundColor = RGBCOLOR(227, 227, 227);
    [self.view bringSubviewToFront:self.commentView];
}

- (IBAction)buyOrEnter:(id)sender
{
    [self userCheck];
    if ([User sharedUser].info.isLogin)
    {
        JJMeasurementViewController *measureVC = [[JJMeasurementViewController alloc] initWithSubjectDetailUrl:self.myModel.sublink time:self.myModel.tcTime];
        measureVC.title = self.testName.text;
        measureVC.tcid = self.myModel.tcId;
        measureVC.highScoreUrl = self.myModel.highScoreUrl;
        [self.navigationController pushViewController:measureVC animated:YES];
    }
}

#pragma mark - 用户登录相关

- (void)userCheck
{
    User *user = [User sharedUser];
    if (!user.info.isLogin) {
        [user gotoUserLoginFrom:self];
    }
}

- (void)share:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我正在使用ME手机app学习java，c++等，你们也来学习吧"
                                       defaultContent:@"我正在使用ME手机app学习java，c++等，你们也来学习吧"
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
