//
//  CCourseViewController.m
//  移动教育1.0
//
//  Created by yato_kami on 14-7-4.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

//  总课程方向，第一界面

#import "CCourseViewController.h"
#import "CCourseCell.h"
#import "CourseDirection.h"
#import "CDetailCourseViewController.h"
#import "UIImageView+AFNetworking.h"

@interface CCourseViewController ()

@property (strong, nonatomic) NSArray *courseDirectionArray; //课程方向内容数组

@property (weak, nonatomic) UIPageControl *pageControl; //分页

@property (strong, nonatomic) CouseAllDirection *courseAllDirection;//所有课程方向模型类

@end

@implementation CCourseViewController

#pragma mark - getter and setter

- (CouseAllDirection *)courseAllDirection
{
    if (!_courseAllDirection) {
        _courseAllDirection = [[CouseAllDirection alloc] init];
    }
    return _courseAllDirection;
}

- (NSArray *)courseDirectionArray
{
    if (!_courseDirectionArray) {        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CourseDirectionData.plist" ofType:nil];
//        _courseDirectionArray = [NSArray arrayWithContentsOfFile:filePath];
        
        if (self.courseAllDirection.allCourseDirectionArray == nil) {
  
            [self.courseAllDirection loadData];
            
            _courseDirectionArray = self.courseAllDirection.allCourseDirectionArray;
        }
        //NSLog(@"%@",_courseDirectionArray);
    
    }
    return _courseDirectionArray;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"课程";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.tabBarController.tabBar.isHidden) {
        [self.tabBarController.tabBar setHidden:NO];
    }
}

#pragma mark - 控制旋转
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //注册自定义单元格
    UINib *nib = [UINib nibWithNibName:@"CCourse" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"courseIdentifier"];
    
    //设置登陆按钮
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    [self.navigationItem setLeftBarButtonItem:loginItem animated:YES];
 
    //防止下拉位子异常
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = self.navigationController.navigationBar.bounds.size.height +
        [UIApplication sharedApplication].statusBarFrame.size.height;
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    
    __weak CCourseViewController *weakSelf = self;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshView];
    }];
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        NSLog(@"上拉");
//    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - login方法
- (void)login
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseDirectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"courseIdentifier";
    CCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
   
    
    CourseDirection *cd = nil;
    cd = self.courseDirectionArray[indexPath.row];
    
    //设置cell内容
    
    cell.tag = cd.CDid;
    cell.courseHeadLabel.text = cd.CDhead;
    cell.courseDetailLabel.text = cd.CDdescription;
    cell.coursePeopleNumLabel.text =  [NSString stringWithFormat:@"%d",cd.CDpeopleNum];
    cell.CoursetTimeLabel.text = [NSString stringWithFormat:@"%.1f小时",cd.CDtime];
    
    [cell.courseImageView setImageWithURL:[NSURL URLWithString:cd.CDimageUrlString] placeholderImage:[UIImage imageNamed:@"directionDefault"]];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



#pragma mark - 设置headview - 顶部浮动ad
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat imageHeight = 126;
    NSInteger imageNum = 3; //图片数量
    UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, imageHeight)];
    [headScrollView setBounces:NO];
    [headScrollView setShowsHorizontalScrollIndicator:NO];
    [headScrollView setContentSize:CGSizeMake(imageNum * SCREEN_WIDTH, imageHeight)];
    headScrollView.delegate = self;
    for (NSInteger i = 1; i <= imageNum; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, imageHeight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"headAd%ld",(long)i]];
        [headScrollView addSubview:imageView];
        [headScrollView setPagingEnabled:YES];
        
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setBounds:CGRectMake(0, 0, 150.0, 50.0)];
    [pageControl setBounds:CGRectMake(0, 0, 150.0, 50.0)];
    [pageControl setCenter:CGPointMake(SCREEN_WIDTH/2, imageHeight - 10)];
    [pageControl setNumberOfPages:imageNum];
    [pageControl setCurrentPage:0];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [pageControl setPageIndicatorTintColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.7 alpha:0.8]];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    return headScrollView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 126;
}

#pragma mark scrollView delegat
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNo = scrollView.contentOffset.x / SCREEN_WIDTH;
    [self.pageControl setCurrentPage:pageNo];
}

#pragma mark - selectCell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseDirection *CD = self.courseDirectionArray[indexPath.row];
 
    CDetailCourseViewController *detailCourseVC = [CDetailCourseViewController detailCourseVCwithCourseDirection:CD];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController pushViewController:detailCourseVC animated:YES];
    
}



#pragma mark - 页面数据刷新
- (void)refreshView
{
    __weak CCourseViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        self.courseAllDirection = nil;
        _courseDirectionArray = nil;
        
        //[self.courseAllDirection loadData];
        _courseDirectionArray = self.courseAllDirection.allCourseDirectionArray;
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
    
    
}



@end
