//
//  ResultViewController.m
//  ME
//
//  Created by Johnny's on 14-9-11.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultBase.h"
#import "ResultManage.h"
#import "JJTestTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+dynamicSizeMe.h"
#import "CChapterViewController.h"
#import "UserCenterTableViewController.h"

@interface ResultViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *resultTableView;
@property(nonatomic, strong) NSArray *resultArray;
@property(nonatomic) BOOL isClass;
@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self)
    {
        NSString *dataGBK = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@  %@", url, dataGBK);
        self.resultArray = [[[ResultManage alloc] init] analyseJson:dataGBK];
        NSLog(@"%@", self.resultArray);
    }

    return self;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
//        NSString *urlAsString = @"http://121.197.10.159:8080/MobileEducation/searchUser?";
//        NSURL *url = [NSURL URLWithString:urlAsString];
//        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
//        [urlRequest setTimeoutInterval:30.0f];
//        [urlRequest setHTTPMethod:@"POST"];
//        NSString *body = [NSString stringWithFormat:@"userName=a%@", name];
//        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
//        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//        [NSURLConnection
//         sendAsynchronousRequest:urlRequest
//         queue:queue
//         completionHandler:^(NSURLResponse *response, NSData *data,
//                             NSError *error) {
//             //         [[[TrendManage alloc] init] getData:self];
//             if ([data length] >0 &&
//                 error == nil){
//                 NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                 NSLog(@"HTML = %@", html);
//             }
//             else if ([data length] == 0 &&
//                      error == nil){
//                 NSLog(@"Nothing was downloaded.");
//             }
//             else if (error != nil){
//                 NSLog(@"Error happened = %@", error);
//             }
//         }];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索结果";

    if (self.resultArray.count > 0)
    {
        self.resultTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.resultTableView.delegate = self;
        self.resultTableView.dataSource = self;
        self.resultTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:self.resultTableView];
        ResultBase *model = [self.resultArray objectAtIndex:0];
        if (model.cid>0)
        {
            _isClass = YES;
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(140, 220, 80, 40)];
        label.text = @"无结果";
        [self.view addSubview:label];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isClass == YES)
    {
        return 90;
    }
    else
    {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isClass == YES)
    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!cell)
//        {
//            cell = [[UITableViewCell alloc]
//                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//            cell.frame = CGRectMake(0, 0, 320, 90);
//        }
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        ResultBase *model = [_resultArray objectAtIndex:indexPath.row];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 120, 80)];
        [cell addSubview:img];
        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.197.10.159:8080%@", model.cPic]]];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 170, 30)];
        la.font = [UIFont systemFontOfSize:16];
        la.text = model.cName;
        [cell addSubview:la];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        ResultBase *model = [_resultArray objectAtIndex:indexPath.row];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 42, 42)];
        [cell addSubview:img];
        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.197.10.159:8080%@", model.userPortrait]]];
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 170, 30)];
        la.font = [UIFont systemFontOfSize:16];
        la.text = model.userName;
        [cell addSubview:la];
        return cell;

     
        return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ResultBase *model = [self.resultArray objectAtIndex:indexPath.row];
    if (_isClass == YES)
    {
        [self.navigationController pushViewController:[CChapterViewController chapterVCwithCourseID:model.cid] animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:[[UserCenterTableViewController alloc] initWithUserId:model.userId] animated:YES];
    }
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
