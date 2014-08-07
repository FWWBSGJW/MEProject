//
//  QATableViewController.m
//  ME
//
//  Created by qf on 14/8/5.
//  Copyright (c) 2014年 yatokami. All rights reserved.
//

#import "QATableViewController.h"
#import "QATableViewCell.h"
#import "QAViewController.h"
#import "DataOC.h"
@interface QATableViewController ()

@end

@implementation QATableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.tabBarController.tabBar.hidden = NO;
	self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"QACell";
	QATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(!cell){
		cell = [[QATableViewCell alloc] init];
	}
	NSDictionary *qa = [_data objectAtIndex:indexPath.row];
	NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	if (self.style == QAStyleQuestion) {
		cell.title = qa[@"qtitle"];
//		cell.date = qa[@"qdate"];
		NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
		NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
//		NSDate *date = [dateFormatter dateFromString:@"2014-08-07 12:56:22"];
		NSDate *date = [dateFormatter dateFromString:qa[@"qdate"]];
		NSLog(@"%@",[NSDate dateWithTimeIntervalSinceNow:interval]);
//		cell.date = [DataOC getTimeString:9997110000];
//		NSLog(@"%lf",[[NSDate dateWithTimeIntervalSinceNow:interval] timeIntervalSinceDate:date]);
//		NSLog(@"%lf",[[NSDate date] timeIntervalSince1970]);
		cell.date = [DataOC getTimeString:[date timeIntervalSince1970]];
		cell.content = qa[@"qcontent"];
	}else {
		cell.title = qa[@"qtitle"];
		cell.date = qa[@"atime"];
		cell.content = qa[@"acontent"];
	}
	[cell setUI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	UIViewController *vc = [[UIViewController alloc] init];
	vc.view.frame = [[UIScreen mainScreen] bounds];
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
	webView.scalesPageToFit = YES;
	NSString *urlStr ;
	if (self.style == QAStyleQuestion) {
		NSString *qid = [[_data objectAtIndex:indexPath.row] objectForKey:@"qid"];
		urlStr = [NSString stringWithFormat:@"%@MobileEducation/contentuser?qid=%@",kBaseURL,qid];
	}else{
		NSString *aid = [[_data objectAtIndex:indexPath.row] objectForKey:@"aid"];
		urlStr = [NSString stringWithFormat:@"%@MobileEducation/contentself?aid=%@",kBaseURL,aid];
	}
	NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
	
	
	[vc.view addSubview:webView];
	[self.navigationController pushViewController:vc animated:YES];
//	self.tabBarController.selectedIndex = 3;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
