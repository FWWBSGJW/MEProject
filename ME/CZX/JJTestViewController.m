//
//  JJTestViewController.m
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//  RGBCOLOR(180, 230, 80)

#import "JJTestViewController.h"
#import "JJTestDetailViewController.h"
#import "JJTestTableViewCell.h"
#import "UILabel+dynamicSizeMe.h"
#import "SVPullToRefresh.h"
#define ScrollViewHeight 120
#define pages 3

@interface JJTestViewController ()
{
    NSArray *nameArray;
}
@end

@implementation JJTestViewController

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
//    self.navigationController.navigationBarHidden = YES;
//    [JJTabBarViewController share].tabBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark getData
- (void)getData
{
    NSString * url = [@"http://app-cdn.2q10.com/api/currency" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse * resp;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&resp error:&error];
        
        if (error)
        {
            printf("%s \n",[[error localizedDescription] UTF8String]);
            return ;
        }
        
        if ([data length] > 0)
        {
//            serverRespObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            //            NSLog(@"server return %@",serverRespObj);
//            keyArray = @[];
            // 切换到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self.table reloadData];
            });
        }
    });
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.newsView = [[XLCycleScrollView alloc]
                     initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    self.newsView.delegate = self;
    self.newsView.datasource = self;
    
    self.newsBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    [self.newsBG addSubview:self.newsView];
    
    self.testTableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, 320, 440)
                          style:UITableViewStylePlain];
    self.testTableView.delegate = self;
    self.testTableView.dataSource = self;
    [self adjustTableViewInsert];
    self.testTableView.tableHeaderView = self.newsBG;
    [self.view addSubview:self.testTableView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testName" ofType:@"plist"];
    nameArray = [NSArray arrayWithContentsOfFile:path];
    
    //防止下拉位子异常
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self adjustTableViewInsert];
    }
    [self addTableViewTrag];
}

- (void)adjustTableViewInsert
{
    UIEdgeInsets insets = self.testTableView.contentInset;
    insets.top = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    self.testTableView.contentInset = insets;
    self.testTableView.scrollIndicatorInsets = insets;
}

- (NSInteger)numberOfPages
{
    return pages;
}

- (void)addTableViewTrag
{
    __weak JJTestViewController *weakself = self;
    [weakself.testTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.testTableView.pullToRefreshView stopAnimating];
            [self.testTableView reloadData];
        });
    }];
    
    [weakself.testTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            
            [self.testTableView reloadData];
            [weakself.testTableView.infiniteScrollingView stopAnimating];
        });
    }];
    
}



- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *newsImage = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    newsImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"00%ld", (long)index]];
    return newsImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    加载xib的tableviewcell
    JJTestTableViewCell * lableSwitchCell;
    UINib *n;
    static NSString *CellIdentifier = @"JJTestTableViewCell";
    lableSwitchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lableSwitchCell == nil)
    {
        NSArray *_nib=[[NSBundle mainBundle] loadNibNamed:@"JJTestTableViewCell"
                                                    owner:self  options:nil];
        lableSwitchCell  = [_nib objectAtIndex:0];
        //通过这段代码，来完成LableSwitchXibCell的ReuseIdentifier的设置
        //这里是比较容易忽视的，若没有此段，再次载入LableSwitchXibCell时，dequeueReusableCellWithIdentifier:的值依然为nil
        n= [UINib nibWithNibName:@"PlayTableviewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:n forCellReuseIdentifier:@"PlayTableviewCell"];
    }
    lableSwitchCell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"00%ld", (long)indexPath.row]];
    lableSwitchCell.nameLabel.text = [nameArray objectAtIndex:indexPath.row];
    [lableSwitchCell.nameLabel resizeToFit];
    lableSwitchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return lableSwitchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[JJTestDetailViewController alloc] init] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
