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

@interface JJTestDetailViewController ()
{
}
@end

@implementation JJTestDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (id)initWithModel:(JJTestModel *)paramModel
{
    self = [super init];
    if (self) {
        self.myModel = paramModel;
        self.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:self withCommentUrl:@"http://121.197.10.159:8080/MobileEducation/direction/listCtest.action?page=1&CId=1"];
    }
    
    return self;
}

+ (instancetype)testDetailVCwithTestID:(NSInteger)testID;
{
    JJTestDetailViewController *vc = [[JJTestDetailViewController alloc] init];
    vc.myModel = [[[SingleTestManage alloc] init]
                  analyseTestJson:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/getSTestModel?tcId=%d", testID]];
    vc.commentArray = [[[JJCommentManage alloc] init] analyseCommentJsonForVC:vc withCommentUrl:@"http://121.197.10.159:8080/MobileEducation/direction/listCtest.action?page=1&CId=1"];
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
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    
    [self.likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentTableView = [[UITableView alloc]
                         initWithFrame:self.commentView.bounds style:UITableViewStylePlain];
    [self.commentView addSubview:self.commentTableView];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.tableFooterView = [[UIView alloc] init];
    
    [self.introduceButton addTarget:self action:@selector(introduceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
//    self.commentButton.backgroundColor = RGBCOLOR(227, 227, 227);
}

- (void)loadModel
{
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, self.myModel.tcPhotoUrl]]];
    self.directionLa.text = [NSString stringWithFormat:@"方向：%d", self.myModel.tdirection];
    self.timeLa.text = [NSString stringWithFormat:@"时长：%d", self.myModel.tcTime];
    self.subjectNumLa.text = [NSString stringWithFormat:@"题数：%d", self.myModel.subjectnums];
    self.scoreLa.text = [NSString stringWithFormat:@"总分：%d", self.myModel.tcScore];
    self.priceLa.text = [NSString stringWithFormat:@"价格：%d", self.myModel.tcPrice];
    self.testName.text = self.myModel.tcName;
    self.introduceView.text = self.myModel.tcIntro;
}

- (void)like
{
//    NSLog(@"%@", [User sharedUser].info.name);
    NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/collecteTest";
    urlAsString = [urlAsString stringByAppendingString:@"?userId=1"];
    urlAsString = [urlAsString stringByAppendingString:@"&CId=1"];
                   //[NSString stringWithFormat:@"&CId=%d", self.myModel.tcId]];
    NSURL *url = [NSURL URLWithString:urlAsString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *body = @"bodyParam1=BodyValue1&bodyParam2=BodyValue2";
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]]; NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response, NSData *data,
                         NSError *error) {
         if ([data length] >0 &&
             error == nil){
             NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; NSLog(@"HTML = %@", html);
         }
         else if ([data length] == 0 &&
                  error == nil){
             NSLog(@"Nothing was downloaded.");
         }
         else if (error != nil){
             NSLog(@"Error happened = %@", error);
         }
     }];
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
    
    return lableSwitchCell;
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
    JJMeasurementViewController *measureVC = [[JJMeasurementViewController alloc] initWithSubjectDetailUrl:self.myModel.sublink time:self.myModel.tcTime];
    measureVC.title = self.testName.text;
    measureVC.tcid = self.myModel.tcId;
    measureVC.highScoreUrl = self.myModel.highScoreUrl;
    [self.navigationController pushViewController:measureVC animated:YES];
}

- (void)share:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
