//
//  RankingViewController.m
//  ME
//
//  Created by Johnny's on 14-8-7.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "RankingViewController.h"
#import "ScoreTableViewCell.h"
#import "RankingManage.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "TestDirectionManage.h"
#import "TestDirectionBaseClass.h"
#import "testModelBaseClass.h"
#import "FightModelBaseClass.h"

typedef NS_ENUM(NSInteger, pickerViewComponent) {
    pickerViewComponentDirection = 0,
    pickerViewComponentTest
};

typedef NS_ENUM(NSInteger, segmentControl) {
    segmentControlCapacity = 0,
    segmentControlTest
};

@interface RankingViewController ()

@end

@implementation RankingViewController

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
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    UILabel *titleLa = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 80, 44)];
    titleLa.text = @"排行榜";
    titleLa.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLa];
    titleView.userInteractionEnabled = YES;
    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 22, 22)];
    [dismissBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    dismissBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(back)
         forControlEvents:UIControlEventTouchUpInside];
    UIButton *touchBtn = [[UIButton alloc] initWithFrame:CGRectMake(235, 22, 80, 40)];
    touchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [touchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [touchBtn setTitle:@"选择排行榜" forState:UIControlStateNormal];
    [touchBtn addTarget:self action:@selector(touch)
        forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:touchBtn];
    [titleView addSubview:dismissBtn];
    [self.view addSubview:titleView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 0.5)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.segmentedControl addTarget:self
                              action:@selector(selectRanking:)
                    forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = segmentControlCapacity;
    
    self.rankTableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 100, 320, SCREEN_HEIGHT-100)];
    self.rankTableView.delegate = self;
    self.rankTableView.dataSource = self;
    self.rankTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.rankTableView];
    
    self.pickerView = [[UIPickerView alloc]
                         initWithFrame:CGRectMake(0, SCREEN_HEIGHT-160, 320, 160)];
    self.pickerView.backgroundColor = RGBCOLOR(38, 130, 213);
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150, SCREEN_HEIGHT/2-10, 20, 20)];
    [self.activityView startAnimating];
    self.activityView.color = [UIColor blackColor];
    [self.view addSubview:self.activityView];
    
    self.directionPowerArray = [[[TestDirectionManage alloc] init] analyseFightJson:@"http://121.197.10.159:8080/MobileEducation/listSdirection"];

    self.directionTestArray = [[[TestDirectionManage alloc] init] analyseJson:@"http://121.197.10.159:8080/MobileEducation/listStestDirection"];
    self.showTestArray = [[[TestDirectionManage alloc] init] analyseTestJson:
                          [NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listStest?tdirection=%d", 1]];
    
    self.testArray = [NSMutableArray new];
    for (int i=0; i<self.directionTestArray.count; i++)
    {
        if (i==0)
        {
            [self.testArray addObject:self.showTestArray];
        }
        else
        {
            NSArray *array = [NSArray new];
            [self.testArray addObject:array];
        }
    }
    
    [[[RankingManage alloc] init] getRankingForVC:self
                                          withUrl:@"http://121.197.10.159:8080/MobileEducation/listFight?did=1"];
}

#pragma mark pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger selectedSegmentIndex = [self.segmentedControl selectedSegmentIndex];
    if (selectedSegmentIndex == segmentControlCapacity)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger selectedSegmentIndex = [self.segmentedControl selectedSegmentIndex];
    if (selectedSegmentIndex == segmentControlCapacity)
    {
        return self.directionPowerArray.count;
    }
    else
    {
        if (component == pickerViewComponentDirection)
        {
            return self.directionTestArray.count;
        }
        else
        {
            return self.showTestArray.count;
        }
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger selectedSegmentIndex = [self.segmentedControl selectedSegmentIndex];
    if (selectedSegmentIndex == segmentControlCapacity)
    {
        FightModelBaseClass *model = [self.directionPowerArray objectAtIndex:row];
        [[[RankingManage alloc] init] getRankingForVC:self
                                              withUrl:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listFight?did=%d", (int)model.cDid]];
    }
    else
    {
        if (component == pickerViewComponentDirection)
        {
            NSArray *temArray = self.testArray[row];
            if (temArray.count == 0)
            {
                NSArray *array = [[[TestDirectionManage alloc] init] analyseTestJson:
                                  [NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listStest?tdirection=%d", row+1]];
                [self.testArray replaceObjectAtIndex:row withObject:array];
            }
            self.showTestArray = [self.testArray objectAtIndex:row];
            testModelBaseClass *model = [self.showTestArray objectAtIndex:0];
            [[[RankingManage alloc] init] getRankingForVC:self
                                                  withUrl:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listScore?tcId=%d", (int)model.tcId]];
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
            [self.pickerView reloadComponent:pickerViewComponentTest];
        }
        else
        {
            testModelBaseClass *model = [self.showTestArray objectAtIndex:row];
            [[[RankingManage alloc] init] getRankingForVC:self
                                                  withUrl:[NSString stringWithFormat:@"http://121.197.10.159:8080/MobileEducation/listScore?tcId=%d", (int)model.tcId]];
        }
    }
    [self.activityView startAnimating];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSInteger selectedSegmentIndex = [self.segmentedControl selectedSegmentIndex];
    if (selectedSegmentIndex == segmentControlCapacity)
    {
        FightModelBaseClass *model = [self.directionPowerArray objectAtIndex:row];
        NSString *result = nil;
        result = model.cDhead;
        return result;
    }
    else
    {
        if (component == pickerViewComponentDirection)
        {
            NSString *result = nil;
            TestDirectionBaseClass *model = [self.directionTestArray objectAtIndex:row];
            result = model.tdName;
            return result;
        }
        else
        {
            NSString *result = nil;
            testModelBaseClass *model = [self.showTestArray objectAtIndex:row];
            result = model.tcName;
            return result;
        }
    }


}

#pragma mark tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreTableViewCell * lableSwitchCell;
    UINib *n;
    static NSString *CellIdentifier = @"ScoreTableViewCell";
    lableSwitchCell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (lableSwitchCell == nil)
    {
        NSArray *_nib=[[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell"
                                                    owner:self  options:nil];
        lableSwitchCell  = [_nib objectAtIndex:0];
        //通过这段代码，来完成LableSwitchXibCell的ReuseIdentifier的设置
        //这里是比较容易忽视的，若没有此段，再次载入LableSwitchXibCell时，dequeueReusableCellWithIdentifier:的值依然为nil
        n= [UINib nibWithNibName:@"PlayScoreviewCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:n forCellReuseIdentifier:@"PlayScoreviewCell"];
    }
    lableSwitchCell.timeLa.text = @"";
    lableSwitchCell.scoreLa.text = @"";
    lableSwitchCell.powerLa.text = @"";
    if (self.rankShowArray.count > indexPath.row)
    {
        if (self.segmentedControl.selectedSegmentIndex == segmentControlCapacity)
        {

            RangkingModel *model = [self.rankShowArray objectAtIndex:indexPath.row];
            lableSwitchCell.nameLa.text = model.userName;
            [lableSwitchCell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, model.userPortrait]]];
            lableSwitchCell.powerLa.text = [NSString stringWithFormat:@"战斗力高达：%d", (int)model.score];
        }
        else
        {
            RangkingModel *model = [self.rankShowArray objectAtIndex:indexPath.row];
            lableSwitchCell.nameLa.text = model.userName;
            [lableSwitchCell.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseURL, model.userPortrait]]];
            lableSwitchCell.timeLa.text = [NSString stringWithFormat:@"共%d分%d秒", (int)model.hmtime, (int)model.hstime];
            lableSwitchCell.scoreLa.text = [NSString stringWithFormat:@"考%d分", (int)model.score];
        }
    }

    lableSwitchCell.rankingLa.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    [lableSwitchCell.imageBtn addTarget:self
                                 action:@selector(touchImage:)
                       forControlEvents:UIControlEventTouchUpInside];
    lableSwitchCell.imageBtn.tag = indexPath.row;
    if (indexPath.row>2)
    {
        lableSwitchCell.rankingLa.textColor = [UIColor blackColor];
    }
    [lableSwitchCell.dismissBtn addTarget:self
                                   action:@selector(dismiss)
                         forControlEvents:UIControlEventTouchUpInside];
    return lableSwitchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark button

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.pickerView.frame;
        if (frame.origin.y == SCREEN_HEIGHT-160)
        {
            frame.origin.y = SCREEN_HEIGHT;
        }
        self.pickerView.frame = frame;
    }];

}

