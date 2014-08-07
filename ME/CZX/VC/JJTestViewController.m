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
#import "JJDirectionManage.h"
#import "JJDirectionModel.h"
#import "UIImageView+WebCache.h"
#import "JJTestDivideViewController.h"
#import "ShakeViewController.h"
#define ScrollViewHeight 126
#define pages 3

@interface JJTestViewController ()
{
    NSMutableArray *linkArray;
    NSTimer *myTimer;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
    self.navigationItem.title = @"技能测试";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.newsView = [[XLCycleScrollView alloc]
                     initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    self.newsView.delegate = self;
    self.newsView.datasource = self;
    
    self.newsBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    [self.newsBG addSubview:self.newsView];
    
    self.testTableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-49)
                          style:UITableViewStylePlain];
    self.testTableView.delegate = self;
    self.testTableView.dataSource = self;
    [self adjustTableViewInsert];
    self.testTableView.tableHeaderView = self.newsBG;
    [self.view addSubview:self.testTableView];
    
    self.detailArray = [[NSArray alloc] init];
    self.detailArray = [[[JJDirectionManage alloc] init] analyseJsonForVC:self];
    linkArray = [[NSMutableArray alloc] init];
    for (int i=0; i<self.detailArray.count; i++)
    {
        JJDirectionModel *model = [self.detailArray objectAtIndex:i];
        [linkArray addObject:model.link];
    }
    //防止下拉位子异常
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self adjustTableViewInsert];
    }
    [self addTableViewTrag];
}

- (void)pop
{
    [self.navigationController pushViewController:[[ShakeViewController alloc] init] animated:YES];
}

- (void)adjustTableViewInsert
{
    UIEdgeInsets insets = self.testTableView.contentInset;
    insets.top = self.navigationController.navigationBar.frame.size.height +
    [UIApplication sharedApplication].statusBarFrame.size.height;
    self.testTableView.contentInset = insets;
    self.testTableView.scrollIndicatorInsets = insets;
}

- (void)addTableViewTrag
{
    __weak JJTestViewController *weakself = self;
    [weakself.testTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.testTableView.pullToRefreshView stopAnimating];
            self.detailArray = [[[JJDirectionManage alloc] init] analyseJsonForVC:self];
            [self.testTableView reloadData];
        });
    }];
//    
//    [weakself.testTableView addInfiniteScrollingWithActionHandler:^{
//        int64_t delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^{
//            
////            [self.testTableView reloadData];
//            [weakself.testTableView.infiniteScrollingView stopAnimating];
//        });
//    }];
    
}

- (NSInteger)numberOfPages
{
    return pages;
}


- (UIView *)pageAtIndex:(NSInteger)index
{
    UIImageView *newsImage = [[UIImageView alloc]
                              initWithFrame:CGRectMake(0, 0, 320, ScrollViewHeight)];
    newsImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"testImg%ld", (long)index]];
    return newsImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
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
    JJDirectionModel *model = [self.detailArray objectAtIndex:indexPath.row];
//    [lableSwitchCell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, model.tdPic]]];
    lableSwitchCell.imgView.image = model.directionImage;
    lableSwitchCell.nameLabel.text = [NSString stringWithFormat:@" %@", model.tdName];
    [lableSwitchCell.nameLabel resizeToFit];
//    lableSwitchCell.nameLabel.text = @"";
//    lableSwitchCell.detailLa.text = @"";
//    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, 150, 60)];
//    titleLa.text = [NSString stringWithFormat:@"%@", model.tdName];
//    titleLa.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
//    [titleLa resizeToFit];
//    [lableSwitchCell addSubview:titleLa];
    lableSwitchCell.personNums.text = [NSString stringWithFormat:@"%d", model.tdpersonnum];
    lableSwitchCell.detailLa.text = @"想知道自己的Java水平吗？那就来Java技术测试来试试自己的能力吧";
    lableSwitchCell.testNumLa.text = [NSString stringWithFormat:@"%d", model.testnum];    lableSwitchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return lableSwitchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJTestDivideViewController *vc =  [[JJTestDivideViewController alloc] initWithDetailUrl:[linkArray objectAtIndex:indexPath.row]];
    JJTestTableViewCell *cell = (JJTestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    vc.title = cell.nameLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
