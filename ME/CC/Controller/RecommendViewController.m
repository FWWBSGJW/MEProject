//
//  RecommendViewController.m
//  ME
//
//  Created by yato_kami on 14-8-12.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "RecommendViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserCenterTableViewController.h"

@interface RecommendViewController ()

@property (assign, nonatomic) NSInteger userID;
@property (assign, nonatomic) NSInteger courseID;
@property (strong, nonatomic) NSArray *personListArray;
@end

@implementation RecommendViewController

- (instancetype)initWithUserID:(NSInteger)userID andCourseID:(NSInteger)courseID
{
    self = [super initWithStyle:UITableViewStylePlain];
    if(self){
        self.courseID = courseID;
        self.userID = userID;
        self.title = @"推荐";
    }
    return self;
}

- (void)viewDidLoad
{
    [self loadRecommendPeopleListArray];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.personListArray ? 1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personListArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"这些人最近也在学习这门课程,可以关注一下~";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"recommendPersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *infoDic = self.personListArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:infoDic[@"userPortrait"]]];
    [cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"CuserPhoto"]];
    cell.textLabel.text = infoDic[@"userName"];
    NSInteger hours = [infoDic[@"hmtime"] integerValue];
    
    NSString *detailText;
    if(hours >= 24) detailText = [NSString stringWithFormat:@"%d天前",hours/24];
    else if(hours>0 && hours < 24) detailText = [NSString stringWithFormat:@"%d小时前",hours];
    else if(hours == 0) detailText = @"刚刚";
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *infoDic = self.personListArray[indexPath.row];
    UserCenterTableViewController *user = [[UserCenterTableViewController alloc] initWithUserId:[infoDic[@"userId"] integerValue]];
    [self.navigationController pushViewController:user animated:YES];
}

#pragma mark - 网路请求
//http://121.197.10.159:8080/MobileEducation/recommendUser?userId=1&cId=1
- (void)loadRecommendPeopleListArray{
    NSString *urlString = [NSString stringWithFormat:@"%@MobileEducation/recommendUser?userId=%d&cId=%d",kBaseURL,self.userID,self.courseID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *listArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.personListArray = listArray;
        [self.tableView reloadData];
    }];
}


@end
