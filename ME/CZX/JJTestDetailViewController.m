//
//  JJTestDetailViewController.m
//  TestVC
//
//  Created by Johnny's on 14-7-4.
//  Copyright (c) 2014年 Johnny's. All rights reserved.
//

#import "JJTestDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface JJTestDetailViewController ()
{
    NSArray *commentArray;
    JJTestModel *myModel;
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
        myModel = paramModel;
    }
    
    return self;
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
    
    UITableView *tableView = [[UITableView alloc]
                         initWithFrame:self.commentView.bounds style:UITableViewStylePlain];
    [self.commentView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"comment" ofType:@"plist"];
    commentArray = [NSArray arrayWithContentsOfFile:path];
    [self.introduceButton addTarget:self action:@selector(introduceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentButton addTarget:self action:@selector(commentButton:) forControlEvents:UIControlEventTouchUpInside];
    self.commentButton.backgroundColor = RGBCOLOR(227, 227, 227);
}

- (void)loadModel
{
    [self.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, myModel.tcPhotoUrl]]];
    self.directionLa.text = [NSString stringWithFormat:@"方向：%d", myModel.tdirection];
    self.timeLa.text = [NSString stringWithFormat:@"时长：%d", myModel.tcTime];
    self.subjectNumLa.text = [NSString stringWithFormat:@"题数：%d", myModel.subjectnums];
    self.scoreLa.text = [NSString stringWithFormat:@"总分：%d", myModel.tcScore];
    self.priceLa.text = [NSString stringWithFormat:@"价格：%d", myModel.tcPrice];
    self.testName.text = myModel.tcName;
    self.introduceView.text = myModel.tcIntro;
}

- (void)like
{
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!result)
    {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    result.imageView.image = [UIImage imageNamed:@"CuserPhoto"];
    NSArray *temArray = [commentArray objectAtIndex:[indexPath row]];
    result.textLabel.text = [temArray objectAtIndex:0];
    result.detailTextLabel.text= [temArray objectAtIndex:1];
    return result;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)introduceButton:(id)sender
{
    self.commentButton.backgroundColor = RGBCOLOR(227, 227, 227);
    self.introduceButton.backgroundColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.introduceView];
}

- (void)commentButton:(id)sender
{
    self.commentButton.backgroundColor = [UIColor whiteColor];
    self.introduceButton.backgroundColor = RGBCOLOR(227, 227, 227);
    [self.view bringSubviewToFront:self.commentView];
}

- (IBAction)buyOrEnter:(id)sender
{
    JJMeasurementViewController *measureVC = [[JJMeasurementViewController alloc] initWithSubjectDetailUrl:myModel.sublink];
    measureVC.title = self.testName.text;
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