- (void)touchImage:(UIButton *)sender
{
    if (self.rankShowArray.count>sender.tag)
    {
        RangkingModel *model = [self.rankShowArray objectAtIndex:sender.tag];
        DetailViewController *detailVC = [[DetailViewController alloc] initWithUserId:
                                          [NSString stringWithFormat:@"%d", (int)model.userId]];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)touch
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.pickerView.frame;
        if (frame.origin.y == SCREEN_HEIGHT-160)
        {
            frame.origin.y = SCREEN_HEIGHT;
        }
        else
        {
            frame.origin.y = SCREEN_HEIGHT-160;
        }
        self.pickerView.frame = frame;
    }];
}

- (void)selectRanking:(UISegmentedControl *)sender
{
    NSInteger selectedSegmentIndex = [sender selectedSegmentIndex];
    if (selectedSegmentIndex == segmentControlCapacity)
    {
        [[[RankingManage alloc] init] getRankingForVC:self
                                              withUrl:@"http://121.197.10.159:8080/MobileEducation/listFight?did=1"];
    }
    else
    {
        [[[RankingManage alloc] init] getRankingForVC:self
                                              withUrl:@"http://121.197.10.159:8080/MobileEducation/listScore?tcId=1"];
    }
    [self.activityView startAnimating];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    [self.pickerView reloadAllComponents];
    [self.rankTableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
