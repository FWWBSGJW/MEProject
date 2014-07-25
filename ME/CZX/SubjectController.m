//
//  SubjectController.m
//  ME
//
//  Created by Johnny's on 14-7-25.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "SubjectController.h"

@interface SubjectController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *myCorrectArray;
    NSArray *myPersonArray;
    NSArray *myQuestionArray;
    NSArray *myAnswerArray;
    NSMutableArray *myWrongArray;
    int page;
    UITableView *myTableView;
}
@end
#define KColor RGBCOLOR(222, 255, 170)

@implementation SubjectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCorrectAnswer:(NSArray *)correctArray personAnswer:(NSArray *)personArray questionArray:(NSArray *)queArray answerArray:(NSArray *)anArray page:(int)parmaPage
{
    self = [super init];
    if (self) {
        myCorrectArray = correctArray;
        myPersonArray = personArray;
        myQuestionArray = queArray;
        myAnswerArray = anArray;
        page = parmaPage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, 376)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:myTableView];
    
    [self createPagingBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    return cell;
}

- (void)createTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLa.text = @"查看题目";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLa];
    titleView.userInteractionEnabled = YES;
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 20, 50, 44)];
    [dismissBtn setTitle:@"返回" forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:dismissBtn];
    [self.view addSubview:titleView];
}

- (void)createPagingBtn
{
    self.upBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 440, 60, 40)];
    self.downBtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 440, 60, 40)];
    [self.upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    //    [self.downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    //    [self.upBtn setImage:[UIImage imageNamed:@"upUp"] forState:UIControlStateHighlighted];
    //    [self.downBtn setImage:[UIImage imageNamed:@"downUp"] forState:UIControlStateHighlighted];
    [self.upBtn setTitle:@"上一题" forState:UIControlStateNormal];
    [self.downBtn setTitle:@"下一题" forState:UIControlStateNormal];
    self.upBtn.backgroundColor = KColor;
    self.downBtn.backgroundColor = KColor;
    [self.upBtn addTarget:self action:@selector(upPage) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(downPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.upBtn];
    [self.view addSubview:self.downBtn];
}

- (void)upPage
{
    if (page != 0)
    {
        page--;
        [myTableView reloadData];
    }
}

- (void)downPage
{
    if (page<myQuestionArray.count-1)
    {
        page++;
        [myTableView reloadData];
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
