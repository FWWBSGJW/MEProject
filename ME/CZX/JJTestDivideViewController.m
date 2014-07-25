//
//  JJTestDivideViewController.m
//  ME
//
//  Created by Johnny's on 14-7-23.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "JJTestDivideViewController.h"
#import "JJTestModelManage.h"
#import "UIImageView+WebCache.h"
#import "JJTestTableViewCell.h"
#import "UILabel+dynamicSizeMe.h"
#import "JJTestDetailViewController.h"
#import "SVPullToRefresh.h"

@interface JJTestDivideViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *testArray;
    NSString *originUrl;
    JJTestModel *linkModel;
}
@end

@implementation JJTestDivideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDetailUrl:(NSString *)paramUrl
{
    self = [super init];
    if (self) {
        originUrl = paramUrl;
        testArray = [[NSMutableArray alloc] init];
        NSArray *temArray = [[[JJTestModelManage alloc] init] analyseTestJson:originUrl];
        [testArray addObjectsFromArray:temArray];
        linkModel = [testArray lastObject];
        [testArray removeLastObject];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    self.testTableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, 320, 440)
                          style:UITableViewStylePlain];
    self.testTableView.tableFooterView = [[UIView alloc] init];
    self.testTableView.delegate = self;
    self.testTableView.dataSource = self;
    [self.view addSubview:self.testTableView];
    [self adjustTableViewInsert];
    [self addTableViewTrag];
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self adjustTableViewInsert];
    }
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
    __weak JJTestDivideViewController *weakself = self;
    [weakself.testTableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.testTableView.pullToRefreshView stopAnimating];
            if (testArray.count==0)
            {
                testArray = [[NSMutableArray alloc] init];
                NSArray *temArray = [[[JJTestModelManage alloc] init] analyseTestJson:originUrl];
                [testArray addObjectsFromArray:temArray];
                [self.testTableView reloadData];
            }
        });
    }];

    [weakself.testTableView addInfiniteScrollingWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [weakself.testTableView.infiniteScrollingView stopAnimating];
            if (linkModel.nextPage) {
                NSArray *temArray = [[[JJTestModelManage alloc] init] analyseTestJson:linkModel.nextPage];
                [testArray addObjectsFromArray:temArray];
                linkModel = [testArray lastObject];
                [testArray removeLastObject];
                [self.testTableView reloadData];
            }
        });
    }];
    
}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    JJTestModel *testModel = [[JJTestModel alloc] init];
    testModel = [testArray objectAtIndex:indexPath.row];
    [lableSwitchCell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, testModel.tcPhotoUrl]]];
    lableSwitchCell.nameLabel.text = [NSString stringWithFormat:@" %@", testModel.tcName];
    lableSwitchCell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11];
    lableSwitchCell.personNums.text = [NSString stringWithFormat:@"%d", testModel.tcNum];
    [lableSwitchCell.nameLabel resizeToFit];
    lableSwitchCell.detailLa.text = testModel.tcIntro;
    lableSwitchCell.myLabel2.text = @"题数:";
    lableSwitchCell.testNumLa.text = [NSString stringWithFormat:@"%d", testModel.subjectnums];

    lableSwitchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return lableSwitchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JJTestModel *paramModel = [testArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[JJTestDetailViewController alloc] initWithModel:paramModel] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
